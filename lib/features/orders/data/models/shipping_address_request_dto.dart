class ShippingAddressRequestDto {
  final String details;
  final String phone;
  final String city;
  final String? postalCode;

  const ShippingAddressRequestDto({
    required this.details,
    required this.phone,
    required this.city,
    this.postalCode,
  });

  Map<String, dynamic> toJson() {
    final address = <String, dynamic>{
      'details': details,
      'phone': phone,
      'city': city,
    };
    if (postalCode != null && postalCode!.trim().isNotEmpty) {
      address['postalCode'] = postalCode!.trim();
    }
    return {'shippingAddress': address};
  }
}
