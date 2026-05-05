import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date, {String locale = 'de'}) {
    return DateFormat('dd.MM.yyyy', locale).format(date);
  }

  static String formatDateTime(DateTime dateTime, {String locale = 'de'}) {
    return DateFormat('dd.MM.yyyy HH:mm', locale).format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String getAge(DateTime birthDate) {
    final now = DateTime.now();
    final diff = now.difference(birthDate);
    final years = (diff.inDays / 365).floor();
    final months = ((diff.inDays % 365) / 30).floor();
    if (years > 0) {
      return months > 0 ? '$years J. $months Mo.' : '$years Jahr${years > 1 ? "e" : ""}';
    }
    if (months > 0) return '$months Monat${months > 1 ? "e" : ""}';
    return '${diff.inDays} Tage';
  }

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Gerade eben';
    if (diff.inMinutes < 60) return 'vor ${diff.inMinutes} Min.';
    if (diff.inHours < 24) return 'vor ${diff.inHours} Std.';
    if (diff.inDays < 7) return 'vor ${diff.inDays} Tag${diff.inDays > 1 ? "en" : ""}';
    return formatDate(dateTime);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
