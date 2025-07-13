import 'package:intl/intl.dart';

class DatetimeFormatter {
  static String formatYearMonthDay(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static String formatDayDateMonthYear(DateTime date) {
    return DateFormat("EEEE, dd MMMM yyyy").format(date);
  }

  static String formatDay(DateTime date) {
    return DateFormat("EEEE").format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat("MMMM").format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat("dd").format(date);
  }

  static String formatHourMinute(DateTime date) {
    return DateFormat("HH:mm").format(date);
  }
}
