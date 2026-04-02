import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/screens/auth_screens/social_auth_controller.dart';

class GoogleSignInButton extends StatelessWidget {
  final double? width;

  const GoogleSignInButton({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocialAuthController());
    return InkWell(
      onTap: () => controller.signInWithGoogle(),
      child: Container(
        height: 57,
        width: 57,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/google.png',
              height: 24,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class AppleSignInButton extends StatelessWidget {
  final double? width;

  const AppleSignInButton({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    // if (!Platform.isIOS && !Platform.isMacOS && !kIsWeb) {
    //   return const SizedBox.shrink();
    // }

    final controller = Get.put(SocialAuthController());
    return InkWell(
      onTap: () => controller.signInWithApple(),
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.apple,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// A divider with "Or continue with" text
class SocialDivider extends StatelessWidget {
  const SocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Or continue with',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 1)),
        ],
      ),
    );
  }
}
