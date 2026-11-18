import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/auth/domain/entities/register_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:route_ecommerce/features/auth/domain/repo/auth_repo.dart';

@injectable
class RegisterUseCase {
  final AuthRepo authRepo;

  RegisterUseCase(this.authRepo);

  Future<Result<UserEntity>> call(RegisterEntity registerEntity) async {
    return await authRepo.register(registerEntity);
  }
}
