import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/common_ui/app_text_field.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/core/utils/numbers_extension.dart';
import 'package:route_ecommerce/core/utils/validators.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_actions.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_cubit.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_state.dart';
import 'package:route_ecommerce/core/common_ui/route_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterCubit _cubit = getIt<RegisterCubit>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Validator _validator = Validator();
  StreamSubscription<RegisterUIAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
  }

  void _handleNavigation(RegisterUIAction event) {
    switch (event) {
      case NavigateBack():
        {
          Navigator.pop(context);
        }
      case ShowRegisterError():
        {
          context.showActionDialog(
            message: event.message ?? "",
            postActionTitle: 'OK',
          );
        }
    }
  }

  void _submitRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(
        RegisterSubmitAction(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.verticalSpace,
        const Center(child: RouteLogo()),
        36.verticalSpace,
        AppTextField(
          label: locale.fullName,
          hintText: locale.enterYourFullName,
          controller: _nameController,
          keyboardType: TextInputType.name,
          validator: (value) => _validator.nameValidation(value, locale),
        ),
        20.verticalSpace,
        AppTextField(
          label: locale.mobileNumber,
          hintText: locale.enterYourMobileNo,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => _validator.phoneValidation(value, locale),
        ),
        20.verticalSpace,
        AppTextField(
          label: locale.emailAddress,
          hintText: locale.enterYourEmailAddress,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => _validator.emailValidation(value, locale),
        ),
        20.verticalSpace,
        AppTextField(
          label: locale.password,
          hintText: locale.enterYourPassword,
          controller: _passwordController,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submitRegister(),
          validator: (value) => _validator.passwordValidation(value, locale),
        ),
        36.verticalSpace,
        _buildSignUpButton(context),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return AppButton(
          label: context.locale.signUp,
          isLoading: state.user.status == Status.loading,
          onPressed: _submitRegister,
        );
      },
    );
  }
}
