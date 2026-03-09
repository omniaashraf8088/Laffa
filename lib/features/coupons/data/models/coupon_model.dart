class CouponItem {
  final String code;
  final String discount;
  final DateTime expiryDate;
  final bool isActive;

  const CouponItem({
    required this.code,
    required this.discount,
    required this.expiryDate,
    required this.isActive,
  });

  CouponItem copyWith({
    String? code,
    String? discount,
    DateTime? expiryDate,
    bool? isActive,
  }) {
    return CouponItem(
      code: code ?? this.code,
      discount: discount ?? this.discount,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
