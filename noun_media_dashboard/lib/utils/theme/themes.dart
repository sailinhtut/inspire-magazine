import 'package:flutter/material.dart';
import 'package:inspired_blog_panel/utils/custom/fast_ripple.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:inspired_blog_panel/utils/theme/colors.dart';

class PoultryThemes {
  // Light Theme
  static ThemeData light = ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: mainColor,
    dividerColor: gitHubLightBorderColor,
    brightness: Brightness.light,
    focusColor: mainColor,
    highlightColor: gitHubLightHilightColor,
    dialogBackgroundColor: gitHubLightBackgroundColor,
    scaffoldBackgroundColor: gitHubLightBackgroundColor,
    splashFactory: InkRippleFast.splashFactory,
    bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent),
    dialogTheme: const DialogTheme(surfaceTintColor: Colors.transparent),
    cardTheme: const CardTheme(
        surfaceTintColor: Colors.transparent,
        color: gitHubLightBackgroundColor),
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: getMaterialColor(mainColor),
        accentColor: gitHubLightAccentColor,
        backgroundColor: gitHubLightBackgroundColor,
        cardColor: gitHubLightSecondBackgroundColor,
        errorColor: gitHubLightErrorColor),
    textTheme: ThemeData.light().textTheme.apply(
          displayColor: gitHubLightTextColor,
          bodyColor: gitHubLightTextColor,
          // fontFamily: GoogleFonts.poppins().fontFamily,
        ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: gitHubLightSecondBackgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: gitHubLightBackgroundColor,
      foregroundColor: gitHubLightForegroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      side: BorderSide(color: mainColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    )),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
