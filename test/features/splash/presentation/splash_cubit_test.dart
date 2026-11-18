import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/splash/domain/repo/splash_repo.dart';
import 'package:route_ecommerce/features/splash/domain/use_cases/check_token_use_case.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_cubit.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_states.dart';

class _FakeSplashRepo implements SplashRepo {
  final Result<bool> result;

  _FakeSplashRepo(this.result);

  @override
  Future<Result<bool>> hasToken() async => result;
}

void main() {
  group('SplashCubit', () {
    test('initial state has initial hasToken resource', () {
      final cubit = SplashCubit(
        CheckTokenUseCase(_FakeSplashRepo(Success(false))),
      );
      expect(cubit.state, isA<SplashStates>());
      expect(cubit.state.hasToken.status, equals(Status.initial));
      cubit.close();
    });

    test(
      'InitSplashAction emits NavigateToHomeScreen after 3 seconds when token exists',
      () {
        fakeAsync((async) {
          final cubit = SplashCubit(
            CheckTokenUseCase(_FakeSplashRepo(Success(true))),
          );
          final List<SplashNavigationAction> navEvents = [];
          final sub = cubit.navStream.listen(navEvents.add);

          cubit.doAction(const InitSplashAction());
          expect(cubit.state.hasToken.status, equals(Status.loading));

          async.elapse(const Duration(seconds: 2));
          expect(navEvents, isEmpty);

          async.elapse(const Duration(seconds: 1));
          async.flushMicrotasks();
          expect(cubit.state.hasToken.status, equals(Status.success));
          expect(cubit.state.hasToken.data, isTrue);
          expect(navEvents.length, equals(1));
          expect(navEvents.first, isA<NavigateToHomeScreen>());

          sub.cancel();
          cubit.close();
          async.flushMicrotasks();
        });
      },
    );

    test(
      'InitSplashAction emits NavigateToLoginScreen after 3 seconds when no token exists',
      () {
        fakeAsync((async) {
          final cubit = SplashCubit(
            CheckTokenUseCase(_FakeSplashRepo(Success(false))),
          );
          final List<SplashNavigationAction> navEvents = [];
          final sub = cubit.navStream.listen(navEvents.add);

          cubit.doAction(const InitSplashAction());

          async.elapse(const Duration(seconds: 2));
          expect(navEvents, isEmpty);

          async.elapse(const Duration(seconds: 1));
          async.flushMicrotasks();
          expect(cubit.state.hasToken.status, equals(Status.success));
          expect(cubit.state.hasToken.data, isFalse);
          expect(navEvents.length, equals(1));
          expect(navEvents.first, isA<NavigateToLoginScreen>());

          sub.cancel();
          cubit.close();
          async.flushMicrotasks();
        });
      },
    );

    test(
      'InitSplashAction emits NavigateToLoginScreen when checkTokenUseCase fails',
      () {
        fakeAsync((async) {
          final cubit = SplashCubit(
            CheckTokenUseCase(_FakeSplashRepo(Failure('Storage error'))),
          );
          final List<SplashNavigationAction> navEvents = [];
          final sub = cubit.navStream.listen(navEvents.add);

          cubit.doAction(const InitSplashAction());

          async.elapse(const Duration(seconds: 3));
          async.flushMicrotasks();
          expect(cubit.state.hasToken.status, equals(Status.error));
          expect(navEvents.length, equals(1));
          expect(navEvents.first, isA<NavigateToLoginScreen>());

          sub.cancel();
          cubit.close();
          async.flushMicrotasks();
        });
      },
    );

    test(
      'InitSplashAction does not emit navigation if closed before 3 seconds',
      () {
        fakeAsync((async) {
          final cubit = SplashCubit(
            CheckTokenUseCase(_FakeSplashRepo(Success(true))),
          );
          final List<SplashNavigationAction> navEvents = [];
          final sub = cubit.navStream.listen(navEvents.add);

          cubit.doAction(const InitSplashAction());

          async.elapse(const Duration(seconds: 1));
          cubit.close();
          async.flushMicrotasks();

          async.elapse(const Duration(seconds: 3));
          async.flushMicrotasks();
          expect(navEvents, isEmpty);

          sub.cancel();
        });
      },
    );
  });
}
