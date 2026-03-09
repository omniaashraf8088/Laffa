import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../widgets/auth_form_widget.dart';
import '../controllers/auth_validators.dart';
import '../controllers/auth_provider.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_title.dart';
import '../widgets/auth_subtitle.dart';
import '../widgets/auth_navigation_link.dart';

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

                const AuthLogo(icon: Icons.lock_reset_rounded),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge * 1.5
                      : AppDimensions.paddingXLarge * 2,
                ),

                AuthTitle(
                  text: isArabic
                      ? AppStringsAr.resetPassword
                      : AppStringsEn.resetPassword,
                  isArabic: isArabic,
                  isSmallScreen: isSmallScreen,
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                AuthSubtitle(
                  text: isArabic
                      ? AppStringsAr.enterEmailForReset
                      : AppStringsEn.enterEmailForReset,
                  isArabic: isArabic,
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(
                  height: isSmallScreen
                      ? AppDimensions.paddingXLarge * 1.5
                      : AppDimensions.paddingXLarge * 2,
                ),

                if (_linkSent)
                  _buildSuccessMessage(isArabic)
                else
                  Column(
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

                      SizedBox(
                        height: isSmallScreen
                            ? AppDimensions.paddingXLarge
                            : AppDimensions.paddingXLarge * 1.5,
                      ),

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

                      AuthNavigationLink(
                        promptText: isArabic
                            ? AppStringsAr.backTo
                            : AppStringsEn.backTo,
                        actionText: isArabic
                            ? AppStringsAr.login
                            : AppStringsEn.login,
                        onPressed: () => context.push(AppRouter.login),
                        isArabic: isArabic,
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

  Widget _buildSuccessMessage(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.success, width: 1.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 60, color: AppColors.success),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            isArabic ? AppStringsAr.resetLinkSent : AppStringsEn.resetLinkSent,
            style: AppTextStyles.authButton(
              isArabic: isArabic,
              color: AppColors.success,
              large: true,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            isArabic
                ? AppStringsAr.checkEmailForReset
                : AppStringsEn.checkEmailForReset,
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
