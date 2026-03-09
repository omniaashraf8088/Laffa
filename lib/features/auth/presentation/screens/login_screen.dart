import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../core/tenant/tenant_service.dart';
import '../widgets/auth_form_widget.dart';
import '../controllers/auth_validators.dart';
import '../controllers/auth_provider.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_title.dart';
import '../widgets/auth_subtitle.dart';
import '../widgets/auth_error_message.dart';
import '../widgets/save_password_row.dart';
import '../widgets/auth_navigation_link.dart';

/// Professional Login Screen
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  String? _emailError;
  String? _passwordError;
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthNotifier authNotifier, bool isArabic) {
    // Validate form
    _emailError = AuthValidators.validateEmail(_emailController.text);
    _passwordError = AuthValidators.validatePassword(_passwordController.text);

    setState(() {});

    if (_emailError == null && _passwordError == null) {
      // Perform login
      authNotifier.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _persistCredentials();
    }
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldRemember = prefs.getBool('remember_password') ?? false;

    if (!mounted) return;

    setState(() {
      _rememberPassword = shouldRemember;
      if (shouldRemember) {
        _emailController.text = prefs.getString('saved_email') ?? '';
        _passwordController.text = prefs.getString('saved_password') ?? '';
      }
    });
  }

  Future<void> _persistCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_password', _rememberPassword);

    if (_rememberPassword) {
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setString('saved_password', _passwordController.text);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // Bridge auth → tenant: after login, initialize tenant context
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated &&
          next.user != null &&
          (prev == null || !prev.isAuthenticated)) {
        final user = next.user!;
        ref
            .read(tenantProvider.notifier)
            .initializeFromAuth(
              userId: user.id,
              email: user.email,
              name: user.name,
              phone: user.phone,
            );
      }
    });

    // Navigate once tenant is initialized (user is set)
    final tenantState = ref.watch(tenantProvider);
    if (tenantState.isAuthenticated && !tenantState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go(AppRouter.home);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen
                  ? AppDimensions.paddingLarge
                  : AppDimensions.paddingXLarge,
              vertical: AppDimensions.paddingLarge,
            ),
            child: Column(
              children: [
                const AuthLogo(),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                AuthTitle(
                  text: isArabic
                      ? AppStringsAr.loginTitle
                      : AppStringsEn.loginTitle,
                  isArabic: isArabic,
                  isSmallScreen: isSmallScreen,
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                AuthSubtitle(
                  text: isArabic
                      ? AppStringsAr.loginSubtitle
                      : AppStringsEn.loginSubtitle,
                  isArabic: isArabic,
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                AuthErrorMessage(authState: authState, isArabic: isArabic),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthFormField(
                        label: isArabic
                            ? AppStringsAr.email
                            : AppStringsEn.email,
                        hintText: isArabic
                            ? AppStringsAr.emailHintAr
                            : AppStringsEn.emailHintEn,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        isArabic: isArabic,
                        validator: AuthValidators.validateEmail,
                      ),

                      const SizedBox(height: AppDimensions.paddingLarge),

                      AuthFormField(
                        label: isArabic
                            ? AppStringsAr.password
                            : AppStringsEn.password,
                        hintText: AppStringsEn.passwordPlaceholder,
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        isArabic: isArabic,
                        validator: AuthValidators.validatePassword,
                      ),

                      const SizedBox(height: AppDimensions.paddingMedium),

                      SavePasswordRow(
                        rememberPassword: _rememberPassword,
                        onChanged: (value) {
                          setState(() => _rememberPassword = value);
                          _persistCredentials();
                        },
                        isArabic: isArabic,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: isArabic ? AppStringsAr.login : AppStringsEn.login,
                    onPressed: authState.isLoading
                        ? null
                        : () => _handleLogin(authNotifier, isArabic),
                    isLoading: authState.isLoading,
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingLarge),

                AuthNavigationLink(
                  promptText: isArabic
                      ? AppStringsAr.dontHaveAccount
                      : AppStringsEn.dontHaveAccount,
                  actionText: isArabic
                      ? AppStringsAr.signup
                      : AppStringsEn.signup,
                  onPressed: () => context.push(AppRouter.signup),
                  isArabic: isArabic,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
