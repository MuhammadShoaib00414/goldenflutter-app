import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/size_config.dart';


class AppThemes {
  static ThemeData getPrimaryTheme() {
    return ThemeData(
      cardColor: Colors.white,
      useMaterial3: false,
      primaryColor: AppColors.primaryText,
      primaryColorLight: Colors.black,
      colorScheme: ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.blue,
      ),
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade50),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 2.5,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primaryText,
          fontSize: SizeConfig.textMultiplier * 2.2,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 2,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 2.1,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.8,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.5,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.8,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.5,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.3,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 2.1,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.8,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.textMultiplier * 1.5,
          fontWeight: FontWeight.w400,
        ),
      ),
      fontFamily: "Inter",
    );
  }

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardColor: Colors.grey[850],
    useMaterial3: false,
    primaryColor: AppColors.primaryText,
    primaryColorLight: Colors.white,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.blueAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.1,
        fontWeight: FontWeight.w600,
        fontFamily: "Inter",
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.5,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.2,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.1,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 1.8,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.textMultiplier * 1.5,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.white70,
        fontSize: SizeConfig.textMultiplier * 1.8,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: SizeConfig.textMultiplier * 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: Colors.white70,
        fontSize: SizeConfig.textMultiplier * 1.3,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: Colors.white70,
        fontSize: SizeConfig.textMultiplier * 2.1,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        color: Colors.white70,
        fontSize: SizeConfig.textMultiplier * 1.8,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        color: Colors.white70,
        fontSize: SizeConfig.textMultiplier * 1.5,
        fontWeight: FontWeight.w400,
      ),
    ),
    fontFamily: "Inter",
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.brandAqua),
      trackColor: WidgetStateProperty.all(Colors.grey[600]),
    ),
  );
}
