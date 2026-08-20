import 'package:flutter/material.dart';
import 'package:cybershelf/presentation/filter/filter_models.dart';
import 'package:cybershelf/presentation/filter/filter_condition_widget.dart';

class FilterGroupWidget extends StatefulWidget {
  const FilterGroupWidget({
    super.key,
    required this.group,
    required this.availableFields,
    required this.onChanged,
    this.onDelete,
    this.getSelectOptions,
  });

  final FilterGroup group;
  final List<FilterField> availableFields;
  final void Function(FilterGroup) onChanged;
  final VoidCallback? onDelete;
  final List<String> Function(FilterField)? getSelectOptions;

  @override
  State<FilterGroupWidget> createState() => _FilterGroupWidgetState();
}

class _FilterGroupWidgetState extends State<FilterGroupWidget> {
  late List<FilterCondition> _conditions;
  late bool _isAnd;

  @override
  void initState() {
    super.initState();
    _conditions = widget.group.conditions.map((c) => c.copyWith()).toList();
    _isAnd = widget.group.isAnd;
  }

  void _notifyChanged() {
    widget.onChanged(
      FilterGroup(
        conditions: _conditions,
        isAnd: _isAnd,
      ),
    );
  }

  void _addCondition() {
    setState(() {
      _conditions.add(
        FilterCondition(
          field: widget.availableFields.first,
          operator: FilterOperator.contains,
          value: '',
        ),
      );
      _notifyChanged();
    });
  }

  void _removeCondition(int index) {
    setState(() {
      _conditions.removeAt(index);
      _notifyChanged();
    });
  }

  void _updateCondition(int index, FilterCondition condition) {
    setState(() {
      _conditions[index] = condition;
      _notifyChanged();
    });
  }

  void _toggleAndOr() {
    setState(() {
      _isAnd = !_isAnd;
      _notifyChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Group',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('AND'),
                        selected: _isAnd,
                        onSelected: (_) => _toggleAndOr(),
                        selectedColor: Colors.blue.withAlpha(51),
                        labelStyle: TextStyle(
                          color: _isAnd ? Colors.blue : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ChoiceChip(
                        label: const Text('OR'),
                        selected: !_isAnd,
                        onSelected: (_) => _toggleAndOr(),
                        selectedColor: Colors.blue.withAlpha(51),
                        labelStyle: TextStyle(
                          color: !_isAnd ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: widget.onDelete,
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Conditions
            if (_conditions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No conditions. Add one below.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                children: _conditions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final condition = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FilterConditionWidget(
                      condition: condition,
                      availableFields: widget.availableFields,
                      onChanged: (updated) => _updateCondition(index, updated),
                      onDelete: () => _removeCondition(index),
                      showOrDivider: index > 0 && !_isAnd,
                      getSelectOptions: widget.getSelectOptions,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 8),

            // Add button
            OutlinedButton.icon(
              onPressed: _addCondition,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Condition'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}