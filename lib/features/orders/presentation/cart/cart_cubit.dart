import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/utils/app_logger.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_product_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/add_to_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/create_cash_order_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/create_checkout_session_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/get_user_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/remove_from_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/domain/use_cases/update_cart_use_case.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_actions.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_state.dart';
import 'package:route_ecommerce/features/orders/presentation/payment/payment_web_view_args.dart';

@singleton
class CartCubit
    extends BaseCubit<CartState, CartActions, CartNavigationAction> {
  static const String _logTag = 'CartCheckout';

  final GetUserCartUseCase _getUserCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateCartUseCase _updateCartUseCase;
  final CreateCashOrderUseCase _createCashOrderUseCase;
  final CreateCheckoutSessionUseCase _createCheckoutSessionUseCase;

  CartCubit(
    this._getUserCartUseCase,
    this._addToCartUseCase,
    this._removeFromCartUseCase,
    this._updateCartUseCase,
    this._createCashOrderUseCase,
    this._createCheckoutSessionUseCase,
  ) : super(CartState()) {
    doAction(GetCartProducts());
  }

  @override
  Future<void> doAction(CartActions action) async {
    switch (action) {
      case GetCartProducts():
        await _getUserCart();
      case AddToCart():
        await _addToCart(action);
      case RemoveFromCart():
        await _removeFromCart(action);
      case UpdateCart():
        await _updateCart(action);
      case CheckoutCashOrder():
        await _checkoutCashOrder(action);
      case CheckoutCreditCard():
        await _checkoutCreditCard(action);
      case HandlePaymentCallback():
        _handlePaymentCallback(action);
    }
  }

  Future<void> _getUserCart() async {
    emit(state.copyWith(cartResource: Resources.loading()));
    final result = await _getUserCartUseCase();
    if (isClosed) return;

    switch (result) {
      case Success<CartEntity>():
        final cartMap = _mapCartListToMap(result.data?.products);
        final resolvedCartId = _resolveCartId(result.data?.cartId);
        emit(
          state.copyWith(
            cartId: resolvedCartId,
            cart: cartMap,
            cartResource: Resources.success(cartMap),
          ),
        );
      case Failure<CartEntity>():
        emit(state.copyWith(cartResource: Resources.error(result.message)));
        emitNavigation(ShowCartToast(result.message, isError: true));
    }
  }

  Future<void> _addToCart(AddToCart action) async {
    if (state.isProductPending(action.productId)) return;

    final previousCart = Map<String, CartProductEntity>.from(state.cart);
    final existing = previousCart[action.productId];
    final nextPending = Set<String>.from(state.pendingProductIds)
      ..add(action.productId);

    if (existing != null) {
      final optimisticCart = Map<String, CartProductEntity>.from(previousCart)
        ..[action.productId] = existing.copyWith(
          count: existing.count + action.quantity,
        );
      emit(
        state.copyWith(cart: optimisticCart, pendingProductIds: nextPending),
      );
    } else {
      emit(state.copyWith(pendingProductIds: nextPending));
    }

    await _applyCartMutation(
      productId: action.productId,
      previousCart: previousCart,
      mutation: () => _performAddToCart(action),
    );
  }

  Future<Result<CartEntity>> _performAddToCart(AddToCart action) async {
    final addResult = await _addToCartUseCase(action.productId);
    if (action.quantity <= 1 || addResult is! Success<CartEntity>) {
      return addResult;
    }
    return _updateCartUseCase(action.productId, action.quantity);
  }

  Future<void> _removeFromCart(RemoveFromCart action) async {
    if (state.isProductPending(action.productId)) return;

    final previousCart = Map<String, CartProductEntity>.from(state.cart);
    final optimisticCart = Map<String, CartProductEntity>.from(previousCart)
      ..remove(action.productId);
    final nextPending = Set<String>.from(state.pendingProductIds)
      ..add(action.productId);
    emit(state.copyWith(cart: optimisticCart, pendingProductIds: nextPending));

    await _applyCartMutation(
      productId: action.productId,
      previousCart: previousCart,
      mutation: () => _removeFromCartUseCase(action.productId),
    );
  }

  Future<void> _updateCart(UpdateCart action) async {
    if (action.count <= 0) {
      await _removeFromCart(RemoveFromCart(action.productId));
      return;
    }
    if (state.isProductPending(action.productId)) return;

    final previousCart = Map<String, CartProductEntity>.from(state.cart);
    final existing = previousCart[action.productId];
    final nextPending = Set<String>.from(state.pendingProductIds)
      ..add(action.productId);

    if (existing != null) {
      final optimisticCart = Map<String, CartProductEntity>.from(previousCart)
        ..[action.productId] = existing.copyWith(count: action.count);
      emit(
        state.copyWith(cart: optimisticCart, pendingProductIds: nextPending),
      );
    } else {
      emit(state.copyWith(pendingProductIds: nextPending));
    }

    await _applyCartMutation(
      productId: action.productId,
      previousCart: previousCart,
      mutation: () => _updateCartUseCase(action.productId, action.count),
    );
  }

  Future<void> _checkoutCashOrder(CheckoutCashOrder action) async {
    if (state.isCheckingOut) return;
    if (state.cartId.isEmpty) {
      AppLogger.w('Cash checkout aborted: missing cartId', tag: _logTag);
      emitNavigation(const ShowCheckoutMissingCartIdToast());
      return;
    }

    AppLogger.i(
      'Starting cash order checkout | cartId=${state.cartId}',
      tag: _logTag,
    );
    emit(state.copyWith(checkoutResource: Resources.loading()));

    final result = await _createCashOrderUseCase(
      cartId: state.cartId,
      shippingAddress: action.shippingAddress,
    );
    if (isClosed) return;

    switch (result) {
      case Success<OrderEntity>():
        AppLogger.i(
          'Cash order created | orderId=${result.data?.id} | '
          'total=${result.data?.totalOrderPrice}',
          tag: _logTag,
        );
        emit(
          state.copyWith(
            cartId: '',
            cart: const {},
            cartResource: Resources.success(const {}),
            checkoutResource: Resources.success(null),
          ),
        );
        emitNavigation(const DismissCheckoutSheet());
        emitNavigation(const ShowCashOrderSuccessToast());
      case Failure<OrderEntity>():
        AppLogger.e(
          'Cash order failed | message=${result.message}',
          tag: _logTag,
          error: result.exception,
        );
        emit(state.copyWith(checkoutResource: Resources.error(result.message)));
        emitNavigation(ShowCartToast(result.message, isError: true));
    }
  }

  Future<void> _checkoutCreditCard(CheckoutCreditCard action) async {
    if (state.isCheckingOut) return;
    if (state.cartId.isEmpty) {
      AppLogger.w('Credit card checkout aborted: missing cartId', tag: _logTag);
      emitNavigation(const ShowCheckoutMissingCartIdToast());
      return;
    }

    AppLogger.i(
      'Creating online checkout session | cartId=${state.cartId}',
      tag: _logTag,
    );
    emit(state.copyWith(checkoutResource: Resources.loading()));

    final result = await _createCheckoutSessionUseCase(
      cartId: state.cartId,
      shippingAddress: action.shippingAddress,
    );
    if (isClosed) return;

    switch (result) {
      case Success<CheckoutSessionEntity>():
        final session = result.data;
        if (session == null || session.url.isEmpty) {
          emit(
            state.copyWith(
              checkoutResource: Resources.error('Missing payment session URL'),
            ),
          );
          emitNavigation(
            const ShowPaymentResultToast(PaymentWebViewResult.failed),
          );
          return;
        }
        AppLogger.i(
          'Checkout session ready | url=${session.url}',
          tag: _logTag,
        );
        emit(state.copyWith(checkoutResource: Resources.success(null)));
        emitNavigation(const DismissCheckoutSheet());
        emitNavigation(NavigateToPaymentWebView(session));
      case Failure<CheckoutSessionEntity>():
        AppLogger.e(
          'Checkout session creation failed | message=${result.message}',
          tag: _logTag,
          error: result.exception,
        );
        emit(state.copyWith(checkoutResource: Resources.error(result.message)));
        emitNavigation(ShowCartToast(result.message, isError: true));
    }
  }

  void _handlePaymentCallback(HandlePaymentCallback action) {
    AppLogger.i(
      'Handling payment WebView callback | result=${action.result.name}',
      tag: _logTag,
    );
    if (action.result == PaymentWebViewResult.success) {
      emit(
        state.copyWith(
          cartId: '',
          cart: const {},
          cartResource: Resources.success(const {}),
          checkoutResource: Resources.success(null),
        ),
      );
    }
    emitNavigation(ShowPaymentResultToast(action.result));
  }

  Future<void> _applyCartMutation({
    required String productId,
    required Map<String, CartProductEntity> previousCart,
    required Future<Result<CartEntity>> Function() mutation,
  }) async {
    final result = await mutation();
    if (isClosed) return;

    final remainingPending = Set<String>.from(state.pendingProductIds)
      ..remove(productId);

    switch (result) {
      case Success<CartEntity>():
        final cartMap = _mapCartListToMap(
          result.data?.products,
          fallback: previousCart,
        );
        emit(
          state.copyWith(
            cartId: _resolveCartId(result.data?.cartId),
            cart: cartMap,
            cartResource: Resources.success(cartMap),
            pendingProductIds: remainingPending,
          ),
        );
      case Failure<CartEntity>():
        emit(
          state.copyWith(
            cart: previousCart,
            pendingProductIds: remainingPending,
          ),
        );
        emitNavigation(ShowCartToast(result.message, isError: true));
    }
  }

  String _resolveCartId(String? candidate) {
    if (candidate != null && candidate.isNotEmpty) {
      return candidate;
    }
    return state.cartId;
  }

  Map<String, CartProductEntity> _mapCartListToMap(
    List<CartProductEntity>? items, {
    Map<String, CartProductEntity>? fallback,
  }) {
    final mapped = <String, CartProductEntity>{};
    for (final item in items ?? const <CartProductEntity>[]) {
      final previous = fallback?[item.id];
      mapped[item.id] = (item.title.isEmpty && previous != null)
          ? item.copyWith(
              title: previous.title,
              imageCover: previous.imageCover,
              brandName: previous.brandName,
              categoryName: previous.categoryName,
            )
          : item;
    }
    return mapped;
  }
}
