import 'package:flutter/material.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class FeatureContainer extends StatelessWidget {
  final Color primaryColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureContainer({
    super.key,
    required this.primaryColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.whiteBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
