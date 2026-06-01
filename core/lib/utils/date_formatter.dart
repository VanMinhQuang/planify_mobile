import 'package:app_core/app_core.dart';

extension DateFormatter on DateTime {
  String toDDMMYYYY() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toDDMMMMYYYY() {
    return DateFormat('dd MMMM yyyy', 'vi').format(this);
  }

  String toDayOfWeekDDMMYYYY() {
    return DateFormat('EEEE, dd MMMM yyyy', 'vi').format(this);
  }

  String toMMdd() {
    return DateFormat('MMMM dd').format(this);
  }

  String toExactUtcIsoString() {
    return DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    ).toIso8601String();
  }
}
