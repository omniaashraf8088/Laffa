import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/fonts.dart';
import '../../core/theme/app_theme.dart';

/// Reusable custom text field for auth forms
class AuthFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIconWidget;
  final bool isArabic;
  final int maxLines;
  final int minLines;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const AuthFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIconWidget,
    required this.isArabic,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  late bool _obscureText;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _validate() {
    final error = widget.validator?.call(widget.controller.text);
    setState(() {
      _errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
          child: Text(
            widget.label,
            style: AppFonts.style(
              isArabic: widget.isArabic,
              fontSize: isSmallScreen ? 14 : 15,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
          ),
        ),

        // Input field
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText && widget.isPassword,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          textDirection: widget.isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
          onChanged: (value) {
            _validate();
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onSubmitted,
          style: AppFonts.style(
            isArabic: widget.isArabic,
            fontSize: isSmallScreen ? 15 : 16,
            color: AppColors.greyDark,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppFonts.style(
              isArabic: widget.isArabic,
              fontSize: isSmallScreen ? 14 : 15,
              color: AppColors.grey,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.secondary,
                    size: AppDimensions.iconMedium,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.secondary,
                      size: AppDimensions.iconMedium,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIconWidget,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingMedium,
            ),
          ),
        ),

        // Error message with animation
        if (_errorMessage != null && _errorMessage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingSmall),
            child: AnimatedOpacity(
              opacity: _errorMessage != null && _errorMessage!.isNotEmpty
                  ? 1.0
                  : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                _errorMessage ?? '',
                style: AppFonts.style(
                  isArabic: widget.isArabic,
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Password strength indicator widget
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool isArabic;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final strength = _calculateStrength();
    final color = _getStrengthColor();
    final label = _getStrengthLabel();

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Strength bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: LinearProgressIndicator(
              value: strength / 3.0,
              minHeight: 6,
              backgroundColor: AppColors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          // Strength label
          Text(
            label,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateStrength() {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return score.clamp(0, 3);
  }

  Color _getStrengthColor() {
    final strength = _calculateStrength();

    if (strength == 0) return AppColors.grey;
    if (strength == 1) return AppColors.error;
    if (strength == 2) return AppColors.warning;
    return AppColors.success;
  }

  String _getStrengthLabel() {
    final strength = _calculateStrength();

    if (strength == 0) return isArabic ? 'ضعيفة جداً' : 'Too weak';
    if (strength == 1) return isArabic ? 'ضعيفة' : 'Weak';
    if (strength == 2) return isArabic ? 'متوسطة' : 'Medium';
    return isArabic ? 'قوية' : 'Strong';
  }
}
