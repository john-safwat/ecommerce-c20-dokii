import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

@injectable
class GetBannersUseCase {
  final CommerceRepo repo;
  GetBannersUseCase(this.repo);

  Future<Result<List<BannerEntity>>> call() async {
    return await repo.getBanners();
  }
}
