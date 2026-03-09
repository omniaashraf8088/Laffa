/// Predefined feedback tags users can select when rating.
/// Separated from the Rating model to keep models clean.
class RatingTags {
  RatingTags._();

  static const List<String> positiveEn = [
    'Clean bike',
    'Smooth ride',
    'Good battery',
    'Easy to use',
    'Great value',
  ];

  static const List<String> negativeEn = [
    'Dirty bike',
    'Uncomfortable',
    'Low battery',
    'Hard to unlock',
    'Too expensive',
  ];

  static const List<String> positiveAr = [
    'دراجة نظيفة',
    'رحلة سلسة',
    'بطارية جيدة',
    'سهل الاستخدام',
    'قيمة ممتازة',
  ];

  static const List<String> negativeAr = [
    'دراجة متسخة',
    'غير مريحة',
    'بطارية منخفضة',
    'صعب الفتح',
    'مكلف جداً',
  ];

  static List<String> positive(bool isArabic) =>
      isArabic ? positiveAr : positiveEn;

  static List<String> negative(bool isArabic) =>
      isArabic ? negativeAr : negativeEn;
}
