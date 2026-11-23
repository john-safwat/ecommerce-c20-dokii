import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_actions.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_cubit.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_state.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/widgets/cart_checkout_bar.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/widgets/cart_item_card.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/widgets/cart_shimmer.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/widgets/checkout_bottom_sheet.dart';
import 'package:route_ecommerce/features/orders/presentation/payment/payment_web_view_args.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartCubit _cubit = getIt<CartCubit>();
  StreamSubscription<CartNavigationAction>? _navSub;
  bool _isCheckoutSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
    _cubit.doAction(GetCartProducts());
  }

  void _handleNavigation(CartNavigationAction event) {
    if (!mounted) return;
    switch (event) {
      case ShowCartToast(:final message, :final isError):
        _showSnackBar(message, isError: isError);
      case ShowCashOrderSuccessToast():
        _showSnackBar(context.locale.orderPlacedSuccessfully);
      case ShowCheckoutMissingCartIdToast():
        _showSnackBar(context.locale.cartNotReadyForCheckout, isError: true);
      case ShowPaymentResultToast(:final result):
        _showPaymentResultSnackBar(result);
      case DismissCheckoutSheet():
        _dismissCheckoutSheetIfOpen();
      case NavigateToPaymentWebView(:final session):
        _openPaymentWebView(session);
    }
  }

  void _dismissCheckoutSheetIfOpen() {
    if (_isCheckoutSheetOpen && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openCheckoutBottomSheet() async {
    if (_isCheckoutSheetOpen) return;
    _isCheckoutSheetOpen = true;
    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => BlocProvider.value(
          value: _cubit,
          child: const CheckoutBottomSheet(),
        ),
      );
    } finally {
      _isCheckoutSheetOpen = false;
    }
  }

  Future<void> _openPaymentWebView(CheckoutSessionEntity session) async {
    final result = await Navigator.of(context).pushNamed<PaymentWebViewResult>(
      AppRoutes.paymentWebView,
      arguments: PaymentWebViewArgs(
        checkoutUrl: session.url,
        successUrl: session.successUrl,
        cancelUrl: session.cancelUrl,
      ),
    );
    if (!mounted) return;
    _cubit.doAction(
      HandlePaymentCallback(result ?? PaymentWebViewResult.cancelled),
    );
  }

  void _showPaymentResultSnackBar(PaymentWebViewResult result) {
    switch (result) {
      case PaymentWebViewResult.success:
        _showSnackBar(context.locale.paymentSuccessful);
      case PaymentWebViewResult.cancelled:
        _showSnackBar(context.locale.paymentCancelled, isError: true);
      case PaymentWebViewResult.failed:
        _showSnackBar(context.locale.paymentFailed, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? context.colors.error
            : context.colors.primary,
      ),
    );
  }

  @override
  void dispose() {
    _navSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: _CartAppBar(
          onSearchTap: () => _showSnackBar(context.locale.comingSoon),
          onCartTap: () => _cubit.doAction(GetCartProducts()),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.cart.isEmpty) {
              return switch (state.cartResource.status) {
                Status.initial || Status.loading => const CartShimmer(),
                Status.error => _CartErrorView(
                  message:
                      state.cartResource.message ??
                      context.locale.failedToLoadCart,
                  onRetry: () => _cubit.doAction(GetCartProducts()),
                ),
                Status.success => const _EmptyCartView(),
              };
            }
            return _buildCartContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartState state) {
    final items = state.cart.values.toList(growable: false);
    final totalPriceText = _formatPrice(context, state.totalPrice);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _cubit.doAction(GetCartProducts()),
            child: ListView.separated(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                return CartItemCard(
                  key: ValueKey(item.id),
                  item: item,
                  isPending: state.isProductPending(item.id),
                  onIncrement: () =>
                      _cubit.doAction(UpdateCart(item.id, item.count + 1)),
                  onDecrement: () =>
                      _cubit.doAction(UpdateCart(item.id, item.count - 1)),
                  onRemove: () => _cubit.doAction(RemoveFromCart(item.id)),
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.productDetails, arguments: item.id),
                );
              },
            ),
          ),
        ),
        CartCheckoutBar(
          totalPriceText: totalPriceText,
          onCheckout: _openCheckoutBottomSheet,
        ),
      ],
    );
  }

  String _formatPrice(BuildContext context, double price) {
    final formatted = NumberFormat('#,##0.##').format(price);
    return '${context.locale.egpCurrency} $formatted';
  }
}

class _CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onCartTap;

  const _CartAppBar({required this.onSearchTap, required this.onCartTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(context.locale.cart, style: context.text.titleLarge),
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(Icons.arrow_back, color: context.colors.primary),
      ),
      actions: [
        IconButton(
          onPressed: onSearchTap,
          tooltip: context.locale.search,
          icon: Icon(Icons.search, color: context.colors.primary),
        ),
        IconButton(
          onPressed: onCartTap,
          tooltip: context.locale.cart,
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: context.colors.outline,
            ),
            const SizedBox(height: 16),
            Text(
              context.locale.emptyCart,
              textAlign: TextAlign.center,
              style: context.text.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CartErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              child: AppButton(
                label: context.locale.retry,
                height: 48,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
