import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/splash/domain/repo/splash_repo.dart';

@injectable
class CheckTokenUseCase {
  final SplashRepo splashRepo;

  CheckTokenUseCase(this.splashRepo);

  Future<Result<bool>> call() async {
    return await splashRepo.hasToken();
  }
}
