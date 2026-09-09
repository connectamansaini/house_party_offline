import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_session.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/domain/prompts.dart';

part 'most_likely_to_game_event.dart';
part 'most_likely_to_game_state.dart';

/// Drives a single Most Likely To match. Same shape as Never Have I Ever:
/// one repeating beat — show a prompt, mark who the group pointed at,
/// advance — so a single flat [MostLikelyToGameState] is enough.
class MostLikelyToGameBloc
    extends Bloc<MostLikelyToGameEvent, MostLikelyToGameState> {
  MostLikelyToGameBloc({
    required MostLikelyToSetup setup,
    required MostLikelyToEngine engine,
  }) : _engine = engine,
       super(
         MostLikelyToGameState(
           session: engine.deal(
             setup.players,
             setup.config,
             [...kMostLikelyToPrompts, ...setup.customPrompts],
           ),
         ),
       ) {
    on<MostLikelyToPlayerToggled>(_onPlayerToggled);
    on<MostLikelyToRoundConfirmed>(_onRoundConfirmed);
  }

  final MostLikelyToEngine _engine;

  void _onPlayerToggled(
    MostLikelyToPlayerToggled event,
    Emitter<MostLikelyToGameState> emit,
  ) {
    final selected = {...state.selectedIds};
    if (!selected.remove(event.id)) selected.add(event.id);
    emit(state.copyWith(selectedIds: selected));
  }

  void _onRoundConfirmed(
    MostLikelyToRoundConfirmed event,
    Emitter<MostLikelyToGameState> emit,
  ) {
    final session = _engine.applyRound(state.session, state.selectedIds);
    emit(MostLikelyToGameState(session: session));
  }
}
