import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:house_party_offline/app/app.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:house_party_offline/app/bootstrap.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:injectable/injectable.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // usePathUrlStrategy();

      // // Firebase Initialization
      // try {
      //   await Firebase.initializeApp(
      //     options: DefaultFirebaseOptions.currentPlatform,
      //   );
      // } catch (e) {
      //   log('Firebase Initialize error $e', name: 'firebaseinit');
      // }

      // Dependency Injection Configuration
      await configureInjector(Environment.test);

      await bootstrap(
        () => const Directionality(
          textDirection: TextDirection.ltr,
          child: Banner(
            message: 'STG',
            location: BannerLocation.topEnd,
            child: App(),
          ),
        ),
      );
    },
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}
