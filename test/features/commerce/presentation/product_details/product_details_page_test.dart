import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/routing/route_gen.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_product_details_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_product_card.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/widgets/product_details_shimmer.dart';
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

class _FakeGetProductDetailsUseCase implements GetProductDetailsUseCase {
  final Future<Result<ProductDetailsEntity>> Function(String id) _handler;

  _FakeGetProductDetailsUseCase(this._handler);

  @override
  Future<Result<ProductDetailsEntity>> call(String productId) =>
      _handler(productId);
}

class _FakeGetUserCartUseCase implements GetUserCartUseCase {
  final Future<Result<CartEntity>> Function() _handler;

  _FakeGetUserCartUseCase(this._handler);

  @override
  Future<Result<CartEntity>> call() => _handler();
}

class _FakeAddToCartUseCase implements AddToCartUseCase {
  final Future<Result<CartEntity>> Function(String id) _handler;

  _FakeAddToCartUseCase(this._handler);

  @override
  Future<Result<CartEntity>> call(String productId) => _handler(productId);
}

class _FakeRemoveFromCartUseCase implements RemoveFromCartUseCase {
  final Future<Result<CartEntity>> Function(String id) _handler;

  _FakeRemoveFromCartUseCase(this._handler);

  @override
  Future<Result<CartEntity>> call(String productId) => _handler(productId);
}

class _FakeUpdateCartUseCase implements UpdateCartUseCase {
  final Future<Result<CartEntity>> Function(String id, int count) _handler;

  _FakeUpdateCartUseCase(this._handler);

  @override
  Future<Result<CartEntity>> call(String productId, int count) =>
      _handler(productId, count);
}

class _FakeCreateCashOrderUseCase implements CreateCashOrderUseCase {
  @override
  Future<Result<OrderEntity>> call({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
  }) async => Success(
    const OrderEntity(
      id: 'order-1',
      totalOrderPrice: 3500,
      paymentMethodType: 'cash',
      isPaid: false,
      isDelivered: false,
    ),
  );
}

class _FakeCreateCheckoutSessionUseCase
    implements CreateCheckoutSessionUseCase {
  @override
  Future<Result<CheckoutSessionEntity>> call({
    required String cartId,
    required ShippingAddressEntity shippingAddress,
    String callbackUrl = 'http://localhost:3000',
  }) async => Success(
    const CheckoutSessionEntity(
      url: 'https://checkout.stripe.com/pay/cs_test',
      successUrl: 'http://localhost:3000/allorders',
      cancelUrl: 'http://localhost:3000/cart',
    ),
  );
}

CartCubit _createCartCubit({List<CartProductEntity> initialItems = const []}) {
  final items = <String, CartProductEntity>{
    for (final item in initialItems) item.id: item,
  };
  return CartCubit(
    _FakeGetUserCartUseCase(
      () async => Success(
        CartEntity(cartId: 'cart-1', products: items.values.toList()),
      ),
    ),
    _FakeAddToCartUseCase((id) async {
      final existing = items[id];
      items[id] = CartProductEntity(
        (existing?.count ?? 0) + 1,
        id,
        existing?.price ?? 3500,
      );
      return Success(
        CartEntity(cartId: 'cart-1', products: items.values.toList()),
      );
    }),
    _FakeRemoveFromCartUseCase((id) async {
      items.remove(id);
      return Success(
        CartEntity(cartId: 'cart-1', products: items.values.toList()),
      );
    }),
    _FakeUpdateCartUseCase((id, count) async {
      final existing = items[id];
      items[id] = CartProductEntity(count, id, existing?.price ?? 3500);
      return Success(
        CartEntity(cartId: 'cart-1', products: items.values.toList()),
      );
    }),
    _FakeCreateCashOrderUseCase(),
    _FakeCreateCheckoutSessionUseCase(),
  );
}

const _sampleProduct = ProductDetailsEntity(
  id: 'p1',
  title: 'Nike Air Jordon',
  description:
      'Nike is a multinational corporation that designs, develops, and sells athletic footwear, apparel, and accessories.',
  images: [],
  price: 4000,
  priceAfterDiscount: 3500,
  sold: 3230,
  ratingsAverage: 4.8,
  ratingsQuantity: 7500,
  quantity: 10,
);

Widget _wrapWithApp(Widget child) {
  final colors = LightColors();
  return MaterialApp(
    theme: AppTheme(colors).theme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    onGenerateRoute: routeGen,
    home: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AppColors>(LightColors.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'shows shimmer while loading and renders product details on success',
    (tester) async {
      final completer = Completer<Result<ProductDetailsEntity>>();
      getIt.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(
          _FakeGetProductDetailsUseCase((_) => completer.future),
        ),
      );

      await tester.pumpWidget(
        _wrapWithApp(const ProductDetailsPage(productId: 'p1')),
      );
      await tester.pump();

      expect(find.byType(ProductDetailsShimmer), findsOneWidget);

      completer.complete(Success(_sampleProduct));
      await tester.pumpAndSettle();

      expect(find.text('Product Details'), findsOneWidget);
      expect(find.text('Nike Air Jordon'), findsOneWidget);
      expect(find.text('EGP 3,500'), findsNWidgets(2));
      expect(find.text('3,230 Sold'), findsOneWidget);
      expect(find.text('4.8 (7,500)'), findsOneWidget);
      expect(find.text('Add to cart'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('EGP 7,000'), findsOneWidget);
    },
  );

  testWidgets('tapping HomeProductCard navigates to ProductDetailsPage', (
    tester,
  ) async {
    getIt.registerFactory<ProductDetailsCubit>(
      () => ProductDetailsCubit(
        _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
      ),
    );

    final cardProduct = ProductEntity(
      'p1',
      'Nike Air Jordon',
      '',
      4.8,
      3500,
      3500,
    );

    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: Center(
            child: SizedBox(
              height: 256,
              child: HomeProductCard(product: cardProduct),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(HomeProductCard));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsPage), findsOneWidget);
    expect(find.text('Product Details'), findsOneWidget);
  });

  testWidgets('HomeProductCard toggles product in CartCubit', (tester) async {
    final cartCubit = _createCartCubit();
    getIt.registerSingleton<CartCubit>(cartCubit);

    final cardProduct = ProductEntity(
      'p1',
      'Nike Air Jordon',
      '',
      4.8,
      3500,
      3500,
    );

    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: Center(
            child: SizedBox(
              height: 256,
              child: HomeProductCard(product: cardProduct),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(cartCubit.state.cart.containsKey('p1'), isFalse);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(cartCubit.state.cart['p1']?.count, 1);
    expect(find.byIcon(Icons.remove_shopping_cart_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(cartCubit.state.cart.containsKey('p1'), isFalse);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await cartCubit.close();
  });

  testWidgets(
    'ProductDetailsPage adds, updates quantity, and removes product via CartCubit',
    (tester) async {
      final cartCubit = _createCartCubit();
      getIt.registerSingleton<CartCubit>(cartCubit);
      getIt.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(
          _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
        ),
      );

      await tester.pumpWidget(
        _wrapWithApp(const ProductDetailsPage(productId: 'p1')),
      );
      await tester.pumpAndSettle();

      // Increment local quantity to 2 before adding to cart.
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tap Add to cart -> adds with quantity 2.
      await tester.tap(find.text('Add to cart'));
      await tester.pumpAndSettle();

      expect(cartCubit.state.cart['p1']?.count, 2);
      expect(find.text('Remove from cart'), findsOneWidget);

      // Increment while in cart -> updates cart count to 3.
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();
      expect(cartCubit.state.cart['p1']?.count, 3);
      expect(find.text('EGP 10,500'), findsOneWidget);

      // Tap Remove from cart -> removes product.
      await tester.tap(find.text('Remove from cart'));
      await tester.pumpAndSettle();

      expect(cartCubit.state.cart.containsKey('p1'), isFalse);
      expect(find.text('Add to cart'), findsOneWidget);

      await cartCubit.close();
    },
  );
}
