import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/dot_grid_background.dart';
import 'notes/notes_screen.dart';
import 'tasks/tasks_screen.dart';
import 'stats/stats_screen.dart';
import 'settings/settings_screen.dart';

/// Main app shell with floating liquid-glass bottom navigation dock.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    NotesScreen(),
    TasksScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Let content extend behind the nav bar so the blur has
      // actual content to frost over.
      extendBody: true,
      body: DotGridBackground(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: KeyedSubtree(
            key: ValueKey(_currentIndex),
            child: _screens[_currentIndex],
          ),
        ),
      ),
      bottomNavigationBar: _buildGlassDock(cs, isDark),
    );
  }

  /// Floating liquid-glass dock with backdrop blur.
  Widget _buildGlassDock(ColorScheme cs, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                // Glass tint — translucent layer
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(28),
                // Subtle border for glass edge
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.9),
                  width: 0.5,
                ),
                // Outer glow / shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  // Inner subtle glow along the top edge
                  BoxShadow(
                    color: cs.primary.withValues(alpha: isDark ? 0.06 : 0.02),
                    blurRadius: 20,
                    spreadRadius: -4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 4;
                  return Stack(
                    children: [
                      // Top highlight — simulates light refraction on glass
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(
                                  alpha: isDark ? 0.15 : 0.4,
                                ),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              stops: const [0.1, 0.5, 0.9],
                            ),
                          ),
                        ),
                      ),
                      // Sliding indicator
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        left: _currentIndex * itemWidth,
                        top: 0,
                        bottom: 0,
                        width: itemWidth,
                        child: Center(
                          child: Container(
                            width: itemWidth - 20,
                            height: 48,
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.15 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: cs.primary.withValues(
                                  alpha: isDark ? 0.25 : 0.2,
                                ),
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Nav items row
                      Row(
                        children: [
                          _glassNavItem(
                            cs,
                            isDark,
                            0,
                            Icons.description_outlined,
                            Icons.description,
                            'NOTES',
                          ),
                          _glassNavItem(
                            cs,
                            isDark,
                            1,
                            Icons.checklist_outlined,
                            Icons.checklist,
                            'TASKS',
                          ),
                          _glassNavItem(
                            cs,
                            isDark,
                            2,
                            Icons.bar_chart_outlined,
                            Icons.bar_chart,
                            'STATS',
                          ),
                          _glassNavItem(
                            cs,
                            isDark,
                            3,
                            Icons.settings_outlined,
                            Icons.settings,
                            'SETTINGS',
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassNavItem(
    ColorScheme cs,
    bool isDark,
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: SizedBox(
          height: 68,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 14 : 10,
                vertical: isActive ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isActive ? activeIcon : icon,
                      key: ValueKey('$index-$isActive'),
                      color: isActive
                          ? cs.primary
                          : cs.onSurfaceVariant.withValues(alpha: 0.7),
                      size: 21,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                      letterSpacing: 1.0,
                      color: isActive
                          ? cs.primary
                          : cs.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
