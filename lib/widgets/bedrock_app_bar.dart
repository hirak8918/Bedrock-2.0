import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

/// Global app bar: search icon | BEDROCK logo | settings gear.
class BedrockAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;

  const BedrockAppBar({super.key, this.onSearchTap});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Spacer to balance layout (same width as right spacer)
            const SizedBox(width: 26),
            // Center logo
            Expanded(
              child: Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: primary,
                ),
              ),
            ),
            // Spacer to balance layout (same width as search icon)
            const SizedBox(width: 26),
          ],
        ),
      ),
    );
  }
}
