import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/repo/orders_repo.dart';

@injectable
class GetUserCartUseCase {
  final OrdersRepo _repo;

  GetUserCartUseCase(this._repo);

  Future<Result<CartEntity>> call() {
    return _repo.getUserCart();
  }
}
