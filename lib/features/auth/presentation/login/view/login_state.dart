import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';

@immutable
class LoginState {
  final Resources<UserEntity> user;

  const LoginState(this.user);

  LoginState copyWith({Resources<UserEntity>? userEntity}) {
    return LoginState(userEntity ?? user);
  }
}
