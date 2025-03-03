import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/about_app/about_app.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/screens/change_pass/changePassword_dialoge.dart';
import 'package:kaistable_website/screens/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/edit_profile/edit_profile_page.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> iconPaths = [
      'assets/images/change_pass.png',
      'assets/images/terms_condition-icon.png',
      'assets/images/terms_condition-icon.png',
      'assets/images/privacy_img.png',
      'assets/images/about_img.png',
      'assets/images/contact_us_img.png',
    ];
    List<String> tilesNames = [
      'Change Password',
      'Change preferences',
      'Terms and conditions',
      'Privacy policy',
      'About app',
      'Contact us',
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
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
          auth.currentUser == null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        laBelText: 'Log in',
                        fontSize: 20,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 43,
                        width: Get.width * 0.3,
                        ontapp: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.offAll(() => LoginScreen());
                        },
                      ),
                      CustomButton(
                        laBelText: 'Register',
                        fontSize: 20,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 43,
                        width: Get.width * 0.3,
                        ontapp: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.offAll(() => SignupScreen());
                        },
                      ),
                    ],
                  ),
                )
              : Obx(
                  () => Container(
                    width: Get.width,
                    height: 67,
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: Get.width * 0.13,
                          height: Get.width * 0.13,
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
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
              itemCount: auth.currentUser == null
                  ? tilesNames.length - 2
                  : tilesNames.length,
              itemBuilder: (context, index) {
                // Adjust index if the first tile (Change Password) is hidden
                int adjustedIndex =
                    auth.currentUser == null ? index + 2 : index;

                return GestureDetector(
                  onTap: () {
                    switch (adjustedIndex) {
                      case 0:
                        changePasswordDialogBox();
                        break;
                      case 1:
                        Get.to(Preference1());
                        break;
                      case 2:
                        Get.to(TermsAndCondition());
                        break;
                      case 3:
                        Get.to(const PrivacyPolicy());
                        break;
                      case 4:
                        Get.to(AboutApp());
                        break;
                      case 5:
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
                          iconPaths[adjustedIndex],
                          height: 24,
                          width: 24,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          tilesNames[adjustedIndex],
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

          auth.currentUser == null
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 75),
                  child: CustomButton(
                    laBelText: 'Logout',
                    fontSize: 20,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 43,
                    width: 200,
                    ontapp: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(() => LoginScreen());
                    },
                  ),
                ),

          SizedBox(
            height: Get.height * 0.1,
          ),
        ],
      ),
    );
  }
}
