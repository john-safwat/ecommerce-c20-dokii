import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/features/orders/data/mapper/orders_mapper.dart';
import 'package:route_ecommerce/features/orders/data/models/cart_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/cash_order_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/checkout_session_response_dto.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';

void main() {
  group('OrdersMapper', () {
    final mapper = OrdersMapper();

    test('maps populated cart response DTO to CartEntity with cartId', () {
      final dto = CartResponseDto.fromJson({
        'status': 'success',
        'numOfCartItems': 1,
        'cartId': 'cart-top-id',
        'data': {
          '_id': 'cart-1',
          'totalCartPrice': 3500,
          'products': [
            {
              'count': 2,
              '_id': 'line-1',
              'price': 1750,
              'product': {
                '_id': 'prod-1',
                'id': 'prod-1',
                'title': 'Nike Air Jordan',
                'imageCover': 'https://example.com/nike.png',
                'brand': {'_id': 'b1', 'name': 'Nike'},
                'category': {'_id': 'c1', 'name': 'Shoes'},
              },
            },
          ],
        },
      });

      final cart = mapper.mapDtoToCartEntity(dto);

      expect(cart.cartId, 'cart-top-id');
      expect(cart.products, hasLength(1));
      final item = cart.products.first;
      expect(item.id, 'prod-1');
      expect(item.count, 2);
      expect(item.price, 1750);
      expect(item.title, 'Nike Air Jordan');
      expect(item.imageCover, 'https://example.com/nike.png');
      expect(item.brandName, 'Nike');
      expect(item.categoryName, 'Shoes');
    });

    test('falls back to data._id when top-level cartId is missing', () {
      final dto = CartResponseDto.fromJson({
        'status': 'success',
        'data': {
          '_id': 'cart-fallback',
          'products': [
            {'count': 1, '_id': 'line-2', 'price': 500, 'product': 'prod-2'},
          ],
        },
      });

      final cart = mapper.mapDtoToCartEntity(dto);

      expect(cart.cartId, 'cart-fallback');
      expect(cart.products, hasLength(1));
      expect(cart.products.first.id, 'prod-2');
      expect(cart.products.first.count, 1);
      expect(cart.products.first.price, 500);
      expect(cart.products.first.title, isEmpty);
    });

    test(
      'maps shipping address entity to request DTO with optional postalCode',
      () {
        const address = ShippingAddressEntity(
          details: '123 Nile St',
          phone: '01012345678',
          city: 'Cairo',
          postalCode: '12345',
        );

        final cashJson = mapper.mapShippingAddressToDto(address).toJson();
        expect(cashJson, {
          'shippingAddress': {
            'details': '123 Nile St',
            'phone': '01012345678',
            'city': 'Cairo',
            'postalCode': '12345',
          },
        });

        final cardJson = mapper
            .mapShippingAddressToDto(address, includePostalCode: false)
            .toJson();
        expect(cardJson, {
          'shippingAddress': {
            'details': '123 Nile St',
            'phone': '01012345678',
            'city': 'Cairo',
          },
        });
      },
    );

    test('maps CashOrderResponseDto to OrderEntity', () {
      final dto = CashOrderResponseDto.fromJson({
        'status': 'success',
        'data': {
          '_id': 'order-99',
          'totalOrderPrice': 4200,
          'paymentMethodType': 'cash',
          'isPaid': false,
          'isDelivered': false,
        },
      });

      final entity = mapper.mapCashOrderDtoToEntity(dto);

      expect(entity.id, 'order-99');
      expect(entity.totalOrderPrice, 4200);
      expect(entity.paymentMethodType, 'cash');
      expect(entity.isPaid, isFalse);
      expect(entity.isDelivered, isFalse);
    });

    test('maps CheckoutSessionResponseDto to CheckoutSessionEntity', () {
      final dto = CheckoutSessionResponseDto.fromJson({
        'status': 'success',
        'session': {
          'url': 'https://checkout.stripe.com/c/pay/cs_test_123',
          'success_url': 'http://localhost:3000/allorders',
          'cancel_url': 'http://localhost:3000/cart',
        },
      });

      final entity = mapper.mapCheckoutSessionDtoToEntity(dto);

      expect(entity.url, 'https://checkout.stripe.com/c/pay/cs_test_123');
      expect(entity.successUrl, 'http://localhost:3000/allorders');
      expect(entity.cancelUrl, 'http://localhost:3000/cart');
    });
  });
}
