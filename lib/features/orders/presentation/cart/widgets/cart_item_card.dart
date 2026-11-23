import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/orders/domain/entities/cart_product_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartProductEntity item;
  final bool isPending;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isPending,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = _buildSubtitle();
    final priceText = _formatPrice(context, item.price);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CartItemImage(imageUrl: item.imageCover),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TitleAndDeleteRow(
                      title: item.title,
                      isPending: isPending,
                      onRemove: onRemove,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _MetadataLabel(text: subtitle),
                    ],
                    const SizedBox(height: 12),
                    _PriceAndStepperRow(
                      priceText: priceText,
                      count: item.count,
                      isPending: isPending,
                      onDecrement: onDecrement,
                      onIncrement: onIncrement,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[
      if (item.brandName.isNotEmpty) item.brandName,
      if (item.categoryName.isNotEmpty) item.categoryName,
    ];
    return parts.join(' | ');
  }

  String _formatPrice(BuildContext context, double price) {
    final formatted = NumberFormat('#,##0.##').format(price);
    return '${context.locale.egpCurrency} $formatted';
  }
}

class _CartItemImage extends StatelessWidget {
  final String imageUrl;

  const _CartItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 113,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.colors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isEmpty
          ? _ImageFallback(iconColor: context.colors.outline)
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  _ImageFallback(iconColor: context.colors.outline),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return ColoredBox(
                  color: context.colors.outline.withValues(alpha: 0.15),
                );
              },
            ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final Color iconColor;

  const _ImageFallback({required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.outline.withValues(alpha: 0.12),
      child: Center(
        child: Icon(Icons.image_outlined, size: 32, color: iconColor),
      ),
    );
  }
}

class _TitleAndDeleteRow extends StatelessWidget {
  final String title;
  final bool isPending;
  final VoidCallback onRemove;

  const _TitleAndDeleteRow({
    required this.title,
    required this.isPending,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: isPending ? null : onRemove,
          tooltip: context.locale.removeFromCart,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.delete_outline,
            color: context.colors.secondary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _MetadataLabel extends StatelessWidget {
  final String text;

  const _MetadataLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final textSecondary = getIt.isRegistered<AppColors>()
        ? getIt<AppColors>().textSecondaryColor
        : context.colors.onSurface.withValues(alpha: 0.6);

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodySmall?.copyWith(color: textSecondary),
    );
  }
}

class _PriceAndStepperRow extends StatelessWidget {
  final String priceText;
  final int count;
  final bool isPending;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _PriceAndStepperRow({
    required this.priceText,
    required this.count,
    required this.isPending,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            priceText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _CartQuantityStepper(
          count: count,
          isPending: isPending,
          onDecrement: onDecrement,
          onIncrement: onIncrement,
        ),
      ],
    );
  }
}

class _CartQuantityStepper extends StatelessWidget {
  final int count;
  final bool isPending;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CartQuantityStepper({
    required this.count,
    required this.isPending,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPending ? 0.6 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: isPending ? null : onDecrement,
              tooltip: context.locale.decreaseQuantity,
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.remove_circle_outline,
                color: context.colors.onPrimary,
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              child: Text(
                count.toString(),
                style: context.text.titleSmall?.copyWith(
                  color: context.colors.onPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: isPending ? null : onIncrement,
              tooltip: context.locale.increaseQuantity,
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.add_circle_outline,
                color: context.colors.onPrimary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
