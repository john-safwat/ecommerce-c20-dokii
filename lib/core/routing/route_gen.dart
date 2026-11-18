import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_page.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_page.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_page.dart';

Route<dynamic> routeGen(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(
        builder: (context) => const SplashPage(),
        settings: settings,
      );
    case AppRoutes.login:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
        settings: settings,
      );
    case AppRoutes.register:
      return MaterialPageRoute(
        builder: (context) => const RegisterPage(),
        settings: settings,
      );
    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('No Content'))),
        settings: settings,
      );
  }
}
