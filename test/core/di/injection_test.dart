import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/locale_provider.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
  });

  test('configureDependencies initializes getIt without error', () async {
    await configureDependencies();
    expect(getIt.isRegistered<SharedPreferences>(), isTrue);
    expect(getIt.isRegistered<LocaleProvider>(), isTrue);
    expect(getIt.isRegistered<AppColors>(), isTrue);
    expect(getIt.isRegistered<AppTheme>(), isTrue);
    expect(getIt<LocaleProvider>().locale.languageCode, equals('en'));
    expect(getIt<AppColors>(), isA<LightColors>());
  });
}
