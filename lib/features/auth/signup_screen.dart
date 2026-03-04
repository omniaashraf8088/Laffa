import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';
import 'auth_form_widget.dart';
import 'auth_validators.dart';
import 'auth_provider.dart';

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

    // Navigate on successful signup
    if (authState.isAuthenticated && authState.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
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
                // Logo with Hero animation
                _buildLogo(),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                // Title
                _buildTitle(isArabic, isSmallScreen),

                const SizedBox(height: AppDimensions.paddingMedium),

                // Subtitle
                _buildSubtitle(isArabic, isSmallScreen),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge,
                ),

                // Error message
                _buildErrorMessage(authState, isArabic),

                // Form fields
                Column(
                  children: [
                    // Name field
                    AuthFormField(
                      label: isArabic
                          ? AppStringsAr.fullName
                          : AppStringsEn.fullName,
                      hintText: isArabic ? 'أحمد محمد' : 'John Doe',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      isArabic: isArabic,
                      validator: AuthValidators.validateName,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Email field
                    AuthFormField(
                      label: isArabic ? AppStringsAr.email : AppStringsEn.email,
                      hintText: isArabic
                          ? 'البريد@مثال.com'
                          : 'example@mail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      isArabic: isArabic,
                      validator: AuthValidators.validateEmail,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Phone field
                    AuthFormField(
                      label: isArabic ? AppStringsAr.phone : AppStringsEn.phone,
                      hintText: isArabic ? '+966501234567' : '+1 234 567 8900',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      isArabic: isArabic,
                      validator: AuthValidators.validatePhone,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Password field
                    AuthFormField(
                      label: isArabic
                          ? AppStringsAr.password
                          : AppStringsEn.password,
                      hintText: isArabic ? '••••••••' : '••••••••',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      isArabic: isArabic,
                      validator: AuthValidators.validatePassword,
                      onChanged: (value) {
                        setState(() {}); // Rebuild for strength indicator
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingSmall),

                    // Password strength indicator
                    PasswordStrengthIndicator(
                      password: _passwordController.text,
                      isArabic: isArabic,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Confirm password field
                    AuthFormField(
                      label: isArabic
                          ? AppStringsAr.confirmPassword
                          : AppStringsEn.confirmPassword,
                      hintText: isArabic ? '••••••••' : '••••••••',
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

                    // Terms & Conditions
                    _buildTermsCheckbox(isArabic),
                  ],
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                // Signup button
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

                // Login link
                _buildLoginLink(isArabic),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'auth_logo',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.electric_scooter_rounded,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTitle(bool isArabic, bool isSmallScreen) {
    return Text(
      isArabic ? AppStringsAr.signupTitle : AppStringsEn.signupTitle,
      style: AppFonts.style(
        isArabic: isArabic,
        fontSize: isSmallScreen ? 28 : 32,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(bool isArabic, bool isSmallScreen) {
    return Text(
      isArabic ? AppStringsAr.signupSubtitle : AppStringsEn.signupSubtitle,
      style: AppFonts.style(
        isArabic: isArabic,
        fontSize: isSmallScreen ? 15 : 16,
        color: AppColors.grey,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage(AuthState authState, bool isArabic) {
    if (authState.errorMessage == null || authState.errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity:
          authState.errorMessage != null && authState.errorMessage!.isNotEmpty
          ? 1.0
          : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingLarge),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.error, width: 1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Text(
                authState.errorMessage ?? '',
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: 14,
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(bool isArabic) {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          fillColor: WidgetStateProperty.all(AppColors.primary),
        ),
        Expanded(
          child: Text(
            isArabic ? AppStringsAr.agreeTerms : AppStringsEn.agreeTerms,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: 13,
              color: AppColors.greyDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isArabic
              ? AppStringsAr.alreadyHaveAccount
              : AppStringsEn.alreadyHaveAccount,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            isArabic ? AppStringsAr.login : AppStringsEn.login,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
