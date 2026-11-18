import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

@injectable
class GetProductDetailsUseCase {
  final CommerceRepo _repo;

  GetProductDetailsUseCase(this._repo);

  Future<Result<ProductDetailsEntity>> call(String productId) {
    return _repo.getProductDetails(productId);
  }
}
