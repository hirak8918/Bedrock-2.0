import 'package:flutter/material.dart';

import '../../../widgets/glass_card.dart';

/// Stat metric card for the 2×2 grid on the Stats screen.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;
  final Widget? extra; // e.g., progress bar

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.valueColor,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? cs.primary;
    final effectiveValueColor = valueColor ?? cs.onSurface;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: effectiveIconColor, size: 22),
            ],
          ),
          const Spacer(),

          // Value — FittedBox prevents overflow for long numbers
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: effectiveValueColor,
                height: 1.1,
              ),
            ),
          ),

          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: effectiveIconColor.withValues(alpha: 0.8),
              ),
            ),
          ],

          // Extra widget (progress bar etc.)
          if (extra != null) ...[const SizedBox(height: 8), extra!],
        ],
      ),
    );
  }
}
