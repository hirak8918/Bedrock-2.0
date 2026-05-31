import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Color-coded category tag chip (WORK, URGENT, CREATIVE).
class CategoryTag extends StatelessWidget {
  final String label;

  const CategoryTag({super.key, required this.label});

  Color _color(BuildContext context) {
    switch (label.toUpperCase()) {
      case 'WORK':
        return AppColors.tagWork;
      case 'URGENT':
        return AppColors.tagUrgent;
      case 'CREATIVE':
        return AppColors.tagCreative;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: color,
        ),
      ),
    );
  }
}
