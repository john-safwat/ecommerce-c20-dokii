import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/constants/app_assets.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_cubit.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_states.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashCubit cubit = getIt<SplashCubit>();
  StreamSubscription<SplashNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = cubit.navStream.listen(_handleNavigation);
    cubit.doAction(const InitSplashAction());
  }

  void _handleNavigation(SplashNavigationAction event) {
    switch (event) {
      case NavigateToLoginScreen():
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      case NavigateToHomeScreen():
        Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: SizedBox.expand(
          child: Image.asset(AppAssets.splashScreen, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
