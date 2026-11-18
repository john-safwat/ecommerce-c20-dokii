import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/splash/domain/use_cases/check_token_use_case.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_states.dart';

@injectable
class SplashCubit
    extends BaseCubit<SplashStates, SplashAction, SplashNavigationAction> {
  final CheckTokenUseCase checkTokenUseCase;

  SplashCubit(this.checkTokenUseCase) : super(SplashStates());

  @override
  Future<void> doAction(SplashAction action) async {
    switch (action) {
      case InitSplashAction():
        await _initSplash();
    }
  }

  Future<void> _initSplash() async {
    emit(state.copyWith(hasToken: Resources.loading()));
    await Future.delayed(const Duration(seconds: 3));
    if (isClosed) return;

    final result = await checkTokenUseCase();
    if (isClosed) return;

    switch (result) {
      case Success<bool>(data: true):
        emit(state.copyWith(hasToken: Resources.success(true)));
        emitNavigation(const NavigateToHomeScreen());
      case Success<bool>():
        emit(state.copyWith(hasToken: Resources.success(false)));
        emitNavigation(const NavigateToLoginScreen());
      case Failure<bool>():
        emit(state.copyWith(hasToken: Resources.error(result.message)));
        emitNavigation(const NavigateToLoginScreen());
    }
  }
}
