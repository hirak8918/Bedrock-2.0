import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stats_provider.dart';
import '../../widgets/bedrock_app_bar.dart';
import '../../widgets/glass_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/activity_chart.dart';

/// Stats / Dashboard screen — pixel-perfect match to "Stats.png".
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const BedrockAppBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 8),

                // 2×2 stat grid
                SizedBox(
                  height: 340,
                  child: Column(
                    children: [
                      // Top row
                      Expanded(
                        child: Row(
                          children: [
                            // Today
                            Expanded(
                              child: StatCard(
                                title: 'Today',
                                value: '${stats.todayHoursDisplay}h',
                                subtitle: '${stats.diffDisplay}h vs yesterday',
                                icon: Icons.hourglass_bottom,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // This Week
                            Expanded(
                              child: StatCard(
                                title: 'This Week',
                                value: '${stats.weeklyHoursDisplay}h',
                                icon: Icons.calendar_month,
                                extra: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: stats.weeklyProgress,
                                    backgroundColor: cs.outline,
                                    color: cs.primary,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Bottom row
                      Expanded(
                        child: Row(
                          children: [
                            // Streak
                            Expanded(
                              child: StatCard(
                                title: 'Streak',
                                value: '${stats.streak}',
                                subtitle: 'DAYS ACTIVE',
                                icon: Icons.local_fire_department,
                                valueColor: cs.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Best Day
                            Expanded(
                              child: StatCard(
                                title: 'Best Day',
                                value: '${stats.bestDayHoursDisplay}h',
                                subtitle: stats.bestDayLabel,
                                icon: Icons.emoji_events,
                                iconColor: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Activity Trends card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 12,
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activity Trends',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Divider(color: cs.outline),
                      const SizedBox(height: 12),

                      // Chart
                      ActivityChart(
                        data: stats.weeklyActivity,
                        currentDayIndex: stats.currentDayIndex,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
