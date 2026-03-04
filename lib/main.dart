import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'core/di/injection_container.dart';
import 'core/localization/localization_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const ProviderScope(child: LaffaApp()));
}

class LaffaApp extends ConsumerWidget {
  const LaffaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final router = ref.watch(goRouterProvider);

    Intl.defaultLocale =
        localization.language == AppLanguage.ar ? 'ar_EG' : 'en_US';

    final isRTL = localization.language == AppLanguage.ar;
    final isArabic = localization.language == AppLanguage.ar;

    final theme = AppTheme.lightTheme(isArabic: isArabic);
    final darkTheme = AppTheme.darkTheme(isArabic: isArabic);
    final themeMode = _mapThemeMode(localization.themeMode);

    return MaterialApp.router(
      title: 'Laffa',
      routerConfig: router,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: Locale(isArabic ? 'ar' : 'en'),
      builder: (context, child) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeMode _mapThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
