import 'package:flutter/material.dart';
import 'package:cybershelf/presentation/filter/filter_models.dart';

class FilterConditionWidget extends StatefulWidget {
  const FilterConditionWidget({
    super.key,
    required this.condition,
    required this.availableFields,
    required this.onChanged,
    required this.onDelete,
    this.showOrDivider = false,
    this.getSelectOptions,
  });

  final FilterCondition condition;
  final List<FilterField> availableFields;
  final void Function(FilterCondition) onChanged;
  final VoidCallback onDelete;
  final bool showOrDivider;
  final List<String> Function(FilterField)? getSelectOptions;

  @override
  State<FilterConditionWidget> createState() => _FilterConditionWidgetState();
}

class _FilterConditionWidgetState extends State<FilterConditionWidget> {
  late FilterField _field;
  late FilterOperator _operator;
  late String _value;
  late String _value2;

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _value2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _field = widget.condition.field;
    _operator = widget.condition.operator;
    _value = widget.condition.value?.toString() ?? '';
    _value2 = widget.condition.value2?.toString() ?? '';
    _valueController.text = _value;
    _value2Controller.text = _value2;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _value2Controller.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    final value = _valueController.text.trim();
    final value2 = _value2Controller.text.trim();

    final dynamic finalValue = _operator.requiresTextValue ||
        _operator == FilterOperator.equals ||
        _operator == FilterOperator.notEquals
        ? value
        : value.isEmpty ? null : double.tryParse(value) ?? value;

    final dynamic finalValue2 =
    value2.isEmpty ? null : double.tryParse(value2) ?? value2;

    widget.onChanged(
      FilterCondition(
        field: _field,
        operator: _operator,
        value: finalValue,
        value2: _operator == FilterOperator.between ? finalValue2 : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showOrDivider)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<FilterField>(
                initialValue: _field,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                items: widget.availableFields.map((field) {
                  return DropdownMenuItem(
                    value: field,
                    child: Text(field.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _field = value;
                      // Reset operator to the first available one for this field type
                      final operators = _getOperatorsForField(value);
                      _operator = operators.isNotEmpty ? operators.first : FilterOperator.equals;
                      _valueController.clear();
                      _value2Controller.clear();
                      _notifyChanged();
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<FilterOperator>(
                initialValue: _operator,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                items: _getOperatorsForField(_field).map((op) {
                  return DropdownMenuItem(
                    value: op,
                    child: Text(op.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _operator = value;
                      _valueController.clear();
                      _value2Controller.clear();
                      _notifyChanged();
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: _buildValueField(),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: widget.onDelete,
              color: Colors.red,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueField() {
    if (_operator.requiresTwoValues) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintText: 'Min',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _notifyChanged(),
            ),
          ),
          const SizedBox(width: 4),
          const Text('to'),
          const SizedBox(width: 4),
          Expanded(
            child: TextFormField(
              controller: _value2Controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintText: 'Max',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _notifyChanged(),
            ),
          ),
        ],
      );
    }

    if (_operator.requiresNumericValue) {
      return TextFormField(
        controller: _valueController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          hintText: 'Value',
        ),
        keyboardType: TextInputType.number,
        onChanged: (_) => _notifyChanged(),
      );
    }

    final options = widget.getSelectOptions?.call(_field) ?? [];
    if (options.isNotEmpty) {
      return DropdownButtonFormField<String>(
        initialValue: _value.isEmpty ? null : _value,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        hint: const Text('Select...'),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _value = value ?? '';
            _notifyChanged();
          });
        },
      );
    }

    return TextFormField(
      controller: _valueController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        hintText: 'Value',
      ),
      onChanged: (_) => _notifyChanged(),
    );
  }

  List<FilterOperator> _getOperatorsForField(FilterField field) {
    switch (field.fieldType) {
      case FilterFieldType.text:
        return [
          FilterOperator.contains,
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.startsWith,
          FilterOperator.endsWith,
        ];
      case FilterFieldType.select:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
        ];
      case FilterFieldType.number:
      case FilterFieldType.date:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.greaterThan,
          FilterOperator.lessThan,
          FilterOperator.between,
        ];
      case FilterFieldType.multiSelect:
        return [
          FilterOperator.contains,
          FilterOperator.equals,
          FilterOperator.notEquals,
        ];
    }
  }
}