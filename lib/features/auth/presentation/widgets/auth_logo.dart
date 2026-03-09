import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthLogo extends StatelessWidget {
  final IconData icon;

  const AuthLogo({super.key, this.icon = Icons.electric_scooter_rounded});

  @override
  Widget build(BuildContext context) {
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
        child: Icon(icon, size: 50, color: AppColors.primary),
      ),
    );
  }
}
