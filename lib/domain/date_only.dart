class DateOnly implements Comparable<DateOnly> {
  final int year;
  final int month;
  final int day;

  const DateOnly._({
    required this.year,
    required this.month,
    required this.day,
  });

  factory DateOnly({
    required int year,
    required int month,
    required int day,
  }) {
    final date = DateTime(year, month, day);

    if (date.year != year ||
        date.month != month ||
        date.day != day) {
      throw ArgumentError(
        'Invalid calendar date: $year-$month-$day',
      );
    }

    return DateOnly._(
      year: year,
      month: month,
      day: day,
    );
  }

  factory DateOnly.fromDateTime(DateTime dateTime) {
    return DateOnly(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
    );
  }

  factory DateOnly.today() {
    return DateOnly.fromDateTime(DateTime.now());
  }

  factory DateOnly.fromString(String value) {
    final parts = value.split('-');

    if (parts.length != 3) {
      throw FormatException(
        'Invalid DateOnly value: $value',
      );
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      throw FormatException(
        'Invalid DateOnly value: $value',
      );
    }

    return DateOnly(
      year: year,
      month: month,
      day: day,
    );
  }

  @override
  int compareTo(DateOnly other) {
    if (year != other.year) {
      return year.compareTo(other.year);
    }

    if (month != other.month) {
      return month.compareTo(other.month);
    }

    return day.compareTo(other.day);
  }

  bool isBefore(DateOnly other) => compareTo(other) < 0;

  bool isAfter(DateOnly other) => compareTo(other) > 0;

  bool isSameDay(DateOnly other) => compareTo(other) == 0;

  @override
  bool operator ==(Object other) {
    return other is DateOnly &&
        year == other.year &&
        month == other.month &&
        day == other.day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }
}