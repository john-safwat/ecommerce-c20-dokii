import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_product_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/add_to_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/create_cash_order_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/create_checkout_session_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/get_user_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/remove_from_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/update_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_actions.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_cubit.dart';
import 'package:route_ecommerce/features/orders/presentation/payment/payment_web_view_args.dart';

class _FakeGetUserCartUseCase implements GetUserCartUseCase {
  Future<Result<CartEntity>> Function() handler;

  _FakeGetUserCartUseCase(this.handler);

  @override
  Future<Result<CartEntity>> call() => handler();
}

class _FakeAddToCartUseCase implements AddToCartUseCase {
  Future<Result<CartEntity>> Function(String productId) handler;

  _FakeAddToCartUseCase(this.handler);

  @override
  Future<Result<CartEntity>> call(String productId) => handler(productId);
}

class _FakeRemoveFromCartUseCase implements RemoveFromCartUseCase {
  Future<Result<CartEntity>> Function(String productId) handler;

  _FakeRemoveFromCartUseCase(this.handler);

  @override
  Future<Result<CartEntity>> call(String productId) => handler(productId);
}

class _FakeUpdateCartUseCase implements UpdateCartUseCase {
  Future<Result<CartEntity>> Function(String productId, int count) handler;

  _FakeUpdateCartUseCase(this.handler);

  @override
  Future<Result<CartEntity>> call(String productId, int count) =>
      handler(productId, count);
}

class _FakeCreateCashOrderUseCase implements CreateCashOrderUseCase {
  Future<Result<OrderEntity>> Function(
    String cartId,
    ShippingAddressEntity shippingAddress,
  )
  handler;

  _FakeCreateCashOrderUseCase(this.handler);

  @override
  Future<Result<OrderEntity>> call({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
  }) => handler(cartId, shippingAddress);
}

class _FakeCreateCheckoutSessionUseCase
    implements CreateCheckoutSessionUseCase {
  Future<Result<CheckoutSessionEntity>> Function(
    String cartId,
    ShippingAddressEntity shippingAddress,
    String callbackUrl,
  )
  handler;

  _FakeCreateCheckoutSessionUseCase(this.handler);

  @override
  Future<Result<CheckoutSessionEntity>> call({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
    String callbackUrl = 'http://localhost:3000',
  }) => handler(cartId, shippingAddress, callbackUrl);
}

void main() {
  group('CartCubit', () {
    late _FakeGetUserCartUseCase getUserCartUseCase;
    late _FakeAddToCartUseCase addToCartUseCase;
    late _FakeRemoveFromCartUseCase removeFromCartUseCase;
    late _FakeUpdateCartUseCase updateCartUseCase;
    late _FakeCreateCashOrderUseCase createCashOrderUseCase;
    late _FakeCreateCheckoutSessionUseCase createCheckoutSessionUseCase;

    const sampleAddress = ShippingAddressEntity(
      details: '10 Nile Corniche',
      phone: '01012345678',
      city: 'Cairo',
      postalCode: '12345',
    );

    CartCubit createCubit() => CartCubit(
      getUserCartUseCase,
      addToCartUseCase,
      removeFromCartUseCase,
      updateCartUseCase,
      createCashOrderUseCase,
      createCheckoutSessionUseCase,
    );

    setUp(() {
      getUserCartUseCase = _FakeGetUserCartUseCase(
        () async => Success(
          CartEntity(
            cartId: 'cart-123',
            products: [CartProductEntity(2, 'p1', 150)],
          ),
        ),
      );
      addToCartUseCase = _FakeAddToCartUseCase(
        (id) async => Success(
          CartEntity(
            cartId: 'cart-123',
            products: [CartProductEntity(1, id, 200)],
          ),
        ),
      );
      removeFromCartUseCase = _FakeRemoveFromCartUseCase(
        (_) async =>
            Success(const CartEntity(cartId: 'cart-123', products: [])),
      );
      updateCartUseCase = _FakeUpdateCartUseCase(
        (id, count) async => Success(
          CartEntity(
            cartId: 'cart-123',
            products: [CartProductEntity(count, id, 150)],
          ),
        ),
      );
      createCashOrderUseCase = _FakeCreateCashOrderUseCase(
        (_, _) async => Success(
          const OrderEntity(
            id: 'order-1',
            totalOrderPrice: 300,
            paymentMethodType: 'cash',
            isPaid: false,
            isDelivered: false,
          ),
        ),
      );
      createCheckoutSessionUseCase = _FakeCreateCheckoutSessionUseCase(
        (_, _, _) async => Success(
          const CheckoutSessionEntity(
            url: 'https://checkout.stripe.com/c/pay/cs_test',
            successUrl: 'http://localhost:3000/allorders',
            cancelUrl: 'http://localhost:3000/cart',
          ),
        ),
      );
    });

    test('loads initial cart and cartId on creation', () async {
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.cartResource.status, Status.success);
      expect(cubit.state.cartId, 'cart-123');
      expect(cubit.state.cart.keys, ['p1']);
      expect(cubit.state.cart['p1']?.count, 2);
      expect(cubit.state.cart['p1']?.price, 150);
      await cubit.close();
    });

    test('GetCartProducts emits error and toast on failure', () async {
      getUserCartUseCase.handler = () async => Failure('Cart fetch failed');
      final cubit = createCubit();
      final navEvents = <CartNavigationAction>[];
      final sub = cubit.navStream.listen(navEvents.add);

      await cubit.doAction(GetCartProducts());
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.cartResource.status, Status.error);
      expect(navEvents.last, isA<ShowCartToast>());
      final toast = navEvents.last as ShowCartToast;
      expect(toast.isError, isTrue);
      expect(toast.message, 'Cart fetch failed');
      await sub.cancel();
      await cubit.close();
    });

    test('AddToCart adds new product to cart on success', () async {
      addToCartUseCase.handler = (_) async => Success(
        CartEntity(
          cartId: 'cart-123',
          products: [
            CartProductEntity(2, 'p1', 150),
            CartProductEntity(1, 'p2', 300),
          ],
        ),
      );
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      await cubit.doAction(AddToCart('p2'));

      expect(cubit.state.cart.length, 2);
      expect(cubit.state.cart['p2']?.price, 300);
      await cubit.close();
    });

    test(
      'AddToCart optimistically increments existing product and rolls back on failure',
      () async {
        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        addToCartUseCase.handler = (_) async => Failure('Add failed');
        final emittedCounts = <int?>[];
        final sub = cubit.stream.listen(
          (s) => emittedCounts.add(s.cart['p1']?.count),
        );
        final navEvents = <CartNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(AddToCart('p1'));
        await Future<void>.delayed(Duration.zero);

        expect(emittedCounts, [3, 2]);
        expect(cubit.state.cart['p1']?.count, 2);
        expect((navEvents.single as ShowCartToast).message, 'Add failed');
        await sub.cancel();
        await navSub.cancel();
        await cubit.close();
      },
    );

    test(
      'RemoveFromCart optimistically removes item and commits on success',
      () async {
        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        await cubit.doAction(RemoveFromCart('p1'));

        expect(cubit.state.cart, isEmpty);
        expect(cubit.state.cartResource.status, Status.success);
        await cubit.close();
      },
    );

    test('RemoveFromCart rolls back and emits toast on failure', () async {
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      removeFromCartUseCase.handler = (_) async => Failure('Remove failed');
      final navEvents = <CartNavigationAction>[];
      final navSub = cubit.navStream.listen(navEvents.add);

      await cubit.doAction(RemoveFromCart('p1'));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.cart['p1']?.count, 2);
      expect((navEvents.single as ShowCartToast).message, 'Remove failed');
      await navSub.cancel();
      await cubit.close();
    });

    test(
      'UpdateCart optimistically updates count and commits on success',
      () async {
        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        final emittedCounts = <int?>[];
        final sub = cubit.stream.listen(
          (s) => emittedCounts.add(s.cart['p1']?.count),
        );

        await cubit.doAction(UpdateCart('p1', 5));
        await Future<void>.delayed(Duration.zero);

        expect(emittedCounts, [5, 5]);
        expect(cubit.state.cart['p1']?.count, 5);
        await sub.cancel();
        await cubit.close();
      },
    );

    test('UpdateCart rolls back and emits toast on failure', () async {
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      updateCartUseCase.handler = (_, _) async => Failure('Update failed');
      final navEvents = <CartNavigationAction>[];
      final navSub = cubit.navStream.listen(navEvents.add);

      await cubit.doAction(UpdateCart('p1', 5));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.cart['p1']?.count, 2);
      expect((navEvents.single as ShowCartToast).message, 'Update failed');
      await navSub.cancel();
      await cubit.close();
    });

    test('UpdateCart with count <= 0 removes product from cart', () async {
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      await cubit.doAction(UpdateCart('p1', 0));

      expect(cubit.state.cart, isEmpty);
      await cubit.close();
    });

    test('AddToCart with quantity > 1 chains UpdateCart on success', () async {
      var updatedId = '';
      var updatedCount = 0;
      addToCartUseCase.handler = (id) async => Success(
        CartEntity(
          cartId: 'cart-123',
          products: [CartProductEntity(1, id, 200)],
        ),
      );
      updateCartUseCase.handler = (id, count) async {
        updatedId = id;
        updatedCount = count;
        return Success(
          CartEntity(
            cartId: 'cart-123',
            products: [CartProductEntity(count, id, 200)],
          ),
        );
      };
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      await cubit.doAction(AddToCart('p2', quantity: 3));

      expect(updatedId, 'p2');
      expect(updatedCount, 3);
      expect(cubit.state.cart['p2']?.count, 3);
      expect(cubit.state.totalItemsCount, 3);
      await cubit.close();
    });

    test('tracks pendingProductIds while mutation is in flight', () async {
      final completer = Completer<Result<CartEntity>>();
      addToCartUseCase.handler = (_) => completer.future;
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      final future = cubit.doAction(AddToCart('p2'));
      expect(cubit.state.isProductPending('p2'), isTrue);

      completer.complete(
        Success(
          CartEntity(
            cartId: 'cart-123',
            products: [CartProductEntity(1, 'p2', 200)],
          ),
        ),
      );
      await future;

      expect(cubit.state.isProductPending('p2'), isFalse);
      expect(cubit.state.cart['p2']?.count, 1);
      await cubit.close();
    });

    test('totalPrice sums price multiplied by count across items', () async {
      getUserCartUseCase.handler = () async => Success(
        const CartEntity(
          cartId: 'cart-123',
          products: [
            CartProductEntity(2, 'p1', 150, title: 'Shoes'),
            CartProductEntity(3, 'p2', 100, title: 'Hat'),
          ],
        ),
      );
      final cubit = createCubit();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.totalPrice, 600);
      expect(cubit.state.totalItemsCount, 5);
      await cubit.close();
    });

    test(
      'UpdateCart preserves product metadata when mutation returns minimal DTO',
      () async {
        getUserCartUseCase.handler = () async => Success(
          const CartEntity(
            cartId: 'cart-123',
            products: [
              CartProductEntity(
                1,
                'p1',
                3500,
                title: 'Nike Air Jordan',
                imageCover: 'https://example.com/shoe.png',
                brandName: 'Nike',
                categoryName: 'Shoes',
              ),
            ],
          ),
        );
        updateCartUseCase.handler = (id, count) async => Success(
          CartEntity(
            cartId: 'cart-123',
            products: [CartProductEntity(count, id, 3500)],
          ),
        );

        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        await cubit.doAction(UpdateCart('p1', 2));

        final item = cubit.state.cart['p1'];
        expect(item?.count, 2);
        expect(item?.title, 'Nike Air Jordan');
        expect(item?.imageCover, 'https://example.com/shoe.png');
        expect(item?.brandName, 'Nike');
        expect(item?.categoryName, 'Shoes');
        await cubit.close();
      },
    );

    test(
      'CheckoutCashOrder calls cash order use case, clears cart, dismisses sheet, and emits success toast',
      () async {
        var receivedCartId = '';
        createCashOrderUseCase.handler = (cartId, address) async {
          receivedCartId = cartId;
          return Success(
            const OrderEntity(
              id: 'order-42',
              totalOrderPrice: 300,
              paymentMethodType: 'cash',
              isPaid: false,
              isDelivered: false,
            ),
          );
        };

        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        final navEvents = <CartNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(CheckoutCashOrder(sampleAddress));
        await Future<void>.delayed(Duration.zero);

        expect(receivedCartId, 'cart-123');
        expect(cubit.state.cart, isEmpty);
        expect(cubit.state.cartId, isEmpty);
        expect(cubit.state.checkoutResource.status, Status.success);
        expect(navEvents, [
          isA<DismissCheckoutSheet>(),
          isA<ShowCashOrderSuccessToast>(),
        ]);
        await navSub.cancel();
        await cubit.close();
      },
    );

    test(
      'CheckoutCashOrder preserves cart and emits error toast on failure',
      () async {
        createCashOrderUseCase.handler = (_, _) async =>
            Failure('Cash order failed');
        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        final navEvents = <CartNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(CheckoutCashOrder(sampleAddress));
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.cart, isNotEmpty);
        expect(cubit.state.checkoutResource.status, Status.error);
        expect(navEvents.single, isA<ShowCartToast>());
        expect(
          (navEvents.single as ShowCartToast).message,
          'Cash order failed',
        );
        await navSub.cancel();
        await cubit.close();
      },
    );

    test(
      'CheckoutCreditCard creates session, dismisses sheet, and navigates to payment WebView',
      () async {
        var receivedCartId = '';
        createCheckoutSessionUseCase.handler = (cartId, _, _) async {
          receivedCartId = cartId;
          return Success(
            const CheckoutSessionEntity(
              url: 'https://checkout.stripe.com/pay/cs_1',
              successUrl: 'http://localhost:3000/allorders',
              cancelUrl: 'http://localhost:3000/cart',
            ),
          );
        };
        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        final navEvents = <CartNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(CheckoutCreditCard(sampleAddress));
        await Future<void>.delayed(Duration.zero);

        expect(receivedCartId, 'cart-123');
        expect(cubit.state.checkoutResource.status, Status.success);
        expect(navEvents, [
          isA<DismissCheckoutSheet>(),
          isA<NavigateToPaymentWebView>(),
        ]);
        final nav = navEvents.last as NavigateToPaymentWebView;
        expect(nav.session.url, 'https://checkout.stripe.com/pay/cs_1');
        await navSub.cancel();
        await cubit.close();
      },
    );

    test(
      'HandlePaymentCallback clears cart on success and keeps cart on cancel',
      () async {
        final cubit = createCubit();
        await Future<void>.delayed(Duration.zero);

        final navEvents = <CartNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(
          HandlePaymentCallback(PaymentWebViewResult.cancelled),
        );
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.cart, isNotEmpty);
        expect(
          (navEvents.last as ShowPaymentResultToast).result,
          PaymentWebViewResult.cancelled,
        );

        await cubit.doAction(
          HandlePaymentCallback(PaymentWebViewResult.success),
        );
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.cart, isEmpty);
        expect(cubit.state.cartId, isEmpty);
        expect(
          (navEvents.last as ShowPaymentResultToast).result,
          PaymentWebViewResult.success,
        );

        await navSub.cancel();
        await cubit.close();
      },
    );
  });
}
