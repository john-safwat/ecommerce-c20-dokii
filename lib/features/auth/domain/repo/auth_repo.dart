import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/auth/domain/entities/login_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/register_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepo {
  Future<Result<UserEntity>> register(RegisterEntity registerEntity);
  Future<Result<UserEntity>> login(LoginEntity login);
}
