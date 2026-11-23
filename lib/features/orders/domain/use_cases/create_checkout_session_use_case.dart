import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/data/mapper/orders_mapper.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:route_ecommerce/features/orders/domain/repo/orders_repo.dart';

@injectable
class CreateCheckoutSessionUseCase {
  final OrdersRepo _repo;

  CreateCheckoutSessionUseCase(this._repo);

  Future<Result<CheckoutSessionEntity>> call({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
    String callbackUrl = OrdersMapper.defaultCallbackBaseUrl,
  }) {
    return _repo.createCheckoutSession(
      cartId: cartId,
      shippingAddress: shippingAddress,
      callbackUrl: callbackUrl,
    );
  }
}
