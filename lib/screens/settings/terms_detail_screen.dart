import 'package:flutter/material.dart';
import '../../core/theme/dot_grid_background.dart';
import '../../core/constants/app_constants.dart';

/// Terms & Conditions detail screen (reachable from Settings).
class TermsDetailScreen extends StatelessWidget {
  const TermsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: cs.onSurfaceVariant,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    AppConstants.privacyPolicy,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
