import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_kind.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_session.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/prompts.dart';

part 'truth_or_dare_game_event.dart';
part 'truth_or_dare_game_state.dart';

/// Drives a single Truth or Dare match. Each turn has two beats — choose,
/// then face the prompt — which is a nullable [TruthOrDareGameState.prompt]
/// on one flat state rather than a phase machine.
class TruthOrDareGameBloc
    extends Bloc<TruthOrDareGameEvent, TruthOrDareGameState> {
  TruthOrDareGameBloc({
    required TruthOrDareSetup setup,
    required TruthOrDareEngine engine,
  }) : _engine = engine,
       super(
         TruthOrDareGameState(
           session: engine.deal(
             setup.players,
             setup.config,
             truths: [...truthsFor(setup.config.level), ...setup.customTruths],
             dares: [...daresFor(setup.config.level), ...setup.customDares],
           ),
         ),
       ) {
    on<TruthOrDareKindChosen>(_onKindChosen);
    on<TruthOrDareTurnResolved>(_onTurnResolved);
  }

  final TruthOrDareEngine _engine;

  void _onKindChosen(
    TruthOrDareKindChosen event,
    Emitter<TruthOrDareGameState> emit,
  ) {
    if (state.prompt != null) return;
    final drawn = _engine.draw(state.session, event.kind);
    emit(
      TruthOrDareGameState(
        session: drawn.session,
        kind: event.kind,
        prompt: drawn.prompt,
      ),
    );
  }

  void _onTurnResolved(
    TruthOrDareTurnResolved event,
    Emitter<TruthOrDareGameState> emit,
  ) {
    if (state.prompt == null) return;
    emit(
      TruthOrDareGameState(
        session: _engine.resolve(state.session, done: event.done),
      ),
    );
  }
}
