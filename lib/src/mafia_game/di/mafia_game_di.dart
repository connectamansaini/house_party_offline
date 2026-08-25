import 'package:get_it/get_it.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';

/// Dependencies for the Mafia game engine.
///
/// [MafiaEngine] is pure, stateless, synchronous compute — no repository or
/// datasource sits in front of it, so there is no usecase to wrap it in; the
/// engine itself is already the right abstraction level.
void registerMafiaGameDependencies(GetIt sl) {
  sl.registerLazySingleton<MafiaEngine>(MafiaEngine.new);
}
