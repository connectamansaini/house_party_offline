import 'package:get_it/get_it.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';

void registerNeverHaveIEverDependencies(GetIt sl) {
  sl.registerLazySingleton<NeverHaveIEverEngine>(NeverHaveIEverEngine.new);
}
