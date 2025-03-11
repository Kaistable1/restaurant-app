import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/constants/text_styles.dart';
import 'package:savrly_data_entry_app/screens/profile/controller/profile_controller.dart';
import 'package:savrly_data_entry_app/widgets/custom_button.dart';

import '../../widgets/logout_widget.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Log Out", style: headingText),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 20),
            // Obx(() => CircleAvatar(
            //       radius: 50,
            //       backgroundImage: AssetImage(controller.profileImage.value),
            //     )),
            // SizedBox(height: 10),
            // Obx(() => Text(
            //       controller.userName.value,
            //       style: headingText,
            //     )),
            // Obx(() => Text(
            //       controller.bio.value,
            //       style: hintText,
            //     )),
            // SizedBox(height: 20),
            // CustomButton(
            //     btnText: 'Edit Profile',
            //     btnTextStyle:
            //         headingText.copyWith(color: hintColor, fontSize: 18),
            //     btnColor: white,
            //     borderColor: white,
            //     onTap: () {}),
            // SizedBox(height: 10),
            // CustomButton(
            //     btnText: 'Privacy Policy',
            //     btnTextStyle:
            //         headingText.copyWith(color: hintColor, fontSize: 18),
            //     btnColor: white,
            //     borderColor: white,
            //     onTap: () {}),
            // SizedBox(height: 10),
            // CustomButton(
            //     btnText: 'About us',
            //     btnTextStyle:
            //         headingText.copyWith(color: hintColor, fontSize: 18),
            //     btnColor: white,
            //     borderColor: white,
            //     onTap: () {}),
            // SizedBox(height: 20),

            CustomButton(
                btnText: 'Logout',
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => logoutBottomSheet(context),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
