import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/common_ui/route_logo.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class HomeHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onCartTap;

  const HomeHeader({super.key, this.onSearchSubmitted, this.onCartTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RouteLogo(height: 24, color: context.colors.primary),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: onSearchSubmitted,
                    style: context.text.bodyMedium,
                    decoration: InputDecoration(
                      hintText: context.locale.searchHint,
                      hintStyle: context.text.labelMedium,
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.colors.primary,
                      ),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: context.colors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: context.colors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onCartTap,
                tooltip: context.locale.cart,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: context.colors.primary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
