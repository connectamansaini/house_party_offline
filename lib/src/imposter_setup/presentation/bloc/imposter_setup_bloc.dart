import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_setup.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/imposter_mode.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/load_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/save_imposter_setup_preferences_usecase.dart';

part 'imposter_setup_event.dart';
part 'imposter_setup_state.dart';

/// Drives the imposter setup form: player roster, pack choice, and options.
///
/// On [ImposterSetupStarted] it restores the last-used roster and options via
/// [LoadImposterSetupPreferencesUseCase], then loads the available word packs
/// via [GetImposterPacksUseCase]. [persist] saves the current form back for
/// next time — kept as a plain method rather than an event, because the
/// setup page awaits it and then navigates; routing a one-shot save through
/// the event/state pipeline would need a status flag nothing else reads.
class ImposterSetupBloc extends Bloc<ImposterSetupEvent, ImposterSetupState> {
  ImposterSetupBloc(
    this._loadPreferences,
    this._savePreferences,
    this._getPacks,
  ) : super(const ImposterSetupState()) {
    on<ImposterSetupStarted>(_onStarted);
    on<ImposterSetupPacksRefreshRequested>(_onPacksRefreshRequested);
    on<ImposterSetupPlayerAdded>(_onPlayerAdded);
    on<ImposterSetupPlayerRemoved>(_onPlayerRemoved);
    on<ImposterSetupPlayerRenamed>(_onPlayerRenamed);
    on<ImposterSetupPackToggled>(_onPackToggled);
    on<ImposterSetupAllPacksSelected>(_onAllPacksSelected);
    on<ImposterSetupPacksCleared>(_onPacksCleared);
    on<ImposterSetupImposterCountChanged>(_onImposterCountChanged);
    on<ImposterSetupImposterModeChanged>(_onImposterModeChanged);
    on<ImposterSetupCategoryHintChanged>(_onCategoryHintChanged);
    on<ImposterSetupSecretVotingChanged>(_onSecretVotingChanged);
    on<ImposterSetupDiscussionMinutesChanged>(_onDiscussionMinutesChanged);
    on<ImposterSetupCivilianWinPointsChanged>(_onCivilianWinPointsChanged);
    on<ImposterSetupImposterWinPointsChanged>(_onImposterWinPointsChanged);
  }

  final LoadImposterSetupPreferencesUseCase _loadPreferences;
  final SaveImposterSetupPreferencesUseCase _savePreferences;
  final GetImposterPacksUseCase _getPacks;

  /// Pack ids to reselect once packs finish loading (from saved prefs).
  List<String> _preferredPackIds = const [];

  Future<void> _onStarted(
    ImposterSetupStarted event,
    Emitter<ImposterSetupState> emit,
  ) async {
    final prefs = await _loadPreferences();
    _preferredPackIds = prefs?.selectedPackIds ?? const [];

    final players = (prefs != null && prefs.playerNames.isNotEmpty)
        ? [
            for (final name in prefs.playerNames)
              Player(id: newId(), name: name),
          ]
        : _defaultRoster(ImposterSetupState.minPlayers);

    var seeded = state.copyWith(
      players: players,
      imposterCount: prefs?.imposterCount ?? state.imposterCount,
      imposterMode: prefs?.imposterMode ?? state.imposterMode,
      categoryHintEnabled:
          prefs?.categoryHintEnabled ?? state.categoryHintEnabled,
      secretVoting: prefs?.secretVoting ?? state.secretVoting,
      discussionMinutes: prefs?.discussionMinutes ?? state.discussionMinutes,
      civilianWinPoints: prefs?.civilianWinPoints ?? state.civilianWinPoints,
      imposterWinPoints: prefs?.imposterWinPoints ?? state.imposterWinPoints,
    );
    seeded = seeded.copyWith(
      imposterCount: _clampImposters(seeded.imposterCount, players.length),
    );
    emit(seeded);

    await _loadPacks(emit);
  }

  Future<void> _onPacksRefreshRequested(
    ImposterSetupPacksRefreshRequested event,
    Emitter<ImposterSetupState> emit,
  ) => _loadPacks(emit);

  Future<void> _loadPacks(Emitter<ImposterSetupState> emit) async {
    emit(state.copyWith(packsStatus: ImposterSetupPacksStatus.loading));
    try {
      final packs = await _getPacks();
      emit(
        state.copyWith(
          packsStatus: ImposterSetupPacksStatus.ready,
          availablePacks: packs,
          selectedPackIds: _initialSelection(packs),
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          packsStatus: ImposterSetupPacksStatus.error,
          errorMessage: 'Could not load word packs: $e',
        ),
      );
    }
  }

  void _onPlayerAdded(
    ImposterSetupPlayerAdded event,
    Emitter<ImposterSetupState> emit,
  ) {
    if (state.players.length >= ImposterSetupState.maxPlayers) return;
    final players = [
      ...state.players,
      Player(id: newId(), name: 'Player ${state.players.length + 1}'),
    ];
    emit(state.copyWith(players: players));
  }

  void _onPlayerRemoved(
    ImposterSetupPlayerRemoved event,
    Emitter<ImposterSetupState> emit,
  ) {
    final players = state.players.where((p) => p.id != event.id).toList();
    emit(
      state.copyWith(
        players: players,
        imposterCount: _clampImposters(state.imposterCount, players.length),
      ),
    );
  }

  void _onPlayerRenamed(
    ImposterSetupPlayerRenamed event,
    Emitter<ImposterSetupState> emit,
  ) {
    final players = [
      for (final p in state.players)
        if (p.id == event.id) p.copyWith(name: event.name) else p,
    ];
    emit(state.copyWith(players: players));
  }

  void _onPackToggled(
    ImposterSetupPackToggled event,
    Emitter<ImposterSetupState> emit,
  ) {
    final ids = Set<String>.of(state.selectedPackIds);
    if (!ids.remove(event.packId)) ids.add(event.packId);
    emit(state.copyWith(selectedPackIds: ids));
  }

  void _onAllPacksSelected(
    ImposterSetupAllPacksSelected event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(
      state.copyWith(
        selectedPackIds: state.availablePacks.map((p) => p.id).toSet(),
      ),
    );
  }

  void _onPacksCleared(
    ImposterSetupPacksCleared event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(selectedPackIds: const {}));
  }

  void _onImposterCountChanged(
    ImposterSetupImposterCountChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(
      state.copyWith(
        imposterCount: _clampImposters(event.count, state.players.length),
      ),
    );
  }

  void _onImposterModeChanged(
    ImposterSetupImposterModeChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(imposterMode: event.mode));
  }

  void _onCategoryHintChanged(
    ImposterSetupCategoryHintChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(categoryHintEnabled: event.enabled));
  }

  void _onSecretVotingChanged(
    ImposterSetupSecretVotingChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(secretVoting: event.enabled));
  }

  void _onDiscussionMinutesChanged(
    ImposterSetupDiscussionMinutesChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(discussionMinutes: event.minutes.clamp(1, 15)));
  }

  void _onCivilianWinPointsChanged(
    ImposterSetupCivilianWinPointsChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(civilianWinPoints: event.points.clamp(1, 10)));
  }

  void _onImposterWinPointsChanged(
    ImposterSetupImposterWinPointsChanged event,
    Emitter<ImposterSetupState> emit,
  ) {
    emit(state.copyWith(imposterWinPoints: event.points.clamp(1, 10)));
  }

  /// Saves the current roster and options for next time.
  Future<void> persist() {
    return _savePreferences(
      ImposterSetupPreferencesEntity(
        playerNames: state.players.map((p) => p.name).toList(),
        imposterCount: state.imposterCount,
        imposterMode: state.imposterMode,
        categoryHintEnabled: state.categoryHintEnabled,
        secretVoting: state.secretVoting,
        discussionMinutes: state.discussionMinutes,
        civilianWinPoints: state.civilianWinPoints,
        imposterWinPoints: state.imposterWinPoints,
        selectedPackIds: state.selectedPackIds.toList(),
      ),
    );
  }

  List<Player> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      Player(id: newId(), name: 'Player ${i + 1}'),
  ];

  /// Chooses the initial pack selection once packs load: keeps any current
  /// selection, else the saved preferences (dropping packs that no longer
  /// exist), else defaults to the first available pack.
  Set<String> _initialSelection(List<ImposterPackEntity> packs) {
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
