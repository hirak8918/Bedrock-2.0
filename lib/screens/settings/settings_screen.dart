import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';
import 'about_screen.dart';
import 'terms_detail_screen.dart';

/// Settings screen — pixel-perfect match to "Setings.png".
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),

            // Header
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configure your environment preferences.',
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 24),

            // ── Appearance card ────────────────────────────
            _buildCard(
              cs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _themeButton(
                        context,
                        icon: Icons.wb_sunny_outlined,
                        label: 'Light',
                        mode: ThemeMode.light,
                        current: settings.themeMode,
                      ),
                      const SizedBox(width: 12),
                      _themeButton(
                        context,
                        icon: Icons.dark_mode,
                        label: 'Dark',
                        mode: ThemeMode.dark,
                        current: settings.themeMode,
                        showDot: true,
                      ),
                      const SizedBox(width: 12),
                      _themeButton(
                        context,
                        icon: Icons.brightness_auto,
                        label: 'System',
                        mode: ThemeMode.system,
                        current: settings.themeMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Font toggle row ────────────────────────────
            _buildCard(
              cs,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.terminal_rounded,
                    color: cs.onSurfaceVariant,
                    size: 22,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Switch to System Font',
                      style: TextStyle(fontSize: 15, color: cs.onSurface),
                    ),
                  ),
                  Switch.adaptive(
                    value: !settings.useTerminalFont,
                    onChanged: (val) {
                      settings.setUseTerminalFont(!val);
                    },
                    activeTrackColor: cs.primary,
                    inactiveTrackColor: cs.outline,
                    thumbColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // ── Color Seed card ────────────────────────────
            _buildCard(
              cs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Color Seed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select a core accent color for your interface.',
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...List.generate(AppColors.colorSeeds.length, (i) {
                        final isActive = settings.colorSeedIndex == i;
                        return GestureDetector(
                          onTap: () => settings.setColorSeedIndex(i),
                          child: AnimatedScale(
                            scale: isActive ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.colorSeeds[i],
                                borderRadius: BorderRadius.circular(6),
                                border: isActive
                                    ? Border.all(
                                        color: cs.onSurface,
                                        width: 2.5,
                                      )
                                    : null,
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: AppColors.colorSeeds[i]
                                              .withValues(alpha: 0.4),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isActive
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── List items card ────────────────────────────
            _buildCard(
              cs,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _listItem(
                    cs,
                    icon: Icons.info_outline,
                    title: 'About Bedrock',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    ),
                  ),
                  Divider(color: cs.outline, height: 1, indent: 56),
                  _listItem(
                    cs,
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TermsDetailScreen(),
                      ),
                    ),
                  ),
                  Divider(color: cs.outline, height: 1, indent: 56),
                  _listItem(
                    cs,
                    icon: Icons.grid_view_rounded,
                    title: 'App Info',
                    trailing: Text(
                      AppConstants.appVersion,
                      style: TextStyle(
                        fontSize: 14,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    ColorScheme cs, {
    required Widget child,
    EdgeInsets? padding,
  }) {
    return GlassCard(
      padding: padding ?? const EdgeInsets.all(20),
      borderRadius: 12,
      child: child,
    );
  }

  Widget _themeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ThemeMode mode,
    required ThemeMode current,
    bool showDot = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isActive = current == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<SettingsProvider>().setThemeMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? cs.primary : cs.outline,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 28,
                      color: isActive ? cs.onSurface : cs.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Accent dot indicator
              if (showDot && isActive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(
    ColorScheme cs, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: cs.onSurfaceVariant, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: cs.onSurface),
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 22),
          ],
        ),
      ),
    );
  }
}
