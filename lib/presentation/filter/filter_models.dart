// Abstract models for any media type

enum FilterOperator {
  contains('Contains'),
  equals('Equals'),
  notEquals('Does Not Equal'),
  greaterThan('Greater Than'),
  lessThan('Less Than'),
  between('Between'),
  startsWith('Starts With'),
  endsWith('Ends With');

  const FilterOperator(this.label);
  final String label;

  static FilterOperator fromString(String value) {
    return FilterOperator.values.firstWhere((e) => e.name == value);
  }

  bool get requiresTwoValues => this == FilterOperator.between;
  bool get requiresTextValue =>
      this == FilterOperator.contains ||
          this == FilterOperator.startsWith ||
          this == FilterOperator.endsWith;
  bool get requiresNumericValue =>
      this == FilterOperator.greaterThan ||
          this == FilterOperator.lessThan ||
          this == FilterOperator.between;
}

/// Base class for filter fields
abstract class FilterField {
  const FilterField(this.id, this.label, this.fieldType);

  final String id;
  final String label;
  final FilterFieldType fieldType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FilterField &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum FilterFieldType {
  text,
  number,
  date,
  select,
  multiSelect,
}

/// Base class for filter condition
class FilterCondition {
  final FilterField field;
  final FilterOperator operator;
  final dynamic value;
  final dynamic value2;

  const FilterCondition({
    required this.field,
    required this.operator,
    required this.value,
    this.value2,
  });

  FilterCondition copyWith({
    FilterField? field,
    FilterOperator? operator,
    dynamic value,
    dynamic value2,
  }) {
    return FilterCondition(
      field: field ?? this.field,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      value2: value2 ?? this.value2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldId': field.id,
      'operator': operator.name,
      'value': value,
      'value2': value2,
    };
  }

  factory FilterCondition.fromJson(
      Map<String, dynamic> json,
      List<FilterField> availableFields,
      ) {
    final field = availableFields.firstWhere((f) => f.id == json['fieldId']);
    return FilterCondition(
      field: field,
      operator: FilterOperator.fromString(json['operator']),
      value: json['value'],
      value2: json['value2'],
    );
  }

  String getDisplayText() {
    final fieldLabel = field.label;
    final operatorLabel = operator.label;
    final valueText = value?.toString() ?? '';
    final value2Text = value2?.toString() ?? '';

    if (operator == FilterOperator.between) {
      return '$fieldLabel $operatorLabel $valueText and $value2Text';
    }
    return '$fieldLabel $operatorLabel "$valueText"';
  }
}

class FilterGroup {
  final List<FilterCondition> conditions;
  final bool isAnd;

  const FilterGroup({
    required this.conditions,
    this.isAnd = true,
  });

  FilterGroup copyWith({
    List<FilterCondition>? conditions,
    bool? isAnd,
  }) {
    return FilterGroup(
      conditions: conditions ?? this.conditions,
      isAnd: isAnd ?? this.isAnd,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAnd': isAnd,
      'conditions': conditions.map((c) => c.toJson()).toList(),
    };
  }

  factory FilterGroup.fromJson(
      Map<String, dynamic> json,
      List<FilterField> availableFields,
      ) {
    return FilterGroup(
      isAnd: json['isAnd'] ?? true,
      conditions: (json['conditions'] as List)
          .map((c) => FilterCondition.fromJson(c, availableFields))
          .toList(),
    );
  }

  String getDisplayText() {
    if (conditions.isEmpty) return 'Empty group';
    final conditionTexts = conditions.map((c) => c.getDisplayText()).toList();
    final joinWord = isAnd ? 'AND' : 'OR';
    return conditionTexts.join(' $joinWord ');
  }
}

class FilterState {
  final List<FilterGroup> groups;
  final bool isActive;

  const FilterState({
    this.groups = const [],
    this.isActive = false,
  });

  FilterState copyWith({
    List<FilterGroup>? groups,
    bool? isActive,
  }) {
    return FilterState(
      groups: groups ?? this.groups,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groups': groups.map((g) => g.toJson()).toList(),
      'isActive': isActive,
    };
  }

  factory FilterState.fromJson(
      Map<String, dynamic> json,
      List<FilterField> availableFields,
      ) {
    return FilterState(
      groups: (json['groups'] as List)
          .map((g) => FilterGroup.fromJson(g, availableFields))
          .toList(),
      isActive: json['isActive'] ?? false,
    );
  }

  bool get hasActiveFilters => isActive && groups.isNotEmpty &&
      groups.any((g) => g.conditions.isNotEmpty);

  int get totalConditionCount {
    return groups.fold(0, (sum, group) => sum + group.conditions.length);
  }
}

/// Interface for filter evaluators
abstract class FilterEvaluator<T> {
  bool evaluate(T item, FilterCondition condition);
  List<FilterField> get availableFields;
  List<String> getSelectOptions(FilterField field);
}