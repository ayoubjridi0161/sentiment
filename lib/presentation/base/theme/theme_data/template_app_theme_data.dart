import 'package:flutter/material.dart';
import 'package:flutter_template/flavors/flavor_config.dart';
import 'package:flutter_template/presentation/base/theme/color/color_palette.dart';
import 'package:flutter_template/presentation/base/theme/type/text_theme.dart';
import 'package:google_fonts/google_fonts.dart';

final material3LightTheme = buildTheme(lightColorScheme);

final material3DarkTheme = buildTheme(darkColorScheme);

ThemeData buildTheme(ColorScheme colorScheme) {
  final useGoogleFonts = FlavorConfig.values.useGoogleFonts;
  final textTheme = getTextTheme(colorScheme);
  return ThemeData(
    useMaterial3: true,
    textTheme:
        useGoogleFonts ? GoogleFonts.openSansTextTheme(textTheme) : textTheme,
    fontFamily: useGoogleFonts ? GoogleFonts.openSans().fontFamily : null,
    popupMenuTheme: PopupMenuThemeData(color: colorScheme.surface),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(backgroundColor: colorScheme.surface),
    appBarTheme: AppBarTheme(color: colorScheme.surfaceVariant),
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
  );
}
