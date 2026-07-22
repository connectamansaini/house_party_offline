import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Names of the Hive boxes used across the app. Boxes are opened during app
/// startup ([bootstrapStorage]) and read/written by the data layer.
abstract final class HiveBoxes {
  /// Custom (user-created) word packs.
  static const customWordPacks = 'custom_word_packs';

  /// Persisted players and their cumulative scores.
  static const players = 'players';

  /// App/game settings (last-used config, etc.).
  static const settings = 'settings';
}

/// Initializes Hive and opens the app's boxes. Call once, before `runApp`.
///
/// Type adapters and box contents are wired up in a later milestone; for now
/// this just makes local storage available so the DI graph can depend on it.
Future<void> bootstrapStorage() async {
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox<Map<dynamic, dynamic>>(HiveBoxes.customWordPacks),
    Hive.openBox<Map<dynamic, dynamic>>(HiveBoxes.players),
    Hive.openBox<dynamic>(HiveBoxes.settings),
  ]);
}
