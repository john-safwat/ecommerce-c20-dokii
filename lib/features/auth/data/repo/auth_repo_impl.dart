import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/network/safe_call.dart';
import 'package:route_ecommerce/features/auth/data/data_source/auth_api_client.dart';
import 'package:route_ecommerce/features/auth/data/mapper/auth_mapper.dart';
import 'package:route_ecommerce/features/auth/domain/entities/login_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/register_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:route_ecommerce/features/auth/domain/repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthApiClient apiClient;
  final AuthMapper authMapper;
  final SharedPreferences sharedPreferences;

  AuthRepoImpl(this.apiClient, this.authMapper, this.sharedPreferences);

  @override
  Future<Result<UserEntity>> login(LoginEntity login) async {
    return safeCall(() async {
      var response = await apiClient.login(authMapper.loginToDto(login));
      if (response.token != null) {
        await sharedPreferences.setString('token', response.token ?? "");
      }
      return Success(authMapper.dtoToUser(response));
    });
  }

  @override
  Future<Result<UserEntity>> register(RegisterEntity registerEntity) async {
    return safeCall(() async {
      var response = await apiClient.register(
        authMapper.registerToDto(registerEntity),
      );
      return Success(authMapper.dtoToUser(response));
    });
  }
}
