import 'package:flutter/material.dart';
import 'package:cybershelf/domain/media_status.dart';

class StatusUtils {
  StatusUtils._();

  /// Get the display label for a status
  static String getLabel(MediaStatus status) {
    return switch (status) {
      MediaStatus.planned => 'Planned',
      MediaStatus.inProgress => 'In Progress',
      MediaStatus.completed => 'Completed',
      MediaStatus.dropped => 'Dropped',
    };
  }

  /// Get the color for a status
  static Color getColor(MediaStatus status) {
    return switch (status) {
      MediaStatus.planned => Colors.blue,
      MediaStatus.inProgress => Colors.orange,
      MediaStatus.completed => Colors.green,
      MediaStatus.dropped => Colors.red,
    };
  }

  /// Get the icon for a status
  static IconData getIcon(MediaStatus status) {
    return switch (status) {
      MediaStatus.planned => Icons.schedule,
      MediaStatus.inProgress => Icons.play_circle_outline,
      MediaStatus.completed => Icons.check_circle_outline,
      MediaStatus.dropped => Icons.block,
    };
  }

  /// Build a status chip
  static Widget buildChip(MediaStatus status, {VoidCallback? onDeleted}) {
    final color = getColor(status);
    return Chip(
      label: Text(getLabel(status)),
      backgroundColor: color.withAlpha(51),
      side: BorderSide.none,
      onDeleted: onDeleted,
    );
  }

  /// Build a compact status indicator for list tiles
  static Widget buildCompactIndicator(MediaStatus status, {double size = 12}) {
    final color = getColor(status);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          getLabel(status),
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}