import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';
import 'auth_form_widget.dart';
import 'auth_validators.dart';
import 'auth_provider.dart';

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

    // Navigate on successful login
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
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                // Error message
                _buildErrorMessage(authState, isArabic),

                // Form fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email field
                      AuthFormField(
                        label: isArabic
                            ? AppStringsAr.email
                            : AppStringsEn.email,
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
                      ),

                      const SizedBox(height: AppDimensions.paddingMedium),

                      // Save password + forgot password row
                      _buildSavePasswordRow(isArabic),
                    ],
                  ),
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge
                      : AppDimensions.paddingXLarge * 1.5,
                ),

                // Login button
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

                // Signup link
                _buildSignupLink(isArabic),
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
          color: AppColors.primary.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
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
      isArabic ? AppStringsAr.loginTitle : AppStringsEn.loginTitle,
      style: isArabic
          ? GoogleFonts.cairo(
              fontSize: isSmallScreen ? 28 : 32,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            )
          : GoogleFonts.poppins(
              fontSize: isSmallScreen ? 28 : 32,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(bool isArabic, bool isSmallScreen) {
    return Text(
      isArabic ? AppStringsAr.loginSubtitle : AppStringsEn.loginSubtitle,
      style: isArabic
          ? GoogleFonts.cairo(
              fontSize: isSmallScreen ? 15 : 16,
              color: AppColors.grey,
              height: 1.5,
            )
          : GoogleFonts.poppins(
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
          color: AppColors.error.withOpacity(0.1),
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
                style: isArabic
                    ? GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      )
                    : GoogleFonts.poppins(
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

  Widget _buildForgotPasswordButton(bool isArabic) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.push('/forgot-password'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          isArabic ? AppStringsAr.forgotPassword : AppStringsEn.forgotPassword,
          style: isArabic
              ? GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                )
              : GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ),
    );
  }

  Widget _buildSavePasswordRow(bool isArabic) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _rememberPassword = !_rememberPassword;
              });
              _persistCredentials();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _rememberPassword,
                    onChanged: (value) {
                      setState(() {
                        _rememberPassword = value ?? false;
                      });
                      _persistCredentials();
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      isArabic
                          ? AppStringsAr.savePassword
                          : AppStringsEn.savePassword,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isArabic
                          ? GoogleFonts.cairo(
                              fontSize: 14,
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                            )
                          : GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: _buildForgotPasswordButton(isArabic),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupLink(bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isArabic
              ? AppStringsAr.dontHaveAccount
              : AppStringsEn.dontHaveAccount,
          style: isArabic
              ? GoogleFonts.cairo(fontSize: 14, color: AppColors.grey)
              : GoogleFonts.poppins(fontSize: 14, color: AppColors.grey),
        ),
        TextButton(
          onPressed: () => context.push('/signup'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            isArabic ? AppStringsAr.signup : AppStringsEn.signup,
            style: isArabic
                ? GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  )
                : GoogleFonts.poppins(
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
