import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/constants/app_colors.dart';

import '../../../constants/text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../auth/login/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap with Scaffold for better layout
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                "Savrly Data Entry App",
                textAlign: TextAlign.center,
                style: headingText,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Discover nearby restaurants and explore menus.",
                textAlign: TextAlign.center,
                style: simpleText,
              ),
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.height * 1,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: 50),
              CustomButton(
                  btnText: 'Explore',
                  onTap: () {
                    Get.to(() => LoginScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
