import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/screens/auth_screens/verify/verify_page.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SignupController extends GetxController {
  var termsAndConditions = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  final verifyController = TextEditingController();

  var onClick = false.obs;
  var acceptTerms = false.obs;

  void resetTextFields() {
    userModel = UserModel.initialize();
  }

  ///userModel
  UserModel userModel = UserModel.initialize();

  int? verificationCode;
  Future<bool> checkIfEmailExists({String? email}) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .where('userEmail', isEqualTo: email)
        .get();
    print(doc.docs.isEmpty);
    return doc.docs.isEmpty;
  }

  ///Backend
  sendEmail({bool isFromResendOtp = false}) async {
    loadingDialog(
      message: "Sending email verification code!",
      loading: true,
      height: 170,
    );
    String username = 'emannoor5236@gmail.com';
    String password = 'aduo tgwi qsvu xfxd';
    verificationCode = 100000 + Random().nextInt(90000);
    if (verificationCode!.bitLength > 6) {
      verificationCode = 100000 + Random().nextInt(99999);
    }
    update();
    print("========== $verificationCode");
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, "SAVRLY")
      ..recipients.add(userModel.userEmail.text)
      ..subject = 'SAVRLY'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<p>$verificationCode is verification code for ${userModel.userEmail.text}</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      Get.back();
      if (isFromResendOtp == false) {
        Get.to(() => VerifyPage(
              email: userModel.userEmail.text,
            ));
      }
    } on MailerException catch (e) {
      Get.back();
      print('Message not sent. Error: $e');
      for (var problem in e.problems) {
        print('Problem: ${problem.code}: ${problem.msg}');
      }
      loadingDialog(message: "Failed to send verification code", button: true);
    }
  }

  ///create account function
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

        await insertData();
        Get.back();
      }).onError((error, stackTrace) {
        print(error.toString());
        if (error ==
            '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
          loadingDialog(
              message:
                  "The email you provided is already in use try with new email!",
              button: true);
        } else {
          loadingDialog(message: "Something went wrong !!!", button: true);
        }
        print('+++++');
        print('Error -------------------- $error');
      });
    } on FirebaseAuthException catch (error) {
      debugPrint("signUp ${error.code}");
      switch (error.code) {
        case "email-already-in-use":
          loadingDialog(
              message:
                  "The email you provided is already in use try with new email!",
              button: true);
          break;
      }
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  ///insert user
  insertData() async {
    var data = await userModel.toMap();
    final onbordingController = Get.put(OnboardingController());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .set(data)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid.toString())
          .update({
        'userID': auth.currentUser!.uid,
        'country': onbordingController.selectedCountry.value,
        'city': onbordingController.selectedCity.value,
        'token': await messaging.getToken() ?? '',
      }).then((value) {
        userModel.userID = auth.currentUser!.uid;
        verifyController.clear();
      });
    }).onError((error, stackTrace) async {
      print(error.toString());
      await auth.currentUser!.delete();
      Get.back();
      loadingDialog(
          message: "There was problem!\nPlease try again later", button: true);
    });
  }

  updateUserData({field, entry}) async {
    try {
      print('listing $entry');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .update({field: entry});
    } catch (e) {
      print('Error $e');
    }
  }
}
