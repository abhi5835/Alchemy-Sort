/// Normalizes a DateTime into a strict yyyy-MM-dd daily date key.
String getDailyDateKey(DateTime date) {
  final localDate = date.toLocal();
  final year = localDate.year.toString().padLeft(4, '0');
  final month = localDate.month.toString().padLeft(2, '0');
  final day = localDate.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
