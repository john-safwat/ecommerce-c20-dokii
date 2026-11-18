import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_provider.dart';
import 'core/routing/route_gen.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Future<void> setLocale(BuildContext context, Locale newLocale) {
    return context.read<LocaleProvider>().setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<LocaleProvider>(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            onGenerateRoute: routeGen,
            title: 'Route E-Commerce',
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getIt<AppTheme>().theme,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
