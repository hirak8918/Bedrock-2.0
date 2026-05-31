import 'package:flutter/material.dart';

/// Square FAB with "+" icon — matches the design's sharp-cornered button.
/// Uses theme primary color for dynamic color seed support.
class BedrockFab extends StatelessWidget {
  final VoidCallback onPressed;

  const BedrockFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }
}
