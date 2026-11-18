import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/network/safe_call.dart';
import 'package:route_ecommerce/features/splash/data/data_source/splash_local_data_source.dart';
import 'package:route_ecommerce/features/splash/domain/repo/splash_repo.dart';

@Injectable(as: SplashRepo)
class SplashRepoImpl implements SplashRepo {
  final SplashLocalDataSource localDataSource;

  SplashRepoImpl(this.localDataSource);

  @override
  Future<Result<bool>> hasToken() async {
    return safeCall(() async {
      final token = localDataSource.getToken();
      final isValid = token != null && token.trim().isNotEmpty;
      return Success(isValid);
    });
  }
}
