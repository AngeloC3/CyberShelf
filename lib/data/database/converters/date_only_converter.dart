import 'package:drift/drift.dart';

import '../../../domain/date_only.dart';

class DateOnlyConverter extends TypeConverter<DateOnly, String> {
  const DateOnlyConverter();

  @override
  DateOnly fromSql(String fromDb) {
    return DateOnly.fromString(fromDb);
  }

  @override
  String toSql(DateOnly value) {
    return value.toString();
  }
}