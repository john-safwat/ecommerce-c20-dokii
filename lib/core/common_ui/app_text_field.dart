import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/core/utils/numbers_extension.dart';

/// Shared labeled text form field with optional password visibility toggle.
class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final Color? labelColor;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.enabled = true,
    this.labelColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.titleMedium?.copyWith(
            color: widget.labelColor ?? colors.onPrimary,
          ),
        ),
        12.verticalSpace,
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          onFieldSubmitted: widget.onFieldSubmitted,
          enabled: widget.enabled,
          style: textTheme.bodyLarge?.copyWith(color: colors.onSurface),
          decoration: _buildDecoration(context, colors, textTheme),
        ),
      ],
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.error, width: 1.5),
    );

    return InputDecoration(
      filled: true,
      fillColor: colors.surface,
      hintText: widget.hintText,
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: colors.onSurface.withValues(alpha: 0.55),
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: colors.onPrimary),
      errorMaxLines: 2,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      suffixIcon: widget.isPassword
          ? _buildVisibilityToggle(context, colors)
          : null,
    );
  }

  Widget _buildVisibilityToggle(BuildContext context, ColorScheme colors) {
    final locale = context.locale;
    return IconButton(
      onPressed: () => setState(() => _obscureText = !_obscureText),
      tooltip: _obscureText ? locale.showPassword : locale.hidePassword,
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: colors.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
