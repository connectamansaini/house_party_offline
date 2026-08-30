import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_session.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/prompts.dart';

part 'never_have_i_ever_game_event.dart';
part 'never_have_i_ever_game_state.dart';

/// Drives a single Never Have I Ever match. Unlike Mafia's phase-based FSM,
/// this game has one repeating beat — show a prompt, mark who matches it,
/// advance — so a single flat [NeverHaveIEverGameState] is enough; there's
/// no phase transition to model.
class NeverHaveIEverGameBloc
    extends Bloc<NeverHaveIEverGameEvent, NeverHaveIEverGameState> {
  NeverHaveIEverGameBloc({
    required NeverHaveIEverSetup setup,
    required NeverHaveIEverEngine engine,
  }) : _engine = engine,
       super(
         NeverHaveIEverGameState(
           session: engine.deal(
             setup.players,
             setup.config,
             kNeverHaveIEverPrompts,
           ),
         ),
       ) {
    on<NeverHaveIEverPlayerToggled>(_onPlayerToggled);
    on<NeverHaveIEverRoundConfirmed>(_onRoundConfirmed);
  }

  final NeverHaveIEverEngine _engine;

  void _onPlayerToggled(
    NeverHaveIEverPlayerToggled event,
    Emitter<NeverHaveIEverGameState> emit,
  ) {
    final selected = {...state.selectedIds};
    if (!selected.remove(event.id)) selected.add(event.id);
    emit(state.copyWith(selectedIds: selected));
  }

  void _onRoundConfirmed(
    NeverHaveIEverRoundConfirmed event,
    Emitter<NeverHaveIEverGameState> emit,
  ) {
    final session = _engine.applyRound(state.session, state.selectedIds);
    emit(NeverHaveIEverGameState(session: session));
  }
}
