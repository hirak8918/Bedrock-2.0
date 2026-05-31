import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'providers/notes_provider.dart';
import 'providers/tasks_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force dark status bar icons for the dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.navBarBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize settings (SharedPreferences)
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();

  runApp(BedrockApp(settingsProvider: settingsProvider));
}

class BedrockApp extends StatelessWidget {
  final SettingsProvider settingsProvider;

  const BedrockApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => NotesProvider()..loadNotes()),
        ChangeNotifierProvider(create: (_) => TasksProvider()..loadTasks()),
        ChangeNotifierProvider(create: (_) => StatsProvider()..loadStats()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Bedrock',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: AppTheme.light(
              seedColor: settings.primaryColor,
              fontFamily: settings.fontFamily,
            ),
            darkTheme: AppTheme.dark(
              seedColor: settings.primaryColor,
              fontFamily: settings.fontFamily,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
