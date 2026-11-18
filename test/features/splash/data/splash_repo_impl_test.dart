import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/splash/data/data_source/splash_local_data_source.dart';
import 'package:route_ecommerce/features/splash/data/repo/splash_repo_impl.dart';

class _FakeSplashLocalDataSource implements SplashLocalDataSource {
  final String? token;
  final bool shouldThrow;

  _FakeSplashLocalDataSource({this.token, this.shouldThrow = false});

  @override
  String? getToken() {
    if (shouldThrow) throw Exception('Storage read failed');
    return token;
  }
}

void main() {
  group('SplashRepoImpl', () {
    test('returns Success(true) when token is non-empty', () async {
      final repo = SplashRepoImpl(
        _FakeSplashLocalDataSource(token: 'valid_token'),
      );

      final result = await repo.hasToken();

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });

    test('returns Success(false) when token is null', () async {
      final repo = SplashRepoImpl(_FakeSplashLocalDataSource(token: null));

      final result = await repo.hasToken();

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isFalse);
    });

    test('returns Success(false) when token is blank', () async {
      final repo = SplashRepoImpl(_FakeSplashLocalDataSource(token: '   '));

      final result = await repo.hasToken();

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isFalse);
    });

    test('returns Failure when local data source throws', () async {
      final repo = SplashRepoImpl(
        _FakeSplashLocalDataSource(shouldThrow: true),
      );

      final result = await repo.hasToken();

      expect(result, isA<Failure<bool>>());
    });
  });
}
