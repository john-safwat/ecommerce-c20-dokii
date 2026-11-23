import 'package:route_ecommerce/features/orders/domain/entities/checkout_session_entity.dart';
import 'package:route_ecommerce/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:route_ecommerce/features/orders/presentation/payment/payment_web_view_args.dart';

enum CheckoutPaymentMethod { creditCard, cashOnDelivery }

sealed class CartActions {}

class GetCartProducts extends CartActions {}

class AddToCart extends CartActions {
  final String productId;
  final int quantity;

  AddToCart(this.productId, {this.quantity = 1});
}

class RemoveFromCart extends CartActions {
  final String productId;

  RemoveFromCart(this.productId);
}

class UpdateCart extends CartActions {
  final String productId;
  final int count;

  UpdateCart(this.productId, this.count);
}

class CheckoutCashOrder extends CartActions {
  final ShippingAddressEntity shippingAddress;

  CheckoutCashOrder(this.shippingAddress);
}

class CheckoutCreditCard extends CartActions {
  final ShippingAddressEntity shippingAddress;

  CheckoutCreditCard(this.shippingAddress);
}

class HandlePaymentCallback extends CartActions {
  final PaymentWebViewResult result;

  HandlePaymentCallback(this.result);
}

sealed class CartNavigationAction {
  const CartNavigationAction();
}

class ShowCartToast extends CartNavigationAction {
  final String message;
  final bool isError;

  const ShowCartToast(this.message, {this.isError = false});
}

class ShowCashOrderSuccessToast extends CartNavigationAction {
  const ShowCashOrderSuccessToast();
}

class ShowCheckoutMissingCartIdToast extends CartNavigationAction {
  const ShowCheckoutMissingCartIdToast();
}

class ShowPaymentResultToast extends CartNavigationAction {
  final PaymentWebViewResult result;

  const ShowPaymentResultToast(this.result);
}

class DismissCheckoutSheet extends CartNavigationAction {
  const DismissCheckoutSheet();
}

class NavigateToPaymentWebView extends CartNavigationAction {
  final CheckoutSessionEntity session;

  const NavigateToPaymentWebView(this.session);
}
