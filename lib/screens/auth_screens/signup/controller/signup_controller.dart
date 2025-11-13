import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/screens/auth_screens/verify/verify_page.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SignupController extends GetxController {
  // Observable variable to track the state of Terms and Conditions checkbox
  var termsAndConditions = false.obs;

  // Observable variables for password visibility toggles
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // Controller for verification code input
  final verifyController = TextEditingController();

  // Observable variable for button click state
  var onClick = false.obs;

  // Observable variable to track acceptance of Terms and Conditions
  var acceptTerms = false.obs;

  // Function to reset all text fields by reinitializing the user model
  void resetTextFields() {
    userModel = UserModel.initialize();
  }

  // User model to hold user input data
  UserModel userModel = UserModel.initialize();

  // Verification code for email verification
  int? verificationCode;

  // Function to check if the email already exists in Firestore
  Future<bool> checkIfEmailExists({String? email}) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .where('userEmail', isEqualTo: email)
        .get();
    print(doc.docs.isEmpty);
    return doc.docs.isEmpty;
  }

  // Function to send a verification email
  sendEmail({bool isFromResendOtp = false}) async {
    bool emailExists =
        await checkIfEmailExists(email: userModel.userEmail.text);
    if (emailExists) {
      loadingDialog(
        message: "Sending email verification code!",
        loading: true,
        height: 170,
      );

      // Gmail credentials for SMTP
      String username = "uzairmehmood754@gmail.com";
      String password = "qnua ednv vafr vcxz";

      // Generate a 6-digit verification code
      verificationCode = 100000 + Random().nextInt(90000);
      if (verificationCode!.bitLength > 6) {
        verificationCode = 100000 + Random().nextInt(99999);
      }
      update();
      print("========== $verificationCode");

      // Create an SMTP server instance
      final smtpServer = gmail(username, password);

      // Email message details
      final message = Message()
        ..from = Address(username, "SAVRLY")
        ..recipients.add(userModel.userEmail.text)
        ..subject = 'SAVRLY'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html =
            "<p>$verificationCode is verification code for ${userModel.userEmail.text}</p>";

      try {
        // Send the email
        final sendReport = await send(message, smtpServer);
        print('Message sent: $sendReport');
        Get.back();

        // Navigate to verification page if this is not a resend request
        if (!isFromResendOtp) {
          Get.to(() => VerifyPage(
                email: userModel.userEmail.text,
              ));
        }
      } on MailerException catch (e) {
        // Handle email sending failure
        Get.back();
        print('Message not sent. Error: $e');
        for (var problem in e.problems) {
          print('Problem: ${problem.code}: ${problem.msg}');
        }
        loadingDialog(
            message: "Failed to send verification code", button: true);
      }
    } else {
      loadingDialog(
          message: "Email already exists!",
          button: true,
          isWrongPassword: true,
          height: 150);
    }
  }

  // Function to create a new user account
  createAccount() async {
    loadingDialog(message: "Please wait!", loading: true, height: 150);
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: userModel.userEmail.text,
        password: userModel.password.text,
      )
          .then((value) async {
        debugPrint('Create Account successfully');

        // Insert user data into Firestore after successful account creation
        await insertData();
        Get.back();
      }).onError((error, stackTrace) {
        // Handle errors during account creation
        print(error.toString());
        if (error ==
            '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
          loadingDialog(
              message:
                  "The email you provided is already in use. Try with a new email!",
              button: true);
        } else {
          loadingDialog(message: "Something went wrong !!!", button: true);
        }
      });
    } on FirebaseAuthException catch (error) {
      // Handle Firebase-specific exceptions
      debugPrint("signUp ${error.code}");
      if (error.code == "email-already-in-use") {
        loadingDialog(
            message:
                "The email you provided is already in use. Try with a new email!",
            button: true);
      }
    }
  }

  // Instance of Firebase Messaging for FCM token management
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Function to insert user data into Firestore
  insertData() async {
    // Convert user model to a map for Firestore storage
    var data = await userModel.toMap();
    final onbordingController = Get.put(OnboardingController());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .set(data)
        .then((value) async {
      // Update additional fields in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid.toString())
          .update({
        'userID': auth.currentUser!.uid,
        'country': onbordingController.selectedCountry.value,
        'city': onbordingController.selectedCity.value,
        'token': Platform.isAndroid ? await getUserDeviceToken() : '',
      }).then((value) {
        // Navigate to preferences page after successful data insertion
        print('going to prefer 1');
        // update user fcm token by "Modassir"
        FirebaseMessaging.instance.getToken().then((fcmToken) =>
            FirebaseFirestore.instance
                .collection("users")
                .doc(auth.currentUser!.uid)
                .update({"fcmToken": fcmToken}));
        userModel.userID = auth.currentUser!.uid;
        verifyController.clear();
        resetTextFields();
        onClick.value = false;
        Get.off(() => Preference1());
      });
    }).onError((error, stackTrace) async {
      // Handle errors during data insertion
      print(error.toString());
      await auth.currentUser!.delete();
      Get.back();
      loadingDialog(
          message: "There was a problem!\nPlease try again later",
          button: true);
    });
  }

  // Function to retrieve the user's FCM token
  Future<String> getUserDeviceToken() async {
    try {
      return await messaging.getToken() ?? '';
    } catch (e) {
      print('Error getting user device token $e');
      return '';
    }
  }

  // Function to update specific user data fields in Firestore
  updateUserData({field, entry}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .update({field: entry});
      getCurrentUserData();
    } catch (e) {
      print('Error $e');
    }
  }
}
