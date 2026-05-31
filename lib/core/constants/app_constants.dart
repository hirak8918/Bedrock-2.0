/// App-wide constants for Bedrock.
class AppConstants {
  AppConstants._();

  static const String appName = 'BEDROCK';
  static const String appVersion = 'v2.4.1';
  static const String developerCredit = 'Developed by Hirak Barman';

  // SharedPreferences keys
  static const String keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String keyHasAcceptedTerms = 'has_accepted_terms';
  static const String keyThemeMode = 'theme_mode';
  static const String keyColorSeedIndex = 'color_seed_index';
  static const String keyUserName = 'user_name';
  static const String keyAvatarIndex = 'avatar_index';
  static const String keyAvatarPath = 'avatar_path';
  static const String keyUseTerminalFont = 'use_terminal_font';

  // Font families
  static const String terminalFontFamily = 'JetBrainsMono';

  // Database
  static const String dbName = 'bedrock.db';
  static const int dbVersion = 1;

  // Privacy policy text (offline)
  static const String privacyPolicy = '''
BEDROCK PRIVACY POLICY & TERMS OF USE

Last updated: May 2026

1. OFFLINE-FIRST COMMITMENT
Bedrock is designed as a strictly offline application. All your data — notes, tasks, and preferences — is stored exclusively on your device. We do not collect, transmit, or store any of your data on external servers.

2. DATA STORAGE
All information you enter into Bedrock is saved locally on your device using an encrypted local database. Your data never leaves your device unless you explicitly choose to export it.

3. PERMISSIONS
• Storage: Required to save your notes and tasks locally on your device.
• Notifications: Optional. Used only to deliver task reminders you configure. No data is sent externally.

4. NO TRACKING
Bedrock contains zero analytics, tracking pixels, or telemetry. We do not monitor your usage patterns, and we have no way to access your content.

5. YOUR CONTROL
You have complete control over your data. You can delete all app data at any time through your device settings or within the app.

6. OPEN COMMITMENT
Bedrock will never introduce cloud syncing, advertising, or data collection without explicit opt-in from you.

By tapping "Accept & Continue", you acknowledge that you have read and understood this privacy policy.
''';
}
