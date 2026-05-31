import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable glassmorphic card widget for the liquid glass UI aesthetic.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double borderRadius;
  final bool isSelected;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
    this.onLongPress,
    this.borderRadius = 16.0,
    this.isSelected = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor =
        backgroundColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.75));

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 1.0);

    final selectedColor = cs.primary.withValues(alpha: isDark ? 0.15 : 0.2);
    final selectedBorderColor = cs.primary.withValues(
      alpha: isDark ? 0.4 : 0.5,
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: padding,
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : baseColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isSelected ? selectedBorderColor : borderColor,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
