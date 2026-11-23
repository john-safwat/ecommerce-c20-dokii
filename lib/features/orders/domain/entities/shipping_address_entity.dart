class ShippingAddressEntity {
  final String details;
  final String phone;
  final String city;
  final String? postalCode;

  const ShippingAddressEntity({
    required this.details,
    required this.phone,
    required this.city,
    this.postalCode,
  });
}
