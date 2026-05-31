import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database/database_service.dart';

/// Provider for stats/dashboard — computed from local task data.
class StatsProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  // Formatted display values (no floating point artifacts)
  String todayHoursDisplay = '0';
  String diffDisplay = '0';
  String weeklyHoursDisplay = '0';
  double weeklyProgress = 0;
  int streak = 0;
  String bestDayHoursDisplay = '0';
  String bestDayLabel = '—';
  List<double> weeklyActivity = [0, 0, 0, 0, 0, 0, 0];

  int completedTasks = 0;
  int totalTasks = 0;

  Future<void> loadStats() async {
    completedTasks = await _db.getCompletedTaskCount();
    totalTasks = await _db.getTotalTaskCount();

    final allTasks = await _db.getAllTasks();

    // ── Today's completed tasks → hours estimate (1 task ≈ 0.5h) ──
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final todayTasks = allTasks
        .where((t) => t.date == todayStr && t.isCompleted)
        .length;
    final todayHours = todayTasks * 0.5;
    todayHoursDisplay = todayHours.toStringAsFixed(1);

    // ── Yesterday comparison ──
    final yesterdayStr = DateFormat(
      'yyyy-MM-dd',
    ).format(now.subtract(const Duration(days: 1)));
    final yesterdayTasks = allTasks
        .where((t) => t.date == yesterdayStr && t.isCompleted)
        .length;
    final diff = (todayHours - yesterdayTasks * 0.5);
    diffDisplay = '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)}';

    // ── Weekly hours ──
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    double weekTotal = 0;
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayStr = DateFormat('yyyy-MM-dd').format(day);
      final count = allTasks
          .where((t) => t.date == dayStr && t.isCompleted)
          .length;
      final hours = count * 0.5;
      weeklyActivity[i] = hours;
      weekTotal += hours;
    }
    weeklyHoursDisplay = weekTotal.toStringAsFixed(0);
    weeklyProgress = totalTasks > 0 ? (weekTotal / 20).clamp(0, 1) : 0;

    // ── Streak (consecutive days with ≥1 completed task) ──
    streak = 0;
    for (int i = 0; i < 365; i++) {
      final day = now.subtract(Duration(days: i));
      final dayStr = DateFormat('yyyy-MM-dd').format(day);
      final hasTasks = allTasks.any((t) => t.date == dayStr && t.isCompleted);
      if (hasTasks) {
        streak++;
      } else {
        break;
      }
    }

    // ── Best day ──
    final Map<String, int> dailyCounts = {};
    for (final t in allTasks.where((t) => t.isCompleted)) {
      dailyCounts[t.date] = (dailyCounts[t.date] ?? 0) + 1;
    }
    if (dailyCounts.isNotEmpty) {
      final bestEntry = dailyCounts.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      final bestHours = bestEntry.value * 0.5;
      bestDayHoursDisplay = bestHours.toStringAsFixed(1);
      try {
        final bestDate = DateFormat('yyyy-MM-dd').parse(bestEntry.key);
        bestDayLabel = DateFormat('EEEE, MMM d').format(bestDate);
      } catch (_) {
        bestDayLabel = bestEntry.key;
      }
    } else {
      bestDayHoursDisplay = '0';
      bestDayLabel = '—';
    }

    notifyListeners();
  }

  int get currentDayIndex {
    // 0=Mon, 6=Sun — DateTime.weekday: 1=Mon, 7=Sun
    return DateTime.now().weekday - 1;
  }
}
