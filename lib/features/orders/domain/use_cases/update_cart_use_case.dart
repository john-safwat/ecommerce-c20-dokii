import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/repo/orders_repo.dart';

@injectable
class UpdateCartUseCase {
  final OrdersRepo _repo;

  UpdateCartUseCase(this._repo);

  Future<Result<CartEntity>> call(String productId, int count) {
    return _repo.updateCartProduct(productId, count);
  }
}
