import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

/// Shared primary/surface CTA button with built-in loading and disabled states.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 64,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.text;
    final effectiveBg = backgroundColor ?? colors.surface;
    final effectiveFg = foregroundColor ?? colors.primary;
    final canTap = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: canTap ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          disabledBackgroundColor: effectiveBg.withValues(alpha: 0.7),
          foregroundColor: effectiveFg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: effectiveFg,
                ),
              )
            : Text(
                label,
                style: textTheme.titleLarge?.copyWith(
                  color: effectiveFg,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
