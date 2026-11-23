import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class CartCheckoutBar extends StatelessWidget {
  final String totalPriceText;
  final VoidCallback onCheckout;

  const CartCheckoutBar({
    super.key,
    required this.totalPriceText,
    required this.onCheckout,
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
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.locale.checkOut,
                        style: context.text.titleMedium?.copyWith(
                          color: context.colors.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
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
