// ترمي اكسبشن في حال حصول خطأ في الادخال
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension NullableStringExtension on String? {
  String? getValueOrFormattedDefault() {
    return this ?? "N/A";
  }
}
