import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/widgets/button.dart';
import 'package:savrly/widgets/custom_textfield.dart';

import '../../constants/text_styles.dart';
import '../../utils/validations.dart';
import '../../controllers/contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ContactUsController controller = Get.put(ContactUsController());

  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isMobile ? 10 : 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Contact us',
                    style: headingText.copyWith(fontSize: isMobile ? 22 : 34),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 16 : 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Email',
                style: headingText.copyWith(
                  fontSize: isLargeScreen ? 24 : isMobile ? 14 : 20,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 12 : 18),
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: isLargeScreen ? 380 : isMobile ? 24 : 280.0,
              ),
              child: CustomTextField(
                controller: controller.emailController,
                validator: (value) => isEmailValid(value!),
                hintText: 'Admin@example.com',
              ),
            ),
            SizedBox(height: isMobile ? 12 : 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Phone number',
                style: headingText.copyWith(
                  fontSize: isLargeScreen ? 24 : isMobile ? 14 : 20,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 12 : 18),
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: isLargeScreen ? 380 : isMobile ? 24 : 280.0,
              ),
              child: CustomTextField(
                controller: controller.phoneController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) => isPhoneNumberValid(value!),
                hintText: '+713 34646464',
              ),
            ),
            SizedBox(height: isLargeScreen ? 28 : isMobile ? 14 : 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(
                ontapp: () async {
                  if (formKey.currentState!.validate()) {
                    await controller.saveContactUs(
                      controller.emailController.text,
                      controller.phoneController.text,
                    );
                  }
                },
                width: 162,
                height: 48,
                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                laBelText: controller.hasData.value ? 'Update' : 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
