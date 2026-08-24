import 'package:get_it/get_it.dart';

import 'package:house_party_offline/src/mafia/domain/engine/mafia_engine.dart';

/// Dependencies for the Mafia feature.
void registerMafiaDependencies(GetIt sl) {
  sl.registerLazySingleton<MafiaEngine>(MafiaEngine.new);
}
