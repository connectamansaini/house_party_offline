import 'package:get_it/get_it.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';

void registerTruthOrDareDependencies(GetIt sl) {
  sl.registerLazySingleton<TruthOrDareEngine>(TruthOrDareEngine.new);
}
