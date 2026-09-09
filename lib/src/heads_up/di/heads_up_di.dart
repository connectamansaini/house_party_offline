import 'package:get_it/get_it.dart';
import 'package:house_party_offline/src/heads_up/data/accelerometer_tilt_sensor.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_ticker.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';

void registerHeadsUpDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<HeadsUpEngine>(HeadsUpEngine.new)
    ..registerLazySingleton<HeadsUpTicker>(PeriodicHeadsUpTicker.new)
    ..registerLazySingleton<HeadsUpTiltSensor>(AccelerometerTiltSensor.new);
}
