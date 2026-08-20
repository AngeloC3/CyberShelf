import 'package:flutter/material.dart';
import 'package:cybershelf/presentation/filter/filter_models.dart';
import 'package:cybershelf/presentation/filter/filter_group_widget.dart';

class FilterPage<T> extends StatefulWidget {
  const FilterPage({
    super.key,
    required this.initialFilterState,
    required this.availableFields,
    required this.onApply,
    this.getSelectOptions,
  });

  final FilterState initialFilterState;
  final List<FilterField> availableFields;
  final void Function(FilterState) onApply;
  final List<String> Function(FilterField)? getSelectOptions;

  @override
  State<FilterPage<T>> createState() => _FilterPageState<T>();
}

class _FilterPageState<T> extends State<FilterPage<T>> {
  late List<FilterGroup> _groups;

  @override
  void initState() {
    super.initState();
    _groups = widget.initialFilterState.groups.map((g) => g.copyWith()).toList();
    if (_groups.isEmpty) {
      _groups.add(const FilterGroup(conditions: []));
    }
  }

  void _addGroup() {
    setState(() {
      _groups.add(const FilterGroup(conditions: []));
    });
  }

  void _removeGroup(int index) {
    setState(() {
      _groups.removeAt(index);
    });
  }

  void _updateGroup(int index, FilterGroup group) {
    setState(() {
      _groups[index] = group;
    });
  }

  void _clearAll() {
    setState(() {
      _groups = [const FilterGroup(conditions: [])];
    });
  }

  void _applyFilters() {
    final validGroups = _groups.where((g) => g.conditions.isNotEmpty).toList();
    final filterState = FilterState(
      groups: validGroups,
      isActive: validGroups.isNotEmpty,
    );
    widget.onApply(filterState);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _groups = [const FilterGroup(conditions: [])];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        actions: [
          TextButton(
            onPressed: _applyFilters,
            child: const Text('Apply'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filter summary
          if (_groups.any((g) => g.conditions.isNotEmpty))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(26),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_groups.fold(0, (sum, g) => sum + g.conditions.length)} active filters',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
          // Groups
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                final isOnlyGroup = _groups.length == 1;
                final showOrDivider = index > 0;

                return Column(
                  children: [
                    if (showOrDivider)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
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
                    FilterGroupWidget(
                      key: ValueKey(index),
                      group: group,
                      availableFields: widget.availableFields,
                      onChanged: (updatedGroup) => _updateGroup(index, updatedGroup),
                      onDelete: isOnlyGroup ? null : () => _removeGroup(index),
                      getSelectOptions: widget.getSelectOptions,
                    ),
                  ],
                );
              },
            ),
          ),
          // Bottom actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addGroup,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Group'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear All'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}