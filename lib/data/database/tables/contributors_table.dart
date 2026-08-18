import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/tables/people_table.dart';
import 'package:cybershelf/data/database/tables/companies_table.dart';

class Contributors extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get personId => integer().nullable().references(
    People,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get companyId => integer().nullable().references(
    Companies,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  List<String> get customConstraints => [
    'CHECK ('
        '(person_id IS NOT NULL AND company_id IS NULL) OR '
        '(person_id IS NULL AND company_id IS NOT NULL)'
        ')',
  ];
}