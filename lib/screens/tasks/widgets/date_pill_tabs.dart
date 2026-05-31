import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Horizontal date pill tabs: YESTERDAY | TODAY | TOMORROW | [CUSTOM DATE] | 📅
/// Styled with a liquid glassmorphism aesthetic.
class DatePillTabs extends StatelessWidget {
  final int selectedOffset; // -1, 0, 1, or any offset
  final ValueChanged<int> onChanged;
  final VoidCallback? onCalendarTap;

  const DatePillTabs({
    super.key,
    required this.selectedOffset,
    required this.onChanged,
    this.onCalendarTap,
  });

  /// Whether the selected offset is outside the standard 3-day window.
  bool get _isCustomDate => selectedOffset < -1 || selectedOffset > 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _pill(context, 'YESTERDAY', -1),
          const SizedBox(width: 10),
          _pill(context, 'TODAY', 0),
          const SizedBox(width: 10),
          _pill(context, 'TOMORROW', 1),

          // Show custom date pill when navigated beyond the 3-day window
          if (_isCustomDate) ...[
            const SizedBox(width: 10),
            _pill(
              context,
              DateFormat('MMM dd').format(
                DateTime.now().add(Duration(days: selectedOffset)),
              ).toUpperCase(),
              selectedOffset,
            ),
          ],

          // Calendar picker pill
          const SizedBox(width: 10),
          _calendarPill(context),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label, int offset) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = selectedOffset == offset;

    return GestureDetector(
      onTap: () => onChanged(offset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              // Frosted glass base with a primary tint if active
              color: isActive
                  ? cs.primary.withValues(alpha: isDark ? 0.15 : 0.2)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.white.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(20),
              // Subtle glass borders
              border: Border.all(
                color: isActive
                    ? cs.primary.withValues(alpha: isDark ? 0.3 : 0.4)
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.6)),
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: isActive ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Calendar icon pill — opens a date picker.
  Widget _calendarPill(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onCalendarTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.calendar_month,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
