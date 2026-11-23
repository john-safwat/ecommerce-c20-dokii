import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/data/datasource/orders_api_client.dart';
import 'package:route_ecommerce/features/orders/data/mapper/orders_mapper.dart';
import 'package:route_ecommerce/features/orders/data/models/cart_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/cash_order_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/checkout_session_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/repo/orders_repo_impl.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';

class _FakeOrdersApiClient implements OrdersApiClient {
  String? lastCartId;
  String? lastCallbackUrl;
  Map<String, dynamic>? lastBody;

  Future<CashOrderResponseDto> Function(
    String cartId,
    Map<String, dynamic> body,
  )?
  cashOrderHandler;

  Future<CheckoutSessionResponseDto> Function(
    String cartId,
    String callbackUrl,
    Map<String, dynamic> body,
  )?
  checkoutSessionHandler;

  @override
  Future<CartResponseDto> addToCartProduct(Map<String, dynamic> body) async =>
      CartResponseDto();

  @override
  Future<CartResponseDto> getUserCart() async => CartResponseDto();

  @override
  Future<CartResponseDto> removeFromCartProduct(String id) async =>
      CartResponseDto();

  @override
  Future<CartResponseDto> updateCartProduct(
    String id,
    Map<String, dynamic> body,
  ) async => CartResponseDto();

  @override
  Future<CashOrderResponseDto> createCashOrder(
    String cartId,
    Map<String, dynamic> body,
  ) async {
    lastCartId = cartId;
    lastBody = body;
    return cashOrderHandler!(cartId, body);
  }

  @override
  Future<CheckoutSessionResponseDto> createCheckoutSession(
    String cartId,
    String callbackUrl,
    Map<String, dynamic> body,
  ) async {
    lastCartId = cartId;
    lastCallbackUrl = callbackUrl;
    lastBody = body;
    return checkoutSessionHandler!(cartId, callbackUrl, body);
  }
}

void main() {
  group('OrdersRepoImpl checkout', () {
    late _FakeOrdersApiClient apiClient;
    late OrdersRepoImpl repo;

    const address = ShippingAddressEntity(
      details: 'Test address',
      phone: '01000000000',
      city: 'Cairo',
      postalCode: '12345',
    );

    setUp(() {
      apiClient = _FakeOrdersApiClient();
      repo = OrdersRepoImpl(apiClient, OrdersMapper());
    });

    test(
      'createCashOrder sends v2 cash order payload and maps OrderEntity',
      () async {
        apiClient.cashOrderHandler = (_, _) async =>
            CashOrderResponseDto.fromJson({
              'status': 'success',
              'data': {
                '_id': 'order-77',
                'totalOrderPrice': 1500,
                'paymentMethodType': 'cash',
                'isPaid': false,
                'isDelivered': false,
              },
            });

        final result = await repo.createCashOrder(
          cartId: 'cart-55',
          shippingAddress: address,
        );

        expect(apiClient.lastCartId, 'cart-55');
        expect(apiClient.lastBody, {
          'shippingAddress': {
            'details': 'Test address',
            'phone': '01000000000',
            'city': 'Cairo',
            'postalCode': '12345',
          },
        });
        expect(result, isA<Success<OrderEntity>>());
        final order = (result as Success<OrderEntity>).data!;
        expect(order.id, 'order-77');
        expect(order.totalOrderPrice, 1500);
      },
    );

    test(
      'createCheckoutSession sends v1 checkout-session with default url and maps CheckoutSessionEntity',
      () async {
        apiClient.checkoutSessionHandler = (_, _, _) async =>
            CheckoutSessionResponseDto.fromJson({
              'status': 'success',
              'session': {
                'url': 'https://checkout.stripe.com/pay/cs_test',
                'success_url': 'http://localhost:3000/allorders',
                'cancel_url': 'http://localhost:3000/cart',
              },
            });

        final result = await repo.createCheckoutSession(
          cartId: 'cart-55',
          shippingAddress: address,
        );

        expect(apiClient.lastCartId, 'cart-55');
        expect(apiClient.lastCallbackUrl, 'http://localhost:3000');
        expect(apiClient.lastBody, {
          'shippingAddress': {
            'details': 'Test address',
            'phone': '01000000000',
            'city': 'Cairo',
          },
        });
        expect(result, isA<Success<CheckoutSessionEntity>>());
        final session = (result as Success<CheckoutSessionEntity>).data!;
        expect(session.url, 'https://checkout.stripe.com/pay/cs_test');
      },
    );

    test(
      'createCheckoutSession returns Failure when session URL is empty',
      () async {
        apiClient.checkoutSessionHandler = (_, _, _) async =>
            CheckoutSessionResponseDto.fromJson({'status': 'success'});

        final result = await repo.createCheckoutSession(
          cartId: 'cart-55',
          shippingAddress: address,
        );

        expect(result, isA<Failure<CheckoutSessionEntity>>());
      },
    );
  });
}
