import 'package:flutter/material.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/app/themes/app_theme.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: appRouter,
        restorationScopeId: 'app',
      ),
    );
  }
}
