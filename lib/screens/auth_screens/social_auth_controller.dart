import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/screens/entry_mode/entry_mode_screen.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Handles Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      loadingDialog(message: 'Logging in with Google...', loading: true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Navigator.of(Get.context!).pop();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      await _handleSocialLoginResult(userCredential.user);
    } catch (e) {
      Navigator.of(Get.context!).pop();
      _showErrorSnackbar('Google Sign-In failed: $e');
    }
  }

  /// Handles Apple Sign-In
  Future<void> signInWithApple() async {
    try {
      loadingDialog(message: 'Logging in with Apple...', loading: true);

      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final OAuthCredential credential =
          AppleAuthProvider.credential(appleCredential.identityToken!);

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      await _handleSocialLoginResult(userCredential.user);
    } catch (e) {
      Navigator.of(Get.context!).pop(); // Close loading dialog
      _showErrorSnackbar('Apple Sign-In failed: $e');
    }
  }

  /// Handles the result of a social login (unified logic for creation/update)
  Future<void> _handleSocialLoginResult(User? user) async {
    if (user == null) {
      Navigator.of(Get.context!).pop();
      _showErrorSnackbar('User information not found.');
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await _createNewUserInFirestore(user);
        Navigator.of(Get.context!).pop();
        Get.offAll(() => Preference1());
      } else {
        await _updateExistingUser(user.uid);
        await getCurrentUserData();
        Navigator.of(Get.context!).pop();
        Get.offAll(() => EntryModeScreen());
      }
    } catch (e) {
      Navigator.of(Get.context!).pop();
      _showErrorSnackbar('Error during account setup: $e');
    }
  }

  /// Creates a new user record in Firestore
  Future<void> _createNewUserInFirestore(User user) async {
    final onboardingController = Get.put(OnboardingController());

    UserModel newUser = UserModel.initialize();
    newUser.userEmail.text = user.email ?? '';
    newUser.username.text =
        user.displayName ?? user.email?.split('@')[0] ?? 'User';
    newUser.userID = user.uid;
    newUser.userImage.value = user.photoURL ?? '';

    var data = newUser.toMap();
    data['uid'] = user.uid;
    data['isAdmin'] = false;
    data['country'] = onboardingController.selectedCountry.value;
    data['city'] = onboardingController.selectedCity.value;

    // Attempt to get FCM token
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      data['fcmToken'] = fcmToken;
      data['token'] = Platform.isAndroid ? (fcmToken ?? '') : '';
    } catch (_) {}

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(data);
  }

  /// Updates an existing user record (e.g., FCM token)
  Future<void> _updateExistingUser(String uid) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmToken': fcmToken,
      });
    } catch (_) {}
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Authentication Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  /// Helper functions for Apple Sign-In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
