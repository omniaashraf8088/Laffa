import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'core/localization/localization_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final router = ref.watch(goRouterProvider);

    // Set locale for date formatting
    Intl.defaultLocale = localization.language == AppLanguage.ar
        ? 'ar_EG'
        : 'en_US';

    // Determine text direction
    final isRTL = localization.language == AppLanguage.ar;

    // Determine theme
    final themeMode = _getThemeMode(localization.themeMode, context);
    final theme = AppTheme.lightTheme(
      isArabic: localization.language == AppLanguage.ar,
    );
    final darkTheme = AppTheme.darkTheme(
      isArabic: localization.language == AppLanguage.ar,
    );

    return MaterialApp.router(
      title: 'Smart Wheel',
      routerConfig: router,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: Locale(localization.language == AppLanguage.ar ? 'ar' : 'en'),
      builder: (context, child) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeMode _getThemeMode(AppThemeMode themeMode, BuildContext context) {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
