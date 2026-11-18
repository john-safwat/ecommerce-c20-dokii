import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/common_ui/app_text_field.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/core/utils/numbers_extension.dart';
import 'package:route_ecommerce/core/utils/validators.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_actions.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_cubit.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_state.dart';
import 'package:route_ecommerce/core/common_ui/route_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginCubit _cubit = getIt<LoginCubit>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Validator _validator = Validator();
  StreamSubscription<LoginUIAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
  }

  void _handleNavigation(LoginUIAction event) {
    switch (event) {
      case NavigateToRegisterScreen():
        Navigator.pushNamed(context, AppRoutes.register);
      case NavigateToHomeScreen():
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case ShowLoginError(:final message):
        context.showActionDialog(
          message: message ?? context.locale.loginFailed,
          postActionTitle: 'OK',
        );
    }
  }

  void _submitLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(
        LoginAction(_emailController.text.trim(), _passwordController.text),
      );
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: colors.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Form(key: _formKey, child: _buildBody(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final locale = context.locale;
    final colors = context.colors;
    final textTheme = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.verticalSpace,
        const Center(child: RouteLogo()),
        48.verticalSpace,
        Text(
          locale.welcomeBackToRoute,
          style: textTheme.headlineLarge?.copyWith(color: colors.onPrimary),
        ),
        8.verticalSpace,
        Text(
          locale.pleaseSignInWithYourMail,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.onPrimary.withValues(alpha: 0.9),
          ),
        ),
        36.verticalSpace,
        AppTextField(
          label: locale.userName,
          hintText: locale.enterYourName,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => _validator.emailValidation(value, locale),
        ),
        24.verticalSpace,
        AppTextField(
          label: locale.password,
          hintText: locale.enterYourPassword,
          controller: _passwordController,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submitLogin(),
          validator: (value) => _validator.passwordValidation(value, locale),
        ),
        8.verticalSpace,
        _buildForgotPassword(context),
        32.verticalSpace,
        _buildLoginButton(context),
        24.verticalSpace,
        _buildCreateAccountLink(context),
      ],
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: context.colors.onPrimary,
        ),
        child: Text(
          context.locale.forgotPassword,
          style: context.text.titleMedium?.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return AppButton(
          label: context.locale.login,
          isLoading: state.user.status == Status.loading,
          onPressed: _submitLogin,
        );
      },
    );
  }

  Widget _buildCreateAccountLink(BuildContext context) {
    final locale = context.locale;
    final colors = context.colors;
    final textTheme = context.text;

    return Center(
      child: TextButton(
        onPressed: () => _cubit.doAction(NavigateToRegisterAction()),
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: colors.onPrimary,
        ),
        child: Text.rich(
          TextSpan(
            text: locale.dontHaveAnAccount,
            style: textTheme.titleMedium?.copyWith(color: colors.onPrimary),
            children: [
              TextSpan(
                text: locale.createAccount,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
