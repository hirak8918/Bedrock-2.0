import 'package:flutter/material.dart';
import '../../core/theme/dot_grid_background.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../main_shell.dart';

/// Terms & Conditions screen — offline privacy policy, must accept to proceed.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                Text(
                  'TERMS &\nCONDITIONS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    height: 1.2,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please read our privacy policy before continuing.',
                  style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Policy text in scrollable card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outline, width: 1),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        AppConstants.privacyPolicy,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.7,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Accept button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final settings = context.read<SettingsProvider>();
                      await settings.acceptTerms();
                      await settings.completeOnboarding();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                        (route) => false,
                      );
                    },
                    child: const Text('ACCEPT & CONTINUE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
