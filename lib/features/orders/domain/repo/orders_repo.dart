import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';

abstract interface class OrdersRepo {
  Future<Result<CartEntity>> getUserCart();
  Future<Result<CartEntity>> addToCartProduct(String productId);
  Future<Result<CartEntity>> removeFromCartProduct(String productId);
  Future<Result<CartEntity>> updateCartProduct(String productId, int count);
  Future<Result<OrderEntity>> createCashOrder({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
  });
  Future<Result<CheckoutSessionEntity>> createCheckoutSession({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
    String callbackUrl,
  });
}
