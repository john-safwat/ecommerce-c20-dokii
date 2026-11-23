import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_actions.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_cubit.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_state.dart';

class HomeProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onAddToCartTap;

  const HomeProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onWishlistTap,
    this.onAddToCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        product.priceAfterDiscount > 0 &&
        product.priceAfterDiscount < product.price;
    final currentPrice = hasDiscount
        ? product.priceAfterDiscount
        : product.price;
    final starColor = getIt.isRegistered<AppColors>()
        ? getIt<AppColors>().starColor
        : context.colors.primary;

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap:
            onTap ??
            () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.productDetails, arguments: product.id),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: context.colors.outline, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImageHeader(
                imageUrl: product.image,
                onWishlistTap: onWishlistTap,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodyMedium,
                      ),
                      _PriceRow(
                        currency: context.locale.egpCurrency,
                        currentPrice: currentPrice,
                        oldPrice: hasDiscount ? product.price : null,
                      ),
                      const SizedBox(height: 4),
                      _RatingAndAddRow(
                        productId: product.id,
                        rating: product.reviews,
                        starColor: starColor,
                        onAddToCartTap: onAddToCartTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImageHeader extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onWishlistTap;

  const _ProductImageHeader({required this.imageUrl, this.onWishlistTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: context.colors.outline.withValues(alpha: 0.15),
                alignment: AlignmentDirectional.center,
                child: Icon(
                  Icons.image_outlined,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 4,
            end: 4,
            child: Material(
              color: context.colors.surface,
              shape: const CircleBorder(),
              elevation: 1,
              child: IconButton(
                onPressed: onWishlistTap,
                tooltip: context.locale.addToWishlist,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                iconSize: 18,
                icon: Icon(
                  Icons.favorite_border,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String currency;
  final double currentPrice;
  final double? oldPrice;

  const _PriceRow({
    required this.currency,
    required this.currentPrice,
    this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            '$currency ${currentPrice.toStringAsFixed(0)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (oldPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            '${oldPrice!.toStringAsFixed(0)} $currency',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelSmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: context.colors.primary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}

class _RatingAndAddRow extends StatelessWidget {
  final String productId;
  final double rating;
  final Color starColor;
  final VoidCallback? onAddToCartTap;

  const _RatingAndAddRow({
    required this.productId,
    required this.rating,
    required this.starColor,
    this.onAddToCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  '${context.locale.reviewLabel} (${rating.toStringAsFixed(1)})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.star, size: 16, color: starColor),
            ],
          ),
        ),
        _CardCartButton(productId: productId, onTapOverride: onAddToCartTap),
      ],
    );
  }
}

class _CardCartButton extends StatelessWidget {
  final String productId;
  final VoidCallback? onTapOverride;

  const _CardCartButton({required this.productId, this.onTapOverride});

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<CartCubit>()) {
      return _buildCircleButton(
        context,
        inCart: false,
        isPending: false,
        onPressed: onTapOverride,
      );
    }

    final cartCubit = getIt<CartCubit>();
    return BlocSelector<CartCubit, CartState, ({bool inCart, bool isPending})>(
      bloc: cartCubit,
      selector: (state) => (
        inCart: state.cart.containsKey(productId),
        isPending: state.isProductPending(productId),
      ),
      builder: (context, cartStatus) {
        final onPressed = cartStatus.isPending
            ? null
            : onTapOverride ??
                  () => cartCubit.doAction(
                    cartStatus.inCart
                        ? RemoveFromCart(productId)
                        : AddToCart(productId),
                  );

        return _buildCircleButton(
          context,
          inCart: cartStatus.inCart,
          isPending: cartStatus.isPending,
          onPressed: onPressed,
        );
      },
    );
  }

  Widget _buildCircleButton(
    BuildContext context, {
    required bool inCart,
    required bool isPending,
    required VoidCallback? onPressed,
  }) {
    final backgroundColor = inCart
        ? context.colors.error
        : context.colors.primary;
    final foregroundColor = inCart
        ? context.colors.onError
        : context.colors.onPrimary;

    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: inCart
            ? context.locale.removeFromCart
            : context.locale.addToCart,
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: isPending
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
            : Icon(
                inCart ? Icons.remove_shopping_cart_outlined : Icons.add,
                color: foregroundColor,
              ),
      ),
    );
  }
}
