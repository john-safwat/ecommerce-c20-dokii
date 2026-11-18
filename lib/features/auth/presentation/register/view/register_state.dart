import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';

@immutable
class RegisterState {
  final Resources<UserEntity> user;

  const RegisterState(this.user);

  RegisterState copyWith({Resources<UserEntity>? user}) {
    return RegisterState(user ?? this.user);
  }
}
