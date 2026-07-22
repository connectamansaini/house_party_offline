import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/id.dart';
import '../../domain/entities/imposter_preferences.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/imposter_settings_repository.dart';
import '../../domain/repositories/word_pack_repository.dart';
import 'setup_state.dart';

/// Drives the imposter setup form: player roster, pack choice, and options.
///
/// On [init] it restores the last-used roster and options from
/// [ImposterSettingsRepository]; [persist] saves them again when a game starts.
class SetupCubit extends Cubit<SetupState> {
  SetupCubit(this._packs, this._settings) : super(const SetupState());

  final WordPackRepository _packs;
  final ImposterSettingsRepository _settings;

  /// Pack ids to reselect once packs finish loading (from saved prefs).
  List<String> _preferredPackIds = const [];

  /// Restores saved preferences (or seeds defaults), then loads packs.
  Future<void> init() async {
    final prefs = await _settings.load();
    _preferredPackIds = prefs?.selectedPackIds ?? const [];

    final players = (prefs != null && prefs.playerNames.isNotEmpty)
        ? [for (final name in prefs.playerNames) Player(id: newId(), name: name)]
        : _defaultRoster(SetupState.minPlayers);

    var seeded = state.copyWith(
      players: players,
      imposterCount: prefs?.imposterCount ?? state.imposterCount,
      categoryHintEnabled: prefs?.categoryHintEnabled ?? state.categoryHintEnabled,
      discussionMinutes: prefs?.discussionMinutes ?? state.discussionMinutes,
      crewWinPoints: prefs?.crewWinPoints ?? state.crewWinPoints,
      imposterWinPoints: prefs?.imposterWinPoints ?? state.imposterWinPoints,
    );
    seeded = seeded.copyWith(
      imposterCount: _clampImposters(seeded.imposterCount, players.length),
    );
    emit(seeded);

    await loadPacks();
  }

  /// Saves the current roster and options for next time.
  Future<void> persist() async {
    await _settings.save(
      ImposterPreferences(
        playerNames: state.players.map((p) => p.name).toList(),
        imposterCount: state.imposterCount,
        categoryHintEnabled: state.categoryHintEnabled,
        discussionMinutes: state.discussionMinutes,
        crewWinPoints: state.crewWinPoints,
        imposterWinPoints: state.imposterWinPoints,
        selectedPackIds: state.selectedPackIds.toList(),
      ),
    );
  }

  Future<void> loadPacks() async {
    emit(state.copyWith(packsStatus: PacksStatus.loading));
    try {
      final packs = await _packs.getPacks();
      emit(
        state.copyWith(
          packsStatus: PacksStatus.ready,
          availablePacks: packs,
          selectedPackIds: _initialSelection(packs),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          packsStatus: PacksStatus.error,
          errorMessage: 'Could not load word packs: $e',
        ),
      );
    }
  }

  void addPlayer() {
    if (state.players.length >= SetupState.maxPlayers) return;
    final players = [
      ...state.players,
      Player(id: newId(), name: 'Player ${state.players.length + 1}'),
    ];
    emit(state.copyWith(players: players));
  }

  void removePlayer(String id) {
    final players = state.players.where((p) => p.id != id).toList();
    emit(
      state.copyWith(
        players: players,
        imposterCount: _clampImposters(state.imposterCount, players.length),
      ),
    );
  }

  void renamePlayer(String id, String name) {
    final players = [
      for (final p in state.players)
        if (p.id == id) p.copyWith(name: name) else p,
    ];
    emit(state.copyWith(players: players));
  }

  /// Adds or removes a pack from the selection.
  void togglePack(String packId) {
    final ids = Set<String>.of(state.selectedPackIds);
    if (!ids.remove(packId)) ids.add(packId);
    emit(state.copyWith(selectedPackIds: ids));
  }

  void selectAllPacks() {
    emit(
      state.copyWith(
        selectedPackIds: state.availablePacks.map((p) => p.id).toSet(),
      ),
    );
  }

  void clearPacks() {
    emit(state.copyWith(selectedPackIds: const {}));
  }

  void setImposterCount(int count) {
    emit(
      state.copyWith(
        imposterCount: _clampImposters(count, state.players.length),
      ),
    );
  }

  void setCategoryHint(bool enabled) {
    emit(state.copyWith(categoryHintEnabled: enabled));
  }

  void setDiscussionMinutes(int minutes) {
    emit(state.copyWith(discussionMinutes: minutes.clamp(1, 15)));
  }

  void setCrewWinPoints(int points) {
    emit(state.copyWith(crewWinPoints: points.clamp(1, 10)));
  }

  void setImposterWinPoints(int points) {
    emit(state.copyWith(imposterWinPoints: points.clamp(1, 10)));
  }

  List<Player> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      Player(id: newId(), name: 'Player ${i + 1}'),
  ];

  /// Chooses the initial pack selection once packs load: keeps any current
  /// selection, else the saved preferences (dropping packs that no longer
  /// exist), else defaults to the first available pack.
  Set<String> _initialSelection(List<WordPack> packs) {
    final available = packs.map((p) => p.id).toSet();
    if (state.selectedPackIds.isNotEmpty) {
      final kept = state.selectedPackIds.intersection(available);
      if (kept.isNotEmpty) return kept;
    }
    final preferred = _preferredPackIds.toSet().intersection(available);
    if (preferred.isNotEmpty) return preferred;
    return packs.isEmpty ? <String>{} : {packs.first.id};
  }

  /// Keeps the imposter count within `1..(playerCount - 1)`.
  int _clampImposters(int count, int playerCount) {
    final max = playerCount <= 1 ? 1 : playerCount - 1;
    return count.clamp(1, max);
  }
}
