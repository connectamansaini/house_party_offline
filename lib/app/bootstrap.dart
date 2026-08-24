import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/app/app_bloc_observer.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';

/// Opens local storage, installs the bloc observer, and runs [builder].
///
/// Call after `configureInjector` so the graph is available to the first frame.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await bootstrapStorage();

  Bloc.observer = const AppBlocObserver();

  runApp(await builder());
}
