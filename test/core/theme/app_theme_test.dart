import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';

void main() {
  group('LightColors & AppTheme', () {
    late AppColors colors;
    late AppTheme appTheme;

    setUp(() {
      colors = LightColors();
      appTheme = AppTheme(colors);
    });

    test('LightColors provides expected Figma color tokens', () {
      expect(colors.brightness, equals(Brightness.light));
      expect(colors.primaryColor, equals(const Color(0xFF004182)));
      expect(colors.onPrimaryColor, equals(const Color(0xFFFFFFFF)));
      expect(colors.secondaryColor, equals(const Color(0xFF06004F)));
      expect(colors.onSecondaryColor, equals(const Color(0xFFFFFFFF)));
      expect(colors.surfaceColor, equals(const Color(0xFFFFFFFF)));
      expect(colors.onSurfaceColor, equals(const Color(0xFF06004F)));
      expect(colors.errorColor, equals(const Color(0xFFBC3018)));
      expect(colors.onErrorColor, equals(const Color(0xFFFFFFFF)));
      expect(colors.textSecondaryColor, equals(const Color(0x9906004F)));
      expect(colors.strokeColor, equals(const Color(0x4D004182)));
      expect(colors.starColor, equals(const Color(0xFFFDD835)));
    });

    test(
      'AppTheme constructs ThemeData with mapped ColorScheme and TextTheme',
      () {
        final theme = appTheme.theme;

        expect(theme.useMaterial3, isTrue);
        expect(theme.scaffoldBackgroundColor, equals(colors.surfaceColor));
        expect(theme.colorScheme.brightness, equals(colors.brightness));
        expect(theme.colorScheme.primary, equals(colors.primaryColor));
        expect(theme.colorScheme.onPrimary, equals(colors.onPrimaryColor));
        expect(theme.colorScheme.secondary, equals(colors.secondaryColor));
        expect(theme.colorScheme.onSecondary, equals(colors.onSecondaryColor));
        expect(theme.colorScheme.error, equals(colors.errorColor));
        expect(theme.colorScheme.onError, equals(colors.onErrorColor));
        expect(theme.colorScheme.surface, equals(colors.surfaceColor));
        expect(theme.colorScheme.onSurface, equals(colors.onSurfaceColor));
        expect(theme.colorScheme.outline, equals(colors.strokeColor));

        expect(theme.appBarTheme.backgroundColor, equals(colors.surfaceColor));
        expect(
          theme.appBarTheme.foregroundColor,
          equals(colors.secondaryColor),
        );
        expect(theme.appBarTheme.elevation, equals(0));
        expect(theme.appBarTheme.centerTitle, isTrue);

        expect(theme.textTheme.headlineLarge?.fontSize, equals(24));
        expect(
          theme.textTheme.headlineLarge?.fontWeight,
          equals(FontWeight.w600),
        );
        expect(theme.textTheme.headlineMedium?.fontSize, equals(20));
        expect(theme.textTheme.titleLarge?.fontSize, equals(20));
        expect(theme.textTheme.titleMedium?.fontSize, equals(18));
        expect(theme.textTheme.titleSmall?.fontSize, equals(16));
        expect(theme.textTheme.bodyLarge?.fontSize, equals(16));
        expect(theme.textTheme.bodyMedium?.fontSize, equals(14));
        expect(theme.textTheme.bodySmall?.fontSize, equals(12));
        expect(theme.textTheme.labelLarge?.fontSize, equals(18));
        expect(theme.textTheme.labelMedium?.fontSize, equals(14));
        expect(theme.textTheme.labelSmall?.fontSize, equals(11));
      },
    );
  });
}
