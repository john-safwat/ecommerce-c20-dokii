enum PaymentWebViewResult { success, cancelled, failed }

class PaymentWebViewArgs {
  final String checkoutUrl;
  final String successUrl;
  final String cancelUrl;

  const PaymentWebViewArgs({
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
  });
}

class PaymentWebViewCallbackResolver {
  const PaymentWebViewCallbackResolver._();

  static PaymentWebViewResult? resolve(
    String url, {
    required String successUrl,
    required String cancelUrl,
  }) {
    final normalizedUrl = url.trim().toLowerCase();
    final normalizedSuccess = successUrl.trim().toLowerCase();
    final normalizedCancel = cancelUrl.trim().toLowerCase();

    if (normalizedUrl.isEmpty) return null;

    if (normalizedSuccess.isNotEmpty &&
        normalizedUrl.startsWith(normalizedSuccess)) {
      return PaymentWebViewResult.success;
    }

    if (normalizedCancel.isNotEmpty &&
        normalizedUrl.startsWith(normalizedCancel)) {
      return PaymentWebViewResult.cancelled;
    }

    final currentUri = Uri.tryParse(normalizedUrl);
    final successUri = Uri.tryParse(normalizedSuccess);
    final cancelUri = Uri.tryParse(normalizedCancel);

    if (currentUri == null) return null;

    final callbackOrigin = _originOf(successUri) ?? _originOf(cancelUri);
    final currentOrigin = _originOf(currentUri);

    if (callbackOrigin != null && currentOrigin == callbackOrigin) {
      final path = currentUri.path.toLowerCase();
      if (path.contains('cancel') || path.contains('cart')) {
        return PaymentWebViewResult.cancelled;
      }
      if (path.contains('fail') || path.contains('error')) {
        return PaymentWebViewResult.failed;
      }
      return PaymentWebViewResult.success;
    }

    return null;
  }

  static String? _originOf(Uri? uri) {
    if (uri == null || uri.host.isEmpty) return null;
    final portSuffix = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$portSuffix';
  }
}
