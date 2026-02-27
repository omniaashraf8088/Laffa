import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';
import 'auth_form_widget.dart';
import 'auth_validators.dart';
import 'auth_provider.dart';

/// Professional Forgot Password Screen
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool _linkSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword(AuthNotifier authNotifier, bool isArabic) {
    final emailError = AuthValidators.validateEmail(_emailController.text);

    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError), backgroundColor: AppColors.error),
      );
      return;
    }

    // Perform reset
    authNotifier.resetPassword(email: _emailController.text);
    setState(() => _linkSent = true);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? AppStringsAr.resetLinkSent : AppStringsEn.resetLinkSent,
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate back after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      isArabic ? Icons.arrow_forward : Icons.arrow_back,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Logo
                _buildLogo(),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge * 1.5
                      : AppDimensions.paddingXLarge * 2,
                ),

                // Title
                _buildTitle(isArabic, isSmallScreen),

                const SizedBox(height: AppDimensions.paddingMedium),

                // Subtitle
                _buildSubtitle(isArabic, isSmallScreen),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge * 1.5
                      : AppDimensions.paddingXLarge * 2,
                ),

                // Success message or form
                if (_linkSent)
                  _buildSuccessMessage(isArabic)
                else
                  Column(
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

                      SizedBox(
                        height: isSmallScreen
                            ? AppDimensions.paddingXLarge
                            : AppDimensions.paddingXLarge * 1.5,
                      ),

                      // Reset button
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: isArabic
                              ? AppStringsAr.sendResetLink
                              : AppStringsEn.sendResetLink,
                          onPressed: authState.isLoading
                              ? null
                              : () => _handleResetPassword(
                                  authNotifier,
                                  isArabic,
                                ),
                          isLoading: authState.isLoading,
                        ),
                      ),

                      SizedBox(
                        height: isSmallScreen
                            ? AppDimensions.paddingXLarge
                            : AppDimensions.paddingXLarge * 1.5,
                      ),

                      // Back to login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic ? 'العودة إلى ' : 'Back to ',
                            style: isArabic
                                ? GoogleFonts.cairo(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  )
                                : GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/login'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              isArabic
                                  ? AppStringsAr.login
                                  : AppStringsEn.login,
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
                      ),
                    ],
                  ),
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
          Icons.lock_reset_rounded,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTitle(bool isArabic, bool isSmallScreen) {
    return Text(
      isArabic ? AppStringsAr.resetPassword : AppStringsEn.resetPassword,
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
      isArabic
          ? 'أدخل بريدك الإلكتروني لاستقبال رابط إعادة تعيين كلمة المرور'
          : 'Enter your email to receive a password reset link',
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

  Widget _buildSuccessMessage(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        border: Border.all(color: AppColors.success, width: 1.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 60, color: AppColors.success),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            isArabic ? AppStringsAr.resetLinkSent : AppStringsEn.resetLinkSent,
            style: isArabic
                ? GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  )
                : GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            isArabic
                ? 'تحقق من بريدك الإلكتروني للحصول على تعليمات إعادة التعيين'
                : 'Check your email for password reset instructions',
            style: isArabic
                ? GoogleFonts.cairo(fontSize: 14, color: AppColors.grey)
                : GoogleFonts.poppins(fontSize: 14, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
