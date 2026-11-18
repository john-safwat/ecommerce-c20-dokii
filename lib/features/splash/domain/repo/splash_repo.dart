import 'package:route_ecommerce/core/network/api_result.dart';

abstract interface class SplashRepo {
  Future<Result<bool>> hasToken();
}
