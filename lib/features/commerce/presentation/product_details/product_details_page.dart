import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_states.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/widgets/product_details_shimmer.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/widgets/product_details_variants.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/widgets/product_image_carousel.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductDetailsCubit _cubit = getIt<ProductDetailsCubit>();
  StreamSubscription<ProductDetailsNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
    if (widget.productId.isNotEmpty) {
      _cubit.doAction(LoadProductDetailsAction(widget.productId));
    }
  }

  void _handleNavigation(ProductDetailsNavigationAction event) {
    if (!mounted) return;
    switch (event) {
      case ShowProductDetailsToast(:final message, :final isError):
        _showSnackBar(message, isError: isError);
      case ShowAddedToCartToast():
        _showSnackBar(context.locale.addedToCart);
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
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: _ProductDetailsAppBar(
          onSearchTap: () => _showSnackBar(context.locale.comingSoon),
          onCartTap: () => _showSnackBar(context.locale.comingSoon),
        ),
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
          builder: (context, state) {
            return switch (state.productResource.status) {
              Status.initial || Status.loading => const ProductDetailsShimmer(),
              Status.error => _ProductErrorView(
                message:
                    state.productResource.message ??
                    context.locale.failedToLoadProductDetails,
                onRetry: () =>
                    _cubit.doAction(LoadProductDetailsAction(widget.productId)),
              ),
              Status.success => _buildContent(
                context,
                state,
                state.productResource.data!,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductDetailsStates state,
    ProductDetailsEntity product,
  ) {
    final unitPrice = product.effectivePrice;
    final totalPrice = unitPrice * state.quantity;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageCarousel(
                  images: product.images,
                  isWishlisted: state.isWishlisted,
                  onWishlistTap: () =>
                      _cubit.doAction(const ToggleWishlistAction()),
                ),
                const SizedBox(height: 20),
                _TitleAndPriceRow(
                  title: product.title,
                  priceText: _formatPrice(context, unitPrice),
                ),
                const SizedBox(height: 16),
                _MetricsAndStepperRow(
                  sold: product.sold,
                  rating: product.ratingsAverage,
                  ratingsCount: product.ratingsQuantity,
                  quantity: state.quantity,
                  onDecrement: () =>
                      _cubit.doAction(const DecrementQuantityAction()),
                  onIncrement: () =>
                      _cubit.doAction(const IncrementQuantityAction()),
                ),
                const SizedBox(height: 16),
                _DescriptionSection(
                  description: product.description,
                  isExpanded: state.isDescriptionExpanded,
                  onToggle: () =>
                      _cubit.doAction(const ToggleDescriptionAction()),
                ),
                const SizedBox(height: 16),
                ProductSizeSelector(
                  selectedIndex: state.selectedSizeIndex,
                  onSelect: (index) => _cubit.doAction(SelectSizeAction(index)),
                ),
                const SizedBox(height: 16),
                ProductColorSelector(
                  selectedIndex: state.selectedColorIndex,
                  onSelect: (index) =>
                      _cubit.doAction(SelectColorAction(index)),
                ),
              ],
            ),
          ),
        ),
        _BottomPriceBar(
          totalPriceText: _formatPrice(context, totalPrice),
          onAddToCart: () => _cubit.doAction(const AddToCartAction()),
        ),
      ],
    );
  }

  String _formatPrice(BuildContext context, double price) {
    final formatted = NumberFormat('#,##0.##').format(price);
    return '${context.locale.egpCurrency} $formatted';
  }
}

class _ProductDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onCartTap;

  const _ProductDetailsAppBar({
    required this.onSearchTap,
    required this.onCartTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        context.locale.productDetails,
        style: context.text.titleLarge,
      ),
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

class _TitleAndPriceRow extends StatelessWidget {
  final String title;
  final String priceText;

  const _TitleAndPriceRow({required this.title, required this.priceText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          priceText,
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MetricsAndStepperRow extends StatelessWidget {
  final int sold;
  final double rating;
  final int ratingsCount;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _MetricsAndStepperRow({
    required this.sold,
    required this.rating,
    required this.ratingsCount,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = getIt.isRegistered<AppColors>()
        ? getIt<AppColors>().starColor
        : context.colors.primary;
    final soldText = NumberFormat('#,##0').format(sold);
    final countText = NumberFormat('#,##0').format(ratingsCount);

    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colors.outline),
          ),
          child: Text(
            context.locale.soldCount(soldText),
            style: context.text.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.star, size: 18, color: starColor),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${rating.toStringAsFixed(1)} ($countText)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        _QuantityStepper(
          quantity: quantity,
          onDecrement: onDecrement,
          onIncrement: onIncrement,
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            tooltip: context.locale.decreaseQuantity,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.remove_circle_outline,
              color: context.colors.onPrimary,
              size: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              style: context.text.titleSmall?.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            tooltip: context.locale.increaseQuantity,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.add_circle_outline,
              color: context.colors.onPrimary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _DescriptionSection({
    required this.description,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = getIt.isRegistered<AppColors>()
        ? getIt<AppColors>().textSecondaryColor
        : context.colors.onSurface.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.locale.description, style: context.text.titleMedium),
        const SizedBox(height: 6),
        Text(
          description,
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: context.text.bodyMedium?.copyWith(color: textSecondary),
        ),
        if (description.length > 90)
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 4),
              child: Text(
                isExpanded ? context.locale.readLess : context.locale.readMore,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomPriceBar extends StatelessWidget {
  final String totalPriceText;
  final VoidCallback onAddToCart;

  const _BottomPriceBar({
    required this.totalPriceText,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = getIt.isRegistered<AppColors>()
        ? getIt<AppColors>().textSecondaryColor
        : context.colors.onSurface.withValues(alpha: 0.6);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.locale.totalPrice,
                  style: context.text.titleSmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalPriceText,
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
                  label: Text(
                    context.locale.addToCart,
                    style: context.text.titleSmall?.copyWith(
                      color: context.colors.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProductErrorView({required this.message, required this.onRetry});

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
