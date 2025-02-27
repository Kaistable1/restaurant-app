import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/about_app/about_app.dart';
import 'package:kaistable_website/screens/change_pass/changePassword_dialoge.dart';
import 'package:kaistable_website/screens/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/edit_profile/edit_profile_page.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> iconPaths = [
      'assets/images/change_pass.png',
      'assets/images/terms_condition-icon.png',
      'assets/images/privacy_img.png',
      'assets/images/about_img.png',
      'assets/images/contact_us_img.png',
    ];
    List<String> tilesNames = [
      'Change Password',
      'Terms and conditions',
      'Privacy policy',
      'About app',
      'Contact us',
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Container(
              width: Get.width,
              height: 67,
              decoration: const BoxDecoration(
                color: AppColors.bgColor,
              ),
              child: Row(
                children: [
                  Container(
                    width: Get.width * 0.13,
                    height: Get.width * 0.15,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: currentUserDataModel!
                              .value.userImage.value.isNotEmpty
                          ? Image.network(
                              currentUserDataModel!.value.userImage.value,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/edit_profile_image.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/edit_profile_image.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUserDataModel?.value.username.text ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bottomSheetColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Nunito-Bold',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentUserDataModel?.value.userEmail.text ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bottomSheetColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Nunito-Bold',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => EditProfilePage());
                      },
                      child: Container(
                        width: 100,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito-Bold',
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          //tiles section
          Expanded(
            child: ListView.builder(
              itemCount: tilesNames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle navigation based on the selected tile
                    switch (index) {
                      case 0:
                        changePasswordDialogBox();
                        break;
                      case 1:
                        Get.to(TermsAndCondition());
                        break;
                      case 2:
                        Get.to(PrivacyPolicy());
                        break;
                      case 3:
                        Get.to(const AboutApp());
                        break;
                      case 4:
                        Get.to(ContactUs());

                        break;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColors.whiteColor,
                      child: ListTile(
                        leading: Image.asset(
                          iconPaths[index],
                          height: 24,
                          width: 24,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          tilesNames[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.bottomSheetColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Nunito-Bold',
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
