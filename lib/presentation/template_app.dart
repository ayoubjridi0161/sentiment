import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/navigation/base/app_router.dart';
import 'package:flutter_template/interactor/sentiment/sentiment_providers.dart';
import 'package:flutter_template/presentation/base/theme/theme_data/template_app_theme_data.dart';
import 'package:flutter_template/presentation/base/widgets/snackbar/snackbar.dart';
import 'package:flutter_template/presentation/base/widgets/theme/theme_listener.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemplateApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  TemplateApp({super.key, required this.sharedPreferences});

  final AppRouter _appRouter = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: ThemeStateListener(
        builder: (themeState) => DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final lightTheme = (themeState.isDynamic && lightDynamic != null)
                ? buildTheme(lightDynamic.harmonized())
                : material3LightTheme;
            final darkTheme = (themeState.isDynamic && darkDynamic != null)
                ? buildTheme(darkDynamic.harmonized())
                : material3DarkTheme;
            return MaterialApp.router(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeState.themeMode,
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              scaffoldMessengerKey: scaffoldMessengerKey,
            );
          },
        ),
      ),
    );
  }
}
