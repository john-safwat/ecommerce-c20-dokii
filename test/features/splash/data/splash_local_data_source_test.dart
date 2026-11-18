import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/features/splash/data/data_source/splash_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SplashLocalDataSourceImpl', () {
    test('returns null when token is not stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final dataSource = SplashLocalDataSourceImpl(prefs);

      expect(dataSource.getToken(), isNull);
    });

    test('returns stored token when present', () async {
      SharedPreferences.setMockInitialValues({'token': 'abc123'});
      final prefs = await SharedPreferences.getInstance();
      final dataSource = SplashLocalDataSourceImpl(prefs);

      expect(dataSource.getToken(), equals('abc123'));
    });
  });
}
