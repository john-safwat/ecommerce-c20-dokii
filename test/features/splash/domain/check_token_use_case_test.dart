import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/splash/domain/repo/splash_repo.dart';
import 'package:route_ecommerce/features/splash/domain/use_cases/check_token_use_case.dart';

class _FakeSplashRepo implements SplashRepo {
  final Result<bool> result;

  _FakeSplashRepo(this.result);

  @override
  Future<Result<bool>> hasToken() async => result;
}

void main() {
  group('CheckTokenUseCase', () {
    test('returns Success(true) from repository when token exists', () async {
      final useCase = CheckTokenUseCase(_FakeSplashRepo(Success(true)));

      final result = await useCase();

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });

    test(
      'returns Success(false) from repository when token is absent',
      () async {
        final useCase = CheckTokenUseCase(_FakeSplashRepo(Success(false)));

        final result = await useCase();

        expect(result, isA<Success<bool>>());
        expect((result as Success<bool>).data, isFalse);
      },
    );
  });
}
