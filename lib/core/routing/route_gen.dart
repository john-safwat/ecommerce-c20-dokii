import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_page.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/main_layout/main_layout_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_args.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_page.dart';
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
        builder: (context) => const MainLayoutPage(),
        settings: settings,
      );
    case AppRoutes.productsList:
      final args = settings.arguments is ProductsListArgs
          ? settings.arguments! as ProductsListArgs
          : null;
      return MaterialPageRoute(
        builder: (context) => ProductsListPage(args: args),
        settings: settings,
      );
    case AppRoutes.productDetails:
      final productId = settings.arguments is String
          ? settings.arguments! as String
          : '';
      return MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productId: productId),
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
