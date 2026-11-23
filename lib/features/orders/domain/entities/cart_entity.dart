import 'package:route_ecommerce/features/orders/domain/entities/cart_product_entity.dart';

class CartEntity {
  final String cartId;
  final List<CartProductEntity> products;

  const CartEntity({required this.cartId, required this.products});
}
