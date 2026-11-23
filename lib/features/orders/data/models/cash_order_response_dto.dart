class CashOrderResponseDto {
  final String? status;
  final CashOrderDataDto? data;

  const CashOrderResponseDto({this.status, this.data});

  factory CashOrderResponseDto.fromJson(dynamic json) {
    final map = json is Map<String, dynamic> ? json : const <String, dynamic>{};
    return CashOrderResponseDto(
      status: map['status'] as String?,
      data: map['data'] is Map<String, dynamic>
          ? CashOrderDataDto.fromJson(map['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CashOrderDataDto {
  final String? id;
  final num? totalOrderPrice;
  final String? paymentMethodType;
  final bool? isPaid;
  final bool? isDelivered;

  const CashOrderDataDto({
    this.id,
    this.totalOrderPrice,
    this.paymentMethodType,
    this.isPaid,
    this.isDelivered,
  });

  factory CashOrderDataDto.fromJson(Map<String, dynamic> json) {
    return CashOrderDataDto(
      id: (json['_id'] ?? json['id'])?.toString(),
      totalOrderPrice: json['totalOrderPrice'] as num?,
      paymentMethodType: json['paymentMethodType'] as String?,
      isPaid: json['isPaid'] as bool?,
      isDelivered: json['isDelivered'] as bool?,
    );
  }
}
