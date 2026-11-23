import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:route_ecommerce/features/orders/domain/repo/orders_repo.dart';

@injectable
class CreateCashOrderUseCase {
  final OrdersRepo _repo;

  CreateCashOrderUseCase(this._repo);

  Future<Result<OrderEntity>> call({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
  }) {
    return _repo.createCashOrder(
      cartId: cartId,
      shippingAddress: shippingAddress,
    );
  }
}
