import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
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
import 'package:route_ecommerce/features/orders/presentation/cart/cart_cubit.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_page.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/widgets/cart_shimmer.dart';
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
  late _FakeGetUserCartUseCase getUserCartUseCase;
  late _FakeAddToCartUseCase addToCartUseCase;
  late _FakeRemoveFromCartUseCase removeFromCartUseCase;
  late _FakeUpdateCartUseCase updateCartUseCase;
  late _FakeCreateCashOrderUseCase createCashOrderUseCase;
  late _FakeCreateCheckoutSessionUseCase createCheckoutSessionUseCase;
  late CartCubit cubit;

  const sampleItem = CartProductEntity(
    1,
    'p1',
    3500,
    title: 'Nike Air Jordan',
    brandName: 'Nike',
    categoryName: 'Shoes',
  );

  Widget buildTestableWidget({
    PaymentWebViewResult webViewReturnResult = PaymentWebViewResult.success,
  }) {
    final appColors = LightColors();
    final appTheme = AppTheme(appColors);
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme.theme,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.paymentWebView) {
          return MaterialPageRoute<PaymentWebViewResult>(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(webViewReturnResult),
                  child: const Text('Complete Mock Payment'),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const CartPage());
      },
      home: const CartPage(),
    );
  }

  Future<void> registerDependencies() async {
    await getIt.reset();
    getIt.registerSingleton<AppColors>(LightColors());
    cubit = CartCubit(
      getUserCartUseCase,
      addToCartUseCase,
      removeFromCartUseCase,
      updateCartUseCase,
      createCashOrderUseCase,
      createCheckoutSessionUseCase,
    );
    getIt.registerSingleton<CartCubit>(cubit);
  }

  setUp(() {
    getUserCartUseCase = _FakeGetUserCartUseCase(
      () async =>
          Success(const CartEntity(cartId: 'cart-123', products: [sampleItem])),
    );
    addToCartUseCase = _FakeAddToCartUseCase(
      (_) async =>
          Success(const CartEntity(cartId: 'cart-123', products: [sampleItem])),
    );
    removeFromCartUseCase = _FakeRemoveFromCartUseCase(
      (_) async => Success(const CartEntity(cartId: 'cart-123', products: [])),
    );
    updateCartUseCase = _FakeUpdateCartUseCase(
      (id, count) async => Success(
        CartEntity(
          cartId: 'cart-123',
          products: [sampleItem.copyWith(count: count)],
        ),
      ),
    );
    createCashOrderUseCase = _FakeCreateCashOrderUseCase(
      (_, _) async => Success(
        const OrderEntity(
          id: 'order-1',
          totalOrderPrice: 3500,
          paymentMethodType: 'cash',
          isPaid: false,
          isDelivered: false,
        ),
      ),
    );
    createCheckoutSessionUseCase = _FakeCreateCheckoutSessionUseCase(
      (_, _, _) async => Success(
        const CheckoutSessionEntity(
          url: 'https://checkout.stripe.com/pay/cs_test',
          successUrl: 'http://localhost:3000/allorders',
          cancelUrl: 'http://localhost:3000/cart',
        ),
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
    await getIt.reset();
  });

  group('CartPage', () {
    testWidgets('shows shimmer while cart is loading', (tester) async {
      final completer = Completer<Result<CartEntity>>();
      getUserCartUseCase.handler = () => completer.future;
      await registerDependencies();

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CartShimmer), findsOneWidget);

      completer.complete(
        Success(const CartEntity(cartId: 'cart-123', products: [sampleItem])),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state when cart has no items', (tester) async {
      getUserCartUseCase.handler = () async =>
          Success(const CartEntity(cartId: 'cart-123', products: []));
      await registerDependencies();

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Check Out'), findsNothing);
    });

    testWidgets('shows error view and retries on tap', (tester) async {
      var attempts = 0;
      getUserCartUseCase.handler = () async {
        attempts++;
        if (attempts <= 2) {
          return Failure('Network error');
        }
        return Success(
          const CartEntity(cartId: 'cart-123', products: [sampleItem]),
        );
      };
      await registerDependencies();

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Nike Air Jordan'), findsOneWidget);
    });

    testWidgets('renders cart item, total price, and updates quantity', (
      tester,
    ) async {
      await registerDependencies();

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Nike Air Jordan'), findsOneWidget);
      expect(find.text('Nike | Shoes'), findsOneWidget);
      expect(find.text('EGP 3,500'), findsNWidgets(2));
      expect(find.text('Total price'), findsOneWidget);
      expect(find.text('Check Out'), findsOneWidget);

      await tester.tap(find.byTooltip('Increase quantity'));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('EGP 7,000'), findsOneWidget);

      await tester.tap(find.byTooltip('Remove from cart'));
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets(
      'opens checkout bottom sheet and places cash on delivery order',
      (tester) async {
        var cashCalled = false;
        createCashOrderUseCase.handler = (cartId, address) async {
          cashCalled = true;
          expect(cartId, 'cart-123');
          expect(address.city, 'Cairo');
          return Success(
            const OrderEntity(
              id: 'order-1',
              totalOrderPrice: 3500,
              paymentMethodType: 'cash',
              isPaid: false,
              isDelivered: false,
            ),
          );
        };
        await registerDependencies();

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Check Out'));
        await tester.pumpAndSettle();

        expect(find.text('Select Payment Method'), findsOneWidget);
        expect(find.text('Credit Card'), findsOneWidget);
        expect(find.text('Cash on Delivery'), findsOneWidget);

        await tester.tap(find.text('Cash on Delivery'));
        await tester.pumpAndSettle();

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), '10 Nile Street');
        await tester.enterText(fields.at(1), '01012345678');
        await tester.enterText(fields.at(2), 'Cairo');

        await tester.ensureVisible(find.text('Place Order'));
        await tester.tap(find.text('Place Order'));
        await tester.pumpAndSettle();

        expect(cashCalled, isTrue);
        expect(find.text('Your cart is empty'), findsOneWidget);
        expect(find.text('Order placed successfully'), findsOneWidget);
      },
    );

    testWidgets(
      'opens checkout bottom sheet, launches credit card payment WebView, and clears cart on success',
      (tester) async {
        await registerDependencies();

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Check Out'));
        await tester.pumpAndSettle();

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), '10 Nile Street');
        await tester.enterText(fields.at(1), '01012345678');
        await tester.enterText(fields.at(2), 'Cairo');

        await tester.ensureVisible(find.text('Proceed to Payment'));
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        expect(find.text('Complete Mock Payment'), findsOneWidget);

        await tester.tap(find.text('Complete Mock Payment'));
        await tester.pumpAndSettle();

        expect(find.text('Your cart is empty'), findsOneWidget);
        expect(find.text('Payment completed successfully'), findsOneWidget);
      },
    );
  });
}
