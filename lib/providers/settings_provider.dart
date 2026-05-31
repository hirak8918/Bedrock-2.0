import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';

/// Provider for app-wide settings — theme, color seed, user profile.
class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.dark;
  int _colorSeedIndex = 0;
  String _userName = '';
  int _avatarIndex = 0;
  String? _avatarPath;
  bool _hasCompletedOnboarding = false;
  bool _hasAcceptedTerms = false;
  bool _useTerminalFont = true;

  ThemeMode get themeMode => _themeMode;
  int get colorSeedIndex => _colorSeedIndex;
  Color get primaryColor => AppColors.colorSeeds[_colorSeedIndex];
  String get userName => _userName;
  int get avatarIndex => _avatarIndex;
  String? get avatarPath => _avatarPath;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasAcceptedTerms => _hasAcceptedTerms;
  bool get useTerminalFont => _useTerminalFont;
  String? get fontFamily =>
      _useTerminalFont ? AppConstants.terminalFontFamily : null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final modeStr = _prefs.getString(AppConstants.keyThemeMode) ?? 'dark';
    _themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => ThemeMode.dark,
    );
    _colorSeedIndex = _prefs.getInt(AppConstants.keyColorSeedIndex) ?? 0;
    _userName = _prefs.getString(AppConstants.keyUserName) ?? '';
    _avatarIndex = _prefs.getInt(AppConstants.keyAvatarIndex) ?? 0;
    _avatarPath = _prefs.getString(AppConstants.keyAvatarPath);
    _hasCompletedOnboarding =
        _prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false;
    _hasAcceptedTerms =
        _prefs.getBool(AppConstants.keyHasAcceptedTerms) ?? false;
    _useTerminalFont = _prefs.getBool(AppConstants.keyUseTerminalFont) ?? true;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(AppConstants.keyThemeMode, mode.name);
    notifyListeners();
  }

  Future<void> setColorSeedIndex(int index) async {
    _colorSeedIndex = index;
    await _prefs.setInt(AppConstants.keyColorSeedIndex, index);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    await _prefs.setString(AppConstants.keyUserName, name);
    notifyListeners();
  }

  Future<void> setAvatarIndex(int index) async {
    _avatarIndex = index;
    await _prefs.setInt(AppConstants.keyAvatarIndex, index);
    notifyListeners();
  }

  Future<void> setAvatarPath(String? path) async {
    _avatarPath = path;
    if (path != null) {
      await _prefs.setString(AppConstants.keyAvatarPath, path);
    } else {
      await _prefs.remove(AppConstants.keyAvatarPath);
    }
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    await _prefs.setBool(AppConstants.keyHasCompletedOnboarding, true);
    notifyListeners();
  }

  Future<void> acceptTerms() async {
    _hasAcceptedTerms = true;
    await _prefs.setBool(AppConstants.keyHasAcceptedTerms, true);
    notifyListeners();
  }

  Future<void> setUseTerminalFont(bool value) async {
    _useTerminalFont = value;
    await _prefs.setBool(AppConstants.keyUseTerminalFont, value);
    notifyListeners();
  }
}
