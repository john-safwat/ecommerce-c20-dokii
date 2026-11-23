class CheckoutSessionResponseDto {
  final String? status;
  final CheckoutSessionDataDto? session;

  const CheckoutSessionResponseDto({this.status, this.session});

  factory CheckoutSessionResponseDto.fromJson(dynamic json) {
    final map = json is Map<String, dynamic> ? json : const <String, dynamic>{};
    return CheckoutSessionResponseDto(
      status: map['status'] as String?,
      session: map['session'] is Map<String, dynamic>
          ? CheckoutSessionDataDto.fromJson(
              map['session'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CheckoutSessionDataDto {
  final String? url;
  final String? successUrl;
  final String? cancelUrl;

  const CheckoutSessionDataDto({this.url, this.successUrl, this.cancelUrl});

  factory CheckoutSessionDataDto.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionDataDto(
      url: json['url'] as String?,
      successUrl: json['success_url'] as String?,
      cancelUrl: json['cancel_url'] as String?,
    );
  }
}
