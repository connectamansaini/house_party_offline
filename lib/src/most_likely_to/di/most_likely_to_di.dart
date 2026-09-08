import 'package:get_it/get_it.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';

void registerMostLikelyToDependencies(GetIt sl) {
  sl.registerLazySingleton<MostLikelyToEngine>(MostLikelyToEngine.new);
}
