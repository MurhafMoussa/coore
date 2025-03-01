import 'package:intl/intl.dart';

/// Top-level [DateFormat] constants used in the [DateTime] extensions.
final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
final DateFormat _dayFormat = DateFormat('dd');
final DateFormat _monthDayFormat = DateFormat('MMM dd');
final DateFormat _fullDateFormat = DateFormat('EEE MMM dd, yyyy');
final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
final DateFormat _hourMinuteFormat = DateFormat('hh:mm');
final DateFormat _shortApiDateFormat = DateFormat('yy.MM.dd');

/// Extension methods on [DateTime] to simplify date formatting and calculations.
extension DateTimeX on DateTime {
  /// Formats the [DateTime] as 'MMMM yyyy'.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.formatMonthYear()); // Output: August 2023
  /// ```
  String formatMonthYear() => _monthYearFormat.format(this);

  /// Formats the [DateTime] as 'dd'.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.formatDay()); // Output: 29
  /// ```
  String formatDay() => _dayFormat.format(this);

  /// Formats the [DateTime] as 'MMM dd'.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.formatMonthDay()); // Output: Aug 29
  /// ```
  String formatMonthDay() => _monthDayFormat.format(this);

  /// Formats the [DateTime] as 'EEE MMM dd, yyyy'.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.formatFullDate()); // Output: Tue Aug 29, 2023
  /// ```
  String formatFullDate() => _fullDateFormat.format(this);

  /// Formats the [DateTime] for API usage.
  ///
  /// If the date is more than one day older than the current local time,
  /// returns a string in 'yyyy-MM-dd' format; otherwise, returns the time
  /// in 'hh:mm' format.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.formatApiDate());
  /// ```
  String formatApiDate() {
    final now = DateTime.now().toLocal();
    final difference = now.difference(this);
    if (difference.inDays > 1) {
      return _apiDateFormat.format(this);
    }
    return _hourMinuteFormat.format(this);
  }

  /// Formats the [DateTime] as 'yy.MM.dd'.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.formatShortApiDate()); // Output: 23.08.29
  /// ```
  String formatShortApiDate() => _shortApiDateFormat.format(this);

  /// Returns the first day of the month for this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 15);
  /// print(date.firstDayOfMonth); // Output: 2023-08-01 00:00:00.000
  /// ```
  DateTime get firstDayOfMonth => DateTime(year, month);

  /// Returns the last day of the month for this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 15);
  /// print(date.lastDayOfMonth); // Output: 2023-08-31 00:00:00.000
  /// ```
  DateTime get lastDayOfMonth {
    final nextMonth =
        (month < 12) ? DateTime(year, month + 1) : DateTime(year + 1, 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  /// Returns `true` if this [DateTime] is the first day of its month.
  bool get isFirstDayOfMonth => _isSameDay(this, firstDayOfMonth);

  /// Returns `true` if this [DateTime] is the last day of its month.
  bool get isLastDayOfMonth => _isSameDay(this, lastDayOfMonth);

  /// Returns the first day of the week for this [DateTime] (using UTC noon as a reference).
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.firstDayOfWeek); // Output: 2023-08-27 12:00:00.000Z
  /// ```
  DateTime get firstDayOfWeek {
    final adjustedDay = DateTime.utc(year, month, day, 12);
    final daysToSubtract = adjustedDay.weekday % 7;
    return adjustedDay.subtract(Duration(days: daysToSubtract));
  }

  /// Returns the last day of the week for this [DateTime] (using UTC noon as a reference).
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.lastDayOfWeek); // Output: 2023-09-02 12:00:00.000Z
  /// ```
  DateTime get lastDayOfWeek {
    final adjustedDay = DateTime.utc(year, month, day, 12);
    final daysToAdd = 7 - (adjustedDay.weekday % 7);
    return adjustedDay.add(Duration(days: daysToAdd));
  }

  /// Returns an [Iterable] of [DateTime] objects between this date and [end].
  ///
  /// Example:
  /// ```dart
  /// DateTime start = DateTime(2023, 8, 29);
  /// DateTime end = DateTime(2023, 9, 2);
  /// for (final day in start.daysUntil(end)) {
  ///   print(day);
  /// }
  /// ```
  Iterable<DateTime> daysUntil(DateTime end) sync* {
    var current = this;
    var offset = timeZoneOffset;
    while (current.isBefore(end)) {
      yield current;
      current = current.add(const Duration(days: 1));
      final diff = current.timeZoneOffset - offset;
      if (diff.inSeconds != 0) {
        offset = current.timeZoneOffset;
        current = current.subtract(Duration(seconds: diff.inSeconds));
      }
    }
  }

  /// Checks if this [DateTime] and [other] are in the same week.
  ///
  /// Example:
  /// ```dart
  /// DateTime a = DateTime(2023, 8, 29);
  /// DateTime b = DateTime(2023, 9, 1);
  /// print(a.isSameWeek(b)); // Output: true
  /// ```
  bool isSameWeek(DateTime other) {
    final firstDate = DateTime.utc(year, month, day);
    final secondDate = DateTime.utc(other.year, other.month, other.day);
    final daysDifference = firstDate.difference(secondDate).inDays;
    if (daysDifference.abs() >= 7) return false;
    final earlier = firstDate.isBefore(secondDate) ? firstDate : secondDate;
    final later = firstDate.isAfter(secondDate) ? firstDate : secondDate;
    return later.weekday % 7 - earlier.weekday % 7 >= 0;
  }

  /// Returns the first day of the previous month relative to this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 15);
  /// print(date.previousMonth); // Output: 2023-07-01 00:00:00.000
  /// ```
  DateTime get previousMonth {
    final y = (month == 1) ? year - 1 : year;
    final m = (month == 1) ? 12 : month - 1;
    return DateTime(y, m);
  }

  /// Returns the first day of the next month relative to this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 15);
  /// print(date.nextMonth); // Output: 2023-09-01 00:00:00.000
  /// ```
  DateTime get nextMonth {
    final y = (month == 12) ? year + 1 : year;
    final m = (month == 12) ? 1 : month + 1;
    return DateTime(y, m);
  }

  /// Returns the same day in the previous week relative to this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.previousWeek); // Output: 2023-08-22 00:00:00.000
  /// ```
  DateTime get previousWeek => subtract(const Duration(days: 7));

  /// Returns the same day in the next week relative to this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.nextWeek); // Output: 2023-09-05 00:00:00.000
  /// ```
  DateTime get nextWeek => add(const Duration(days: 7));

  /// Returns the day after this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// print(date.nextDay); // Output: 2023-08-30 00:00:00.000
  /// ```
  DateTime get nextDay => add(const Duration(days: 1));

  /// Returns a list of [DateTime] objects representing all days in the week of this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2023, 8, 29);
  /// List<DateTime> days = date.daysInWeek;
  /// print(days); // Output: [2023-08-27, 2023-08-28, ..., 2023-09-02]
  /// ```
  List<DateTime> get daysInWeek {
    final start = firstDayOfWeek;
    final end = lastDayOfWeek;
    return start
        .daysUntil(end)
        .map((day) => DateTime(day.year, day.month, day.day))
        .toList();
  }

  /// Checks if this [DateTime] is an extra day relative to the month of [currentMonth].
  ///
  /// An "extra" day is one that falls outside the current month.
  ///
  /// Example:
  /// ```dart
  /// DateTime day = DateTime(2023, 7, 31);
  /// DateTime current = DateTime(2023, 8, 1);
  /// print(day.isExtraDay(current)); // Output: true
  /// ```
  bool isExtraDay(DateTime currentMonth) {
    return month < currentMonth.month || month > currentMonth.month;
  }

  /// Checks if this DateTime is today (local date).
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if this DateTime is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Checks if this DateTime is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns the ISO-8601 week number for this [DateTime].
  int get weekOfYear {
    // Adjust to nearest Thursday: current date + 4 - current weekday
    final adjusted = add(Duration(days: 4 - (weekday % 7)));
    final firstJan = DateTime(adjusted.year, 1, 1);
    return ((adjusted.difference(firstJan).inDays) / 7).floor() + 1;
  }

  /// Returns the quarter of the year (1-4).
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// Returns the first day of the quarter.
  DateTime get firstDayOfQuarter => DateTime(year, ((quarter - 1) * 3) + 1, 1);

  /// Returns the last day of the quarter.
  DateTime get lastDayOfQuarter {
    final nextQuarterMonth = (quarter * 3) + 1;
    final nextQuarterYear = nextQuarterMonth > 12 ? year + 1 : year;
    final adjustedMonth =
        nextQuarterMonth > 12 ? nextQuarterMonth - 12 : nextQuarterMonth;
    return DateTime(
      nextQuarterYear,
      adjustedMonth,
      1,
    ).subtract(const Duration(days: 1));
  }

  /// Returns the day number in the year.
  int get dayOfYear => difference(DateTime(year, 1, 1)).inDays + 1;

  /// Checks if the date falls on a weekend.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Checks if the date is a weekday.
  bool get isWeekday => !isWeekend;

  /// Determines if the year is a leap year.
  bool get isLeapYear =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// Computes the ISO week number.
  /// (Algorithm inspired by ISO week date rules; see also Wikipedia.)
  int get weekNumber {
    // Move date to Thursday in current week: ISO weeks start on Monday, and Thursday is the week’s pivot.
    final adjusted = add(Duration(days: 3 - ((weekday + 6) % 7)));
    // Find the first Thursday of the year.
    DateTime firstThursday = DateTime(adjusted.year, 1, 1);
    while (firstThursday.weekday != DateTime.thursday) {
      firstThursday = firstThursday.add(const Duration(days: 1));
    }
    // Week number is the number of weeks between the two Thursdays plus one.
    return 1 + ((adjusted.difference(firstThursday).inDays) ~/ 7);
  }

  /// Adds [months] to this date, adjusting the day if necessary.
  DateTime addMonths(int months) {
    int newMonth = month + months;
    int newYear = year + ((newMonth - 1) ~/ 12);
    newMonth = ((newMonth - 1) % 12) + 1;
    // Get the maximum number of days in the new month.
    final lastDay =
        DateTime(
          newYear,
          newMonth + 1,
          1,
        ).subtract(const Duration(days: 1)).day;
    final newDay = day > lastDay ? lastDay : day;
    return DateTime(
      newYear,
      newMonth,
      newDay,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Returns a human-friendly relative time string.
  String formatRelative() {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inSeconds.abs() < 60) {
      return 'just now';
    } else if (diff.inMinutes.abs() < 60) {
      final minutes = diff.inMinutes.abs();
      return diff.isNegative ? 'in $minutes minutes' : '$minutes minutes ago';
    } else if (diff.inHours.abs() < 24) {
      final hours = diff.inHours.abs();
      return diff.isNegative ? 'in $hours hours' : '$hours hours ago';
    } else if (diff.inDays.abs() == 1) {
      return diff.isNegative ? 'tomorrow' : 'yesterday';
    } else if (diff.inDays.abs() < 7) {
      final days = diff.inDays.abs();
      return diff.isNegative ? 'in $days days' : '$days days ago';
    }
    return formatFullDate(); // Fallback to a full date format.
  }

  /// Adds [years] to this date.
  DateTime addYears(int years) => DateTime(
    year + years,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );

  /// Returns a new DateTime at the start of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a new DateTime at the end of the day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns the next business day (skips Saturday and Sunday).
  DateTime get nextBusinessDay {
    var next = add(const Duration(days: 1));
    while (next.weekday == DateTime.saturday ||
        next.weekday == DateTime.sunday) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  /// Returns the previous business day (skips Saturday and Sunday).
  DateTime get previousBusinessDay {
    var prev = subtract(const Duration(days: 1));
    while (prev.weekday == DateTime.saturday ||
        prev.weekday == DateTime.sunday) {
      prev = prev.subtract(const Duration(days: 1));
    }
    return prev;
  }

  /// Adds [businessDays] to the current date, skipping weekends.
  DateTime addBusinessDays(int businessDays) {
    DateTime date = this;
    int daysAdded = 0;
    while (daysAdded < businessDays) {
      date = date.add(const Duration(days: 1));
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        daysAdded++;
      }
    }
    return date;
  }
}

/// Private helper to check if two dates represent the same calendar day.
bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
