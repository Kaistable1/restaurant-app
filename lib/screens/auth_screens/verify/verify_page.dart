import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:pinput/pinput.dart';
import '../../../constants/app_colors.dart';
import '../../../dialoges/reset_dialog.dart';
import '../../../utils/validations.dart';
import '../../../widgets/custom_button.dart';
import 'controller/verify_controller.dart';

class VerifyPage extends StatelessWidget {
  VerifyPage({super.key, required this.email});

  final controller = Get.put(VerifyController());
  final signupController = Get.put(SignupController());

  String email;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Image.asset(
                          'assets/images/arrow_back.png',
                          height: 74,
                          width: 50,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/botomsheet_logo.png',
                      height: 74,
                      width: 196,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              SizedBox(
                height: 53,
              ),
              Text(
                'Verify Email',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Sans',
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                'Enter the 6 digit code we have sent to ${signupController.userModel.userEmail.text}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Nunito-Sans',
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Pinput(
                  keyboardType: TextInputType.phone,
                  animationCurve: Curves.bounceOut,
                  errorTextStyle: const TextStyle(color: Colors.red),
                  length: 6,
                  controller: controller.verifyController,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  validator: (val) {
                    return isPinputValid(val!);
                  },
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  closeKeyboardWhenCompleted: true,
                  defaultPinTheme: PinTheme(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito-Sans',
                      color: AppColors.darkGrey,
                    ),
                    width: 50,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Nunito-Sans',
                      color: Colors.red,
                    ),
                    width: 52,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: CustomButton(
                  laBelText: 'Verify code',
                  width: 200,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito-Sans',
                  textColor: Colors.white,
                  ontapp: () async {
                    controller.onClick.value = !controller.onClick.value;
                    String enteredCode =
                        controller.verifyController.text.trim();
                    if (_formKey.currentState!.validate()) {
                      if (enteredCode.isEmpty ||
                          !RegExp(r'^[0-9]+$').hasMatch(enteredCode)) {
                        controller.onClick.value = false;
                      } else if (enteredCode.length == 6) {
                        if (controller.verifyController.length == 6 &&
                            controller.verifyController.text ==
                                signupController.verificationCode.toString()) {
                          await signupController.createAccount();

                          signupController.resetTextFields();
                          controller.onClick.value = false;
                          controller.verifyController.clear();
                          Get.offAll(() => Preference1());
                        } else {
                          loadingDialog(
                              message:
                                  'The OTP you entered is incorrect. Please try again.',
                              button: true);
                        }
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 38,
              ),
              Center(
                child: Text(
                  'Haven’t received the code yet?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito-Sans',
                    color: AppColors.hintText,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await signupController.sendEmail(isFromResendOtp: true);

                    dialogueBox(
                        text:
                            'The code has been sent to your email address.\nCheck your Spam folder if you do not receive it.',
                        color: AppColors.primaryColor,
                        onPressed: () {
                          Get.back();
                        });
                  },
                  child: Text(
                    'Resend!',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Nunito-Sans',
                        color: AppColors.primaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
