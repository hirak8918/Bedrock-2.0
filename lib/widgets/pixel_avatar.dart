import 'dart:io';
import 'package:flutter/material.dart';

/// Styled avatar with gradient backgrounds and clean geometric patterns.
/// Each index has a unique gradient + icon combo. Supports custom images.
class PixelAvatar extends StatelessWidget {
  final int index;
  final double size;
  final bool isSelected;
  final String? imagePath;

  const PixelAvatar({
    super.key,
    required this.index,
    this.size = 56,
    this.isSelected = false,
    this.imagePath,
  });

  /// 4 distinct gradient pairs — vibrant and modern.
  static const List<List<Color>> _gradients = [
    [Color(0xFF06B6D4), Color(0xFF3B82F6)], // Cyan → Blue
    [Color(0xFFF97316), Color(0xFFEF4444)], // Orange → Red
    [Color(0xFF8B5CF6), Color(0xFFEC4899)], // Purple → Pink
    [Color(0xFF10B981), Color(0xFF059669)], // Emerald → Teal
  ];

  /// Unique icon for each avatar — simple, elegant.
  static const List<IconData> _icons = [
    Icons.bolt_rounded,
    Icons.local_fire_department_rounded,
    Icons.auto_awesome_rounded,
    Icons.eco_rounded,
  ];

  /// Labels for display (e.g., in selection grids).
  static const List<String> _labels = ['Bolt', 'Flame', 'Star', 'Leaf'];

  static int get count => _gradients.length;
  static String label(int i) => _labels[i.clamp(0, _labels.length - 1)];

  @override
  Widget build(BuildContext context) {
    // If a custom image path is set, show that
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.22),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.5,
                )
              : null,
          image: DecorationImage(
            image: FileImage(File(imagePath!)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final safeIndex = index.clamp(0, _gradients.length - 1);
    final gradient = _gradients[safeIndex];
    final icon = _icons[safeIndex];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.5,
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: Colors.white.withValues(alpha: 0.9),
        size: size * 0.45,
      ),
    );
  }
}
