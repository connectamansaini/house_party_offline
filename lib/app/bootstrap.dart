import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/app/app_bloc_observer.dart';

import '../src/core/storage/hive_boxes.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  log(
    'Base URL -> ${const String.fromEnvironment('BASE_URL')}',
    name: 'ENV Variables',
  );
  log('ENV -> ${const String.fromEnvironment('ENV')}', name: 'ENV Variables');
  log(
    'Version -> ${const String.fromEnvironment('VERSION')}',
    name: 'ENV Variables',
  );

  // MediaKit.ensureInitialized();

  await bootstrapStorage();

  Bloc.observer = const AppBlocObserver();

  runApp(await builder());
}
