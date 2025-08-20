import 'package:flutter/material.dart';
import 'package:taskflow_mini/core/extensions/buildcontext_extention.dart';
import 'package:taskflow_mini/core/theme/app_pallete.dart';
import 'package:taskflow_mini/src/tasks/domain/entities/task_priority.dart';

class PriorityChipReusable extends StatelessWidget {
  final TaskPriority value;
  final bool selected;
  final ValueChanged<bool> onChanged;
  const PriorityChipReusable({
    super.key,
    required this.value,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        value.displayName,
        style: context.textTheme.bodyMedium?.copyWith(
          color: selected ? AppPallete.greenColor : null,
        ),
      ),
      selected: selected,
      onSelected: onChanged,
    );
  }
}
