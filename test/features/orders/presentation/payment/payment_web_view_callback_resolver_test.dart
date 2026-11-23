import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/features/orders/presentation/payment/payment_web_view_args.dart';

void main() {
  group('PaymentWebViewCallbackResolver', () {
    const successUrl = 'http://localhost:3000/allorders';
    const cancelUrl = 'http://localhost:3000/cart';

    test('resolves exact successUrl to success', () {
      final result = PaymentWebViewCallbackResolver.resolve(
        'http://localhost:3000/allorders',
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );
      expect(result, PaymentWebViewResult.success);
    });

    test('resolves successUrl with query params to success', () {
      final result = PaymentWebViewCallbackResolver.resolve(
        'http://localhost:3000/allorders?session_id=cs_123',
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );
      expect(result, PaymentWebViewResult.success);
    });

    test('resolves cancelUrl to cancelled', () {
      final result = PaymentWebViewCallbackResolver.resolve(
        'http://localhost:3000/cart',
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );
      expect(result, PaymentWebViewResult.cancelled);
    });

    test('resolves callback host failure path to failed', () {
      final result = PaymentWebViewCallbackResolver.resolve(
        'http://localhost:3000/payment-failed',
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );
      expect(result, PaymentWebViewResult.failed);
    });

    test(
      'returns null for Stripe checkout URLs so WebView continues loading',
      () {
        final result = PaymentWebViewCallbackResolver.resolve(
          'https://checkout.stripe.com/c/pay/cs_test_abc',
          successUrl: successUrl,
          cancelUrl: cancelUrl,
        );
        expect(result, isNull);
      },
    );
  });
}
