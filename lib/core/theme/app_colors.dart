import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class AppColors {
  Color get primaryColor;
  Color get onPrimaryColor;
  Color get secondaryColor;
  Color get onSecondaryColor;
  Color get surfaceColor;
  Color get onSurfaceColor;
  Color get errorColor;
  Color get onErrorColor;
  Color get textSecondaryColor;
  Color get strokeColor;
  Color get starColor;
  Brightness get brightness;
}

@LazySingleton(as: AppColors)
class LightColors implements AppColors {
  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get primaryColor => const Color(0xFF004182);

  @override
  Color get onPrimaryColor => const Color(0xFFFFFFFF);

  @override
  Color get secondaryColor => const Color(0xFF06004F);

  @override
  Color get onSecondaryColor => const Color(0xFFFFFFFF);

  @override
  Color get surfaceColor => const Color(0xFFFFFFFF);

  @override
  Color get onSurfaceColor => const Color(0xFF06004F);

  @override
  Color get errorColor => const Color(0xFFBC3018);

  @override
  Color get onErrorColor => const Color(0xFFFFFFFF);

  @override
  Color get textSecondaryColor => const Color(0x9906004F);

  @override
  Color get strokeColor => const Color(0x4D004182);

  @override
  Color get starColor => const Color(0xFFFDD835);
}
