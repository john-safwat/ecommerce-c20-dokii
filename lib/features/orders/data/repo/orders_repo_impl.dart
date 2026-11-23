import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/network/safe_call.dart';
import 'package:route_ecommerce/features/orders/data/datasource/orders_api_client.dart';
import 'package:route_ecommerce/features/orders/data/mapper/orders_mapper.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:route_ecommerce/features/orders/domain/repo/orders_repo.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final OrdersApiClient apiClient;
  final OrdersMapper mapper;

  OrdersRepoImpl(this.apiClient, this.mapper);

  @override
  Future<Result<CartEntity>> addToCartProduct(String productId) {
    return safeCall(() async {
      final response = await apiClient.addToCartProduct({
        'productId': productId,
      });
      return Success(mapper.mapDtoToCartEntity(response));
    });
  }

  @override
  Future<Result<CartEntity>> getUserCart() {
    return safeCall(() async {
      final response = await apiClient.getUserCart();
      return Success(mapper.mapDtoToCartEntity(response));
    });
  }

  @override
  Future<Result<CartEntity>> removeFromCartProduct(String productId) {
    return safeCall(() async {
      final response = await apiClient.removeFromCartProduct(productId);
      return Success(mapper.mapDtoToCartEntity(response));
    });
  }

  @override
  Future<Result<CartEntity>> updateCartProduct(String productId, int count) {
    return safeCall(() async {
      final response = await apiClient.updateCartProduct(productId, {
        'count': count.toString(),
      });
      return Success(mapper.mapDtoToCartEntity(response));
    });
  }

  @override
  Future<Result<OrderEntity>> createCashOrder({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
  }) {
    return safeCall(() async {
      final body = mapper.mapShippingAddressToDto(shippingAddress).toJson();
      final response = await apiClient.createCashOrder(cartId, body);
      return Success(mapper.mapCashOrderDtoToEntity(response));
    });
  }

  @override
  Future<Result<CheckoutSessionEntity>> createCheckoutSession({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
    String callbackUrl = OrdersMapper.defaultCallbackBaseUrl,
  }) {
    return safeCall(() async {
      final body = mapper
          .mapShippingAddressToDto(shippingAddress, includePostalCode: false)
          .toJson();
      final response = await apiClient.createCheckoutSession(
        cartId,
        callbackUrl,
        body,
      );
      final entity = mapper.mapCheckoutSessionDtoToEntity(
        response,
        callbackBaseUrl: callbackUrl,
      );
      if (entity.url.isEmpty) {
        return Failure(
          'Failed to initialize payment session',
          exception: Exception('Missing checkout session URL'),
        );
      }
      return Success(entity);
    });
  }
}
