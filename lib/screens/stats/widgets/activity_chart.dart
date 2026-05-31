import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Weekly activity bar chart — Mon to Sun, current day highlighted with primary.
class ActivityChart extends StatelessWidget {
  final List<double> data;
  final int currentDayIndex;

  const ActivityChart({
    super.key,
    required this.data,
    required this.currentDayIndex,
  });

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxY = data.reduce((a, b) => a > b ? a : b).clamp(1.0, 12.0);

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: maxY + 1,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= _dayLabels.length) {
                    return const SizedBox.shrink();
                  }
                  final isToday = i == currentDayIndex;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: isToday
                          ? BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(4),
                            )
                          : null,
                      child: Text(
                        _dayLabels[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isToday ? Colors.black : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 3,
            getDrawingHorizontalLine: (value) => FlLine(
              color: cs.outline.withValues(alpha: 0.5),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            final isToday = i == currentDayIndex;
            final isPast = i <= currentDayIndex;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: isPast ? data[i] : 0,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  color: isToday
                      ? cs.primary
                      : cs.onSurfaceVariant.withValues(alpha: 0.3),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
