import 'package:flutter/foundation.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_product_entity.dart';

@immutable
class CartState {
  final String cartId;
  final Map<String, CartProductEntity> cart;
  final Resources<Map<String, CartProductEntity>> cartResource;
  final Resources<void> checkoutResource;
  final Set<String> pendingProductIds;

  CartState({
    this.cartId = '',
    this.cart = const {},
    Resources<Map<String, CartProductEntity>>? cartResource,
    Resources<void>? checkoutResource,
    this.pendingProductIds = const {},
  }) : cartResource = cartResource ?? Resources.init(),
       checkoutResource = checkoutResource ?? Resources.init();

  bool isProductPending(String productId) =>
      pendingProductIds.contains(productId);

  bool get isCheckingOut => checkoutResource.status == Status.loading;

  int get totalItemsCount =>
      cart.values.fold(0, (sum, item) => sum + item.count);

  double get totalPrice =>
      cart.values.fold(0, (sum, item) => sum + (item.price * item.count));

  CartState copyWith({
    String? cartId,
    Map<String, CartProductEntity>? cart,
    Resources<Map<String, CartProductEntity>>? cartResource,
    Resources<void>? checkoutResource,
    Set<String>? pendingProductIds,
  }) {
    return CartState(
      cartId: cartId ?? this.cartId,
      cart: cart ?? this.cart,
      cartResource: cartResource ?? this.cartResource,
      checkoutResource: checkoutResource ?? this.checkoutResource,
      pendingProductIds: pendingProductIds ?? this.pendingProductIds,
    );
  }
}
