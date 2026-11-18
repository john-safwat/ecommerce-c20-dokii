import 'package:route_ecommerce/core/base/resources.dart';

class SplashStates {
  final Resources<bool> hasToken;

  SplashStates({Resources<bool>? hasToken})
    : hasToken = hasToken ?? Resources.init();

  SplashStates copyWith({Resources<bool>? hasToken}) =>
      SplashStates(hasToken: hasToken ?? this.hasToken);
}

sealed class SplashAction {
  const SplashAction();
}

class InitSplashAction extends SplashAction {
  const InitSplashAction();
}

sealed class SplashNavigationAction {
  const SplashNavigationAction();
}

class NavigateToLoginScreen extends SplashNavigationAction {
  const NavigateToLoginScreen();
}

class NavigateToHomeScreen extends SplashNavigationAction {
  const NavigateToHomeScreen();
}
