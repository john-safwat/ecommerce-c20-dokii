class CheckoutSessionEntity {
  final String url;
  final String successUrl;
  final String cancelUrl;

  const CheckoutSessionEntity({
    required this.url,
    required this.successUrl,
    required this.cancelUrl,
  });
}
