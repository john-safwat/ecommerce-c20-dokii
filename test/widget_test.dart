import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  testWidgets('MyApp renders MaterialApp with locale and AppTheme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    // Allow splash timer to elapse and settle to Login page
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    final materialAppFinder = find.byType(MaterialApp);
    expect(materialAppFinder, findsOneWidget);

    final MaterialApp app = tester.widget(materialAppFinder);
    expect(app.locale, equals(const Locale('en')));
    expect(
      app.theme?.colorScheme.primary,
      equals(getIt<AppColors>().primaryColor),
    );

    // Test changing locale updates MaterialApp
    final BuildContext context = tester.element(find.byType(Scaffold));
    await MyApp.setLocale(context, const Locale('ar'));
    await tester.pumpAndSettle();

    final MaterialApp updatedApp = tester.widget(materialAppFinder);
    expect(updatedApp.locale, equals(const Locale('ar')));
  });
}
