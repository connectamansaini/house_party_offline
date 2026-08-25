import 'package:get_it/get_it.dart';
import 'package:house_party_offline/src/imposter_game/domain/engine/round_engine.dart';

/// Dependencies for the Imposter game engine.
///
/// [RoundEngine] is pure, stateless, synchronous compute — no repository or
/// datasource sits in front of it, so there is no usecase to wrap it in; the
/// engine itself is already the right abstraction level.
void registerImposterGameDependencies(GetIt sl) {
  sl.registerLazySingleton<RoundEngine>(RoundEngine.new);
}
