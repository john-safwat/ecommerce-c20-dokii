import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

@injectable
class GetProductsUseCase {
  final CommerceRepo repo;
  GetProductsUseCase(this.repo);

  Future<Result<List<ProductEntity>>> call(String categoryId) async {
    return await repo.getProducts(categoryId);
  }
}
