import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection_container.dart';
import 'app_strings_ar.dart';
import 'app_strings_en.dart';

enum AppLanguage { en, ar }

enum AppThemeMode { light, dark, system }

class LocalizationState {
  final AppLanguage language;
  final AppThemeMode themeMode;

  const LocalizationState({required this.language, required this.themeMode});

  LocalizationState copyWith({AppLanguage? language, AppThemeMode? themeMode}) {
    return LocalizationState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class LocalizationNotifier extends StateNotifier<LocalizationState> {
  LocalizationNotifier(this._prefs)
    : super(
        const LocalizationState(
          language: AppLanguage.en,
          themeMode: AppThemeMode.system,
        ),
      ) {
    _loadPreferences();
  }

  final SharedPreferences _prefs;

  static const String _languageKey = 'app_language';
  static const String _themeModeKey = 'app_theme_mode';

  void _loadPreferences() {
    final languageStr = _prefs.getString(_languageKey) ?? 'en';
    final themeModeStr = _prefs.getString(_themeModeKey) ?? 'system';

    final language = languageStr == 'ar' ? AppLanguage.ar : AppLanguage.en;
    final themeMode = AppThemeMode.values.firstWhere(
      (e) => e.toString().split('.').last == themeModeStr,
      orElse: () => AppThemeMode.system,
    );

    state = state.copyWith(language: language, themeMode: themeMode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setString(
      _languageKey,
      language == AppLanguage.ar ? 'ar' : 'en',
    );
    state = state.copyWith(language: language);
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode.toString().split('.').last);
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    await setThemeMode(newMode);
  }

  bool get isArabic => state.language == AppLanguage.ar;
  bool get isRTL => state.language == AppLanguage.ar;
}

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, LocalizationState>((ref) {
      return LocalizationNotifier(sl<SharedPreferences>());
    });

final appStringsProvider = Provider<dynamic>((ref) {
  final localization = ref.watch(localizationProvider);
  return localization.language == AppLanguage.ar
      ? AppStringsAr()
      : AppStringsEn();
});

final isRTLProvider = Provider<bool>((ref) {
  final localization = ref.watch(localizationProvider);
  return localization.language == AppLanguage.ar;
});
