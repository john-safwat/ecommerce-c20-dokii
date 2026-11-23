import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/common_ui/app_text_field.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/core/utils/validators.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_actions.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_cubit.dart';
import 'package:route_ecommerce/features/orders/presentation/cart/cart_state.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({super.key});

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _validator = Validator();

  CheckoutPaymentMethod _selectedMethod = CheckoutPaymentMethod.creditCard;

  @override
  void dispose() {
    _detailsController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final address = ShippingAddressEntity(
      details: _detailsController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalCodeController.text.trim().isEmpty
          ? null
          : _postalCodeController.text.trim(),
    );

    final cubit = context.read<CartCubit>();
    switch (_selectedMethod) {
      case CheckoutPaymentMethod.creditCard:
        cubit.doAction(CheckoutCreditCard(address));
      case CheckoutPaymentMethod.cashOnDelivery:
        cubit.doAction(CheckoutCashOrder(address));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20 + bottomInset),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BlocSelector<CartCubit, CartState, bool>(
              selector: (state) => state.isCheckingOut,
              builder: (context, isCheckingOut) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SheetDragHandle(color: context.colors.outline),
                    const SizedBox(height: 16),
                    Text(
                      context.locale.selectPaymentMethod,
                      style: context.text.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _PaymentMethodOption(
                      title: context.locale.creditCard,
                      subtitle: context.locale.creditCardSubtitle,
                      icon: Icons.credit_card,
                      isSelected:
                          _selectedMethod == CheckoutPaymentMethod.creditCard,
                      enabled: !isCheckingOut,
                      onTap: () => setState(
                        () =>
                            _selectedMethod = CheckoutPaymentMethod.creditCard,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentMethodOption(
                      title: context.locale.cashOnDelivery,
                      subtitle: context.locale.cashOnDeliverySubtitle,
                      icon: Icons.payments_outlined,
                      isSelected:
                          _selectedMethod ==
                          CheckoutPaymentMethod.cashOnDelivery,
                      enabled: !isCheckingOut,
                      onTap: () => setState(
                        () => _selectedMethod =
                            CheckoutPaymentMethod.cashOnDelivery,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _ShippingAddressFields(
                      detailsController: _detailsController,
                      phoneController: _phoneController,
                      cityController: _cityController,
                      postalCodeController: _postalCodeController,
                      validator: _validator,
                      showPostalCode:
                          _selectedMethod ==
                          CheckoutPaymentMethod.cashOnDelivery,
                      enabled: !isCheckingOut,
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: _selectedMethod == CheckoutPaymentMethod.creditCard
                          ? context.locale.proceedToPayment
                          : context.locale.placeOrder,
                      height: 52,
                      isLoading: isCheckingOut,
                      isEnabled: !isCheckingOut,
                      onPressed: _onSubmit,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  final Color color;

  const _SheetDragHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _PaymentMethodOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _PaymentMethodOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? context.colors.primary
        : context.colors.outline;
    final backgroundColor = isSelected
        ? context.colors.primary.withValues(alpha: 0.08)
        : context.colors.surface;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsetsDirectional.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? context.colors.primary
                    : context.colors.secondary,
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: context.text.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? context.colors.primary
                    : context.colors.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShippingAddressFields extends StatelessWidget {
  final TextEditingController detailsController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final Validator validator;
  final bool showPostalCode;
  final bool enabled;

  const _ShippingAddressFields({
    required this.detailsController,
    required this.phoneController,
    required this.cityController,
    required this.postalCodeController,
    required this.validator,
    required this.showPostalCode,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = context.colors.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.locale.shippingAddress,
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: context.locale.addressDetails,
          hintText: context.locale.enterAddressDetails,
          controller: detailsController,
          labelColor: labelColor,
          enabled: enabled,
          validator: (value) =>
              validator.addressDetailsValidation(value, context.locale),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: context.locale.mobileNumber,
          hintText: context.locale.enterYourMobileNo,
          controller: phoneController,
          labelColor: labelColor,
          keyboardType: TextInputType.phone,
          enabled: enabled,
          validator: (value) =>
              validator.phoneValidation(value, context.locale),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: context.locale.city,
          hintText: context.locale.enterCity,
          controller: cityController,
          labelColor: labelColor,
          textInputAction: showPostalCode
              ? TextInputAction.next
              : TextInputAction.done,
          enabled: enabled,
          validator: (value) => validator.cityValidation(value, context.locale),
        ),
        if (showPostalCode) ...[
          const SizedBox(height: 12),
          AppTextField(
            label: context.locale.postalCode,
            hintText: context.locale.enterPostalCode,
            controller: postalCodeController,
            labelColor: labelColor,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            enabled: enabled,
          ),
        ],
      ],
    );
  }
}
