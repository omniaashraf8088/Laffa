import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../widgets/terms_checkbox.dart';
import '../widgets/auth_navigation_link.dart';

/// Professional Signup Screen
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup(AuthNotifier authNotifier, bool isArabic) {
    // Validate all fields
    final nameError = AuthValidators.validateName(_nameController.text);
    final emailError = AuthValidators.validateEmail(_emailController.text);
    final phoneError = AuthValidators.validatePhone(_phoneController.text);
    final passwordError = AuthValidators.validatePassword(
      _passwordController.text,
    );
    final confirmError = AuthValidators.validatePasswordMatch(
      _confirmPasswordController.text,
      _passwordController.text,
    );

    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        passwordError != null ||
        confirmError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? AppStringsAr.errorOccurred : AppStringsEn.errorOccurred,
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? AppStringsAr.agreeTerms : AppStringsEn.agreeTerms,
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Perform signup
    authNotifier.signup(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // Bridge auth → tenant: after signup, initialize tenant context
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

    // Navigate once tenant is initialized
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
                      ? AppStringsAr.signupTitle
                      : AppStringsEn.signupTitle,
                  isArabic: isArabic,
                  isSmallScreen: isSmallScreen,
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                AuthSubtitle(
                  text: isArabic
                      ? AppStringsAr.signupSubtitle
                      : AppStringsEn.signupSubtitle,
                  isArabic: isArabic,
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge,
                ),

                AuthErrorMessage(authState: authState, isArabic: isArabic),

                Column(
                  children: [
                    AuthFormField(
                      label: isArabic
                          ? AppStringsAr.fullName
                          : AppStringsEn.fullName,
                      hintText: isArabic
                          ? AppStringsAr.nameHintAr
                          : AppStringsEn.nameHintEn,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      isArabic: isArabic,
                      validator: AuthValidators.validateName,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    AuthFormField(
                      label: isArabic ? AppStringsAr.email : AppStringsEn.email,
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
                      label: isArabic ? AppStringsAr.phone : AppStringsEn.phone,
                      hintText: isArabic
                          ? AppStringsAr.phoneHintAr
                          : AppStringsEn.phoneHintEn,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      isArabic: isArabic,
                      validator: AuthValidators.validatePhone,
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
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingSmall),

                    PasswordStrengthIndicator(
                      password: _passwordController.text,
                      isArabic: isArabic,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    AuthFormField(
                      label: isArabic
                          ? AppStringsAr.confirmPassword
                          : AppStringsEn.confirmPassword,
                      hintText: AppStringsEn.passwordPlaceholder,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      isArabic: isArabic,
                      validator: (value) =>
                          AuthValidators.validatePasswordMatch(
                            value,
                            _passwordController.text,
                          ),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    TermsCheckbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() => _agreeToTerms = value);
                      },
                      isArabic: isArabic,
                    ),
                  ],
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: isArabic ? AppStringsAr.signup : AppStringsEn.signup,
                    onPressed: authState.isLoading
                        ? null
                        : () => _handleSignup(authNotifier, isArabic),
                    isLoading: authState.isLoading,
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingLarge),

                AuthNavigationLink(
                  promptText: isArabic
                      ? AppStringsAr.alreadyHaveAccount
                      : AppStringsEn.alreadyHaveAccount,
                  actionText: isArabic
                      ? AppStringsAr.login
                      : AppStringsEn.login,
                  onPressed: () => context.pop(),
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
