import 'package:flutter/material.dart';

/// Full-screen dot-grid background overlay — the signature Bedrock texture.
/// Now theme-aware: reads scaffold and dot colors from the current theme.
class DotGridBackground extends StatelessWidget {
  final Widget child;

  const DotGridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor = isDark ? const Color(0xFF1C1C1C) : const Color(0xFFE0E0E3);

    return Stack(
      children: [
        // Base background color
        Positioned.fill(child: ColoredBox(color: scaffoldBg)),
        // Dot grid overlay
        Positioned.fill(
          child: CustomPaint(painter: _DotGridPainter(dotColor: dotColor)),
        ),
        // Actual content
        child,
      ],
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final Color dotColor;

  _DotGridPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double spacing = 24.0;
    const double dotRadius = 0.8;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) =>
      dotColor != oldDelegate.dotColor;
}
