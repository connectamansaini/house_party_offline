import 'package:flutter/material.dart';

import 'src/app/app.dart';
import 'src/app/di.dart';
import 'src/core/storage/hive_boxes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapStorage();
  await configureDependencies();
  runApp(const App());
}
