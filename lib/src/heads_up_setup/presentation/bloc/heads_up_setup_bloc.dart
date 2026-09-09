import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_setup.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/roster/domain/roster_seed.dart';

part 'heads_up_setup_event.dart';
part 'heads_up_setup_state.dart';

/// Drives the Heads Up setup form: roster, word packs, turn length and
/// turn count.
///
/// Seeds numbered defaults synchronously, then [HeadsUpSetupStarted] swaps
/// in the shared roster's names and loads the word packs — every pack is
/// selected to begin with, since variety is the point of the game.
class HeadsUpSetupBloc extends Bloc<HeadsUpSetupEvent, HeadsUpSetupState> {
  HeadsUpSetupBloc(this._roster, this._getPacks)
    : super(
        HeadsUpSetupState(players: _defaultRoster(HeadsUpConfig.minPlayers)),
      ) {
    on<HeadsUpSetupStarted>(_onStarted);
    on<HeadsUpSetupRosterSaved>(_onRosterSaved);
    on<HeadsUpSetupPlayerAdded>(_onPlayerAdded);
    on<HeadsUpSetupPlayerRemoved>(_onPlayerRemoved);
    on<HeadsUpSetupPlayerRenamed>(_onPlayerRenamed);
    on<HeadsUpSetupPackToggled>(_onPackToggled);
    on<HeadsUpSetupRoundSecondsChanged>(_onRoundSecondsChanged);
    on<HeadsUpSetupRoundCountChanged>(_onRoundCountChanged);
  }

  final RosterRepository _roster;
  final GetImposterPacksUseCase _getPacks;

  Future<void> _onStarted(
    HeadsUpSetupStarted event,
    Emitter<HeadsUpSetupState> emit,
  ) async {
    final saved = await _roster.loadNames();
    emit(
      state.copyWith(
        players: saved.isEmpty
            ? state.players
            : [
                for (final name in seedRosterNames(
                  saved,
                  min: HeadsUpConfig.minPlayers,
                  max: HeadsUpConfig.maxPlayers,
                ))
                  HeadsUpPlayer(id: newId(), name: name),
              ],
      ),
    );

    try {
      final packs = await _getPacks();
      emit(
        state.copyWith(
          packsStatus: HeadsUpPacksStatus.ready,
          availablePacks: packs,
          selectedPackIds: packs.map((p) => p.id).toSet(),
        ),
      );
    } on Object catch (_) {
      emit(state.copyWith(packsStatus: HeadsUpPacksStatus.error));
    }
  }

  Future<void> _onRosterSaved(
    HeadsUpSetupRosterSaved event,
    Emitter<HeadsUpSetupState> emit,
  ) => _roster.saveNames([for (final p in state.players) p.name]);

  void _onPlayerAdded(
    HeadsUpSetupPlayerAdded event,
    Emitter<HeadsUpSetupState> emit,
  ) {
    if (state.players.length >= HeadsUpConfig.maxPlayers) return;
    emit(
      state.copyWith(
        players: [
          ...state.players,
          HeadsUpPlayer(
            id: newId(),
            name: 'Player ${state.players.length + 1}',
          ),
        ],
      ),
    );
  }

  void _onPlayerRemoved(
    HeadsUpSetupPlayerRemoved event,
    Emitter<HeadsUpSetupState> emit,
  ) {
    emit(
      state.copyWith(
        players: state.players.where((p) => p.id != event.id).toList(),
      ),
    );
  }

  void _onPlayerRenamed(
    HeadsUpSetupPlayerRenamed event,
    Emitter<HeadsUpSetupState> emit,
  ) {
    emit(
      state.copyWith(
        players: [
          for (final p in state.players)
            if (p.id == event.id) p.copyWith(name: event.name) else p,
        ],
      ),
    );
  }

  void _onPackToggled(
    HeadsUpSetupPackToggled event,
    Emitter<HeadsUpSetupState> emit,
  ) {
    final ids = Set<String>.of(state.selectedPackIds);
    if (!ids.remove(event.packId)) ids.add(event.packId);
    emit(state.copyWith(selectedPackIds: ids));
  }

  void _onRoundSecondsChanged(
    HeadsUpSetupRoundSecondsChanged event,
    Emitter<HeadsUpSetupState> emit,
  ) {
    if (!HeadsUpConfig.secondsOptions.contains(event.seconds)) return;
    emit(
      state.copyWith(
        config: state.config.copyWith(roundSeconds: event.seconds),
      ),
    );
  }

  void _onRoundCountChanged(
    HeadsUpSetupRoundCountChanged event,
    Emitter<HeadsUpSetupState> emit,
  ) {
    final count = event.count.clamp(
      HeadsUpConfig.minRounds,
      HeadsUpConfig.maxRounds,
    );
    emit(state.copyWith(config: state.config.copyWith(roundCount: count)));
  }

  static List<HeadsUpPlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      HeadsUpPlayer(id: newId(), name: 'Player ${i + 1}'),
  ];
}
