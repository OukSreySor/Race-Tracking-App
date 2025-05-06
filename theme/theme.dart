import 'package:flutter/material.dart';

///
/// Definition of App colors.
///
class RaceColors {
  static Color primary = const Color(0xFF00aff5);
  static Color backgroundAccent = const Color(0xFFEDEDED);

  static Color neutralDark = const Color(0xFF054752);
  static Color neutral = const Color(0xFF3d5c62);
  static Color neutralLight = const Color(0xFF708c91);
  static Color neutralLighter = const Color(0xFF92A7AB);

  static Color greyLight = const Color(0xFFE2E2E2);

  static Color white = Colors.white;

  static Color get backGroundColor => primary;
  static Color get textNormal => neutralDark;
  static Color get textLight => neutralLight;
  static Color get iconNormal => neutral;
  static Color get iconLight => neutralLighter;
  static Color get disabled => greyLight;
}

///
/// Definition of App text styles.
///
class RaceTextStyles {
  static TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: RaceColors.textNormal,
  );

  static TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: RaceColors.textNormal,
  );

  static TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: RaceColors.textNormal,
  );

  static TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: RaceColors.textLight,
  );

  static TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: RaceColors.white,
  );
}

///
/// Definition of App spacings
///
class RaceSpacings {
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 40;

  static const double radius = 16;
  static const double radiusLarge = 24;
}

class RaceSize {
  static const double icon = 24;
}

///
/// Global App Theme
///
ThemeData appTheme = ThemeData(
  fontFamily: 'Inter', // your font
  primaryColor: RaceColors.primary,
  scaffoldBackgroundColor: RaceColors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: RaceColors.primary,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: RaceColors.white),
    titleTextStyle: RaceTextStyles.title.copyWith(color: RaceColors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RaceColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RaceSpacings.radius),
      ),
      textStyle: RaceTextStyles.button,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: RaceColors.primary,
      textStyle: RaceTextStyles.button,
    ),
  ),
  textTheme: TextTheme(
    headlineSmall: RaceTextStyles.heading,
    titleMedium: RaceTextStyles.title,
    bodyMedium: RaceTextStyles.body,
    labelMedium: RaceTextStyles.label,
  ),
);
