import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/auth/domain/entities/login_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/register_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:route_ecommerce/features/auth/domain/repo/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase(this.authRepo);

  Future<Result<UserEntity>> call(LoginEntity login) async {
    return await authRepo.login(login);
  }
}
