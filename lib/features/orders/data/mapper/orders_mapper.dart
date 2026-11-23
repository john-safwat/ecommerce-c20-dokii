import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/features/orders/data/models/cart_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/cash_order_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/checkout_session_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/shipping_address_request_dto.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_product_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';

@injectable
class OrdersMapper {
  static const String defaultCallbackBaseUrl = 'http://localhost:3000';

  CartEntity mapDtoToCartEntity(CartResponseDto response) {
    final resolvedCartId = response.cartId ?? response.data?.id ?? '';
    return CartEntity(
      cartId: resolvedCartId,
      products: mapDtoListToEntity(response),
    );
  }

  List<CartProductEntity> mapDtoListToEntity(CartResponseDto response) {
    final products = <CartProductEntity>[];
    for (final item in response.data?.products ?? <Products>[]) {
      final product = item.product;
      products.add(
        CartProductEntity(
          item.count?.toInt() ?? 0,
          product?.id ?? '',
          item.price?.toDouble() ?? 0,
          title: product?.title ?? '',
          imageCover: product?.imageCover ?? '',
          brandName: product?.brand?.name ?? '',
          categoryName: product?.category?.name ?? '',
        ),
      );
    }
    return products;
  }

  ShippingAddressRequestDto mapShippingAddressToDto(
    ShippingAddressEntity address, {
    bool includePostalCode = true,
  }) {
    return ShippingAddressRequestDto(
      details: address.details.trim(),
      phone: address.phone.trim(),
      city: address.city.trim(),
      postalCode: includePostalCode ? address.postalCode?.trim() : null,
    );
  }

  OrderEntity mapCashOrderDtoToEntity(CashOrderResponseDto response) {
    final data = response.data;
    return OrderEntity(
      id: data?.id ?? '',
      totalOrderPrice: data?.totalOrderPrice?.toDouble() ?? 0,
      paymentMethodType: data?.paymentMethodType ?? 'cash',
      isPaid: data?.isPaid ?? false,
      isDelivered: data?.isDelivered ?? false,
    );
  }

  CheckoutSessionEntity mapCheckoutSessionDtoToEntity(
    CheckoutSessionResponseDto response, {
    String callbackBaseUrl = defaultCallbackBaseUrl,
  }) {
    final session = response.session;
    return CheckoutSessionEntity(
      url: session?.url ?? '',
      successUrl: session?.successUrl ?? '$callbackBaseUrl/allorders',
      cancelUrl: session?.cancelUrl ?? '$callbackBaseUrl/cart',
    );
  }
}
