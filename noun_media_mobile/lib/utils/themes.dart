import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_blog/utils/colors.dart';
import 'package:inspired_blog/utils/functions.dart';

class FindemThemes {
  static ThemeData light = ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: mainColor,
    dividerColor: gitHubLightBorderColor,
    brightness: Brightness.dark,
    focusColor: mainColor,
    highlightColor: gitHubLightHilightColor,
    dialogBackgroundColor: scaffoldBackgroundColor,
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: getMaterialColor(mainColor),
        accentColor: gitHubLightAccentColor,
        backgroundColor: scaffoldBackgroundColor,
        cardColor: gitHubLightSecondBackgroundColor,
        errorColor: gitHubLightErrorColor),
    textTheme: ThemeData.light().textTheme.apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    splashFactory: InkRippleFast.splashFactory,
    bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: gitHubLightSecondBackgroundColor,
    ),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: scaffoldBackgroundColor,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardTheme(
        surfaceTintColor: Colors.transparent,
        color: gitHubLightSecondBackgroundColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black12.withOpacity(0.05))),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)))),
    popupMenuTheme: PopupMenuThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: Colors.transparent),
  );
}
