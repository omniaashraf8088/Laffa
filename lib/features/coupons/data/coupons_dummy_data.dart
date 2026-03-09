import '../../../core/localization/app_strings_en.dart';
import 'models/coupon_model.dart';

final List<CouponItem> dummyCoupons = [
  CouponItem(
    code: 'WELCOME50',
    discount: '50%',
    expiryDate: DateTime(2026, 4, 1),
    isActive: true,
  ),
  CouponItem(
    code: 'RIDE20',
    discount: '20%',
    expiryDate: DateTime(2026, 3, 15),
    isActive: true,
  ),
  CouponItem(
    code: 'LAFFA10',
    discount: '10 ${AppStringsEn.currency}',
    expiryDate: DateTime(2026, 5, 1),
    isActive: true,
  ),
  CouponItem(
    code: 'SUMMER30',
    discount: '30%',
    expiryDate: DateTime(2026, 1, 15),
    isActive: false,
  ),
];
