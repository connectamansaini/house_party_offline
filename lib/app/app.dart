import 'package:flutter/material.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/app/themes/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: appRouter,
        restorationScopeId: 'app',
      ),
    );
  }
}

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return
//     //  BlocProviders(
//     // child:
//     GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.light(),
//         darkTheme: AppTheme.dark(),
//         // themeMode: context.watch<ThemeCubit>().state,
//         // localizationsDelegates: const [
//         //   ...AppLocalizations.localizationsDelegates,
//         //   FlutterQuillLocalizations.delegate,
//         // ],
//         // supportedLocales: AppLocalizations.supportedLocales,
//         // locale: localeCode.isEmpty ? null : Locale(localeCode),
//         // routerConfig: getIt<AppRouter>().config(
//         //   navigatorObservers: () => [RouterObserver()],
//         // ),
//         routerConfig: appRouter,
//         restorationScopeId: 'app',
//         // builder: (context, child) => ResponsiveBreakpoints.builder(
//         //   child: BouncingScrollWrapper.builder(context, child!),
//         //   breakpoints: AppBreakpoint.values
//         //       .map(
//         //         (e) => Breakpoint(
//         //           start: e.start.toDouble(),
//         //           end: e.end.toDouble(),
//         //           name: e.name,
//         //         ),
//         //       )
//         //       .toList(),
//         // ),
//       ),
//       // ),
//     );
//   }
// }
