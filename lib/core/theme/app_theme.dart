import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_colors.dart';

@lazySingleton
class AppTheme {
  final AppColors appColors;

  AppTheme(this.appColors);

  ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: appColors.surfaceColor,
    colorScheme: ColorScheme(
      brightness: appColors.brightness,
      primary: appColors.primaryColor,
      onPrimary: appColors.onPrimaryColor,
      secondary: appColors.secondaryColor,
      onSecondary: appColors.onSecondaryColor,
      error: appColors.errorColor,
      onError: appColors.onErrorColor,
      surface: appColors.surfaceColor,
      onSurface: appColors.onSurfaceColor,
      outline: appColors.strokeColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.surfaceColor,
      foregroundColor: appColors.secondaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: appColors.secondaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: appColors.secondaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: appColors.secondaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: appColors.secondaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: appColors.secondaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: appColors.onSurfaceColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: appColors.onSurfaceColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: appColors.textSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: appColors.primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: appColors.textSecondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: appColors.textSecondaryColor,
      ),
    ),
  );
}
