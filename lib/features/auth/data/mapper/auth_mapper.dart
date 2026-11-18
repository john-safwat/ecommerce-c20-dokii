import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/features/auth/data/models/auth_response_dto.dart';
import 'package:route_ecommerce/features/auth/data/models/login_request_dto.dart';
import 'package:route_ecommerce/features/auth/data/models/registration_request_dto.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';

import '../../domain/entities/login_entity.dart';
import '../../domain/entities/register_entity.dart' show RegisterEntity;

@injectable
class AuthMapper {
  RegistrationRequestDto registerToDto(RegisterEntity registerEntity) {
    return RegistrationRequestDto(
      name: registerEntity.name,
      email: registerEntity.email,
      password: registerEntity.password,
      rePassword: registerEntity.rePassword,
      phone: registerEntity.phone,
    );
  }

  LoginRequestDto loginToDto(LoginEntity loginEntity) {
    return LoginRequestDto(
      email: loginEntity.email,
      password: loginEntity.password,
    );
  }

  UserEntity dtoToUser(AuthResponseDto authResponseDto) {
    return UserEntity(
      authResponseDto.user?.name ?? "",
      authResponseDto.user?.email ?? "",
      authResponseDto.user?.role ?? "",
    );
  }
}
