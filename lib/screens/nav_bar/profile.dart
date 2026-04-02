import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/app_info/about_app/about_app.dart';
import 'package:kaistable_website/screens/app_info/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/app_info/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/screens/change_pass/changePassword_dialoge.dart';
import 'package:kaistable_website/screens/app_info/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/edit_profile/edit_profile_page.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/saved_Resturant.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  RxBool profileToggle = true.obs;

  @override
  Widget build(BuildContext context) {
    // List<String> iconPaths = [
    //   'assets/images/oui_app-saved-objects.png'
    //   'assets/images/change_pass.png',
    //   'assets/images/terms_condition-icon.png',
    //   'assets/images/terms_condition-icon.png',
    //   'assets/images/privacy_img.png',
    //   'assets/images/about_img.png',
    //   'assets/images/contact_us_img.png',
    //   'assets/images/privacy_img.png',
    // ];
    // List<String> tilesNames = [
    //   'Saved',
    //   'Change Password',
    //   'Change preferences',
    //   'Terms and conditions',
    //   'Privacy policy',
    //   'About app',
    //   'Contact us',
    //   'Delete Account'
    // ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => navbarController.jumpToTab(0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          auth.currentUser == null || currentUserDataModel == null
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
                          await auth.signOut();
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
                          await auth.signOut();
                          Get.offAll(() => SignupScreen());
                        },
                      ),
                    ],
                  ),
                )
              : Obx(
                  () => Container(
                    width: Get.width,
                    height: profileToggle.value ? 67 : 67,
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
                                fontSize: 16,
                                color: AppColors.bottomSheetColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Nunito-Bold',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentUserDataModel?.value.userEmail.text ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.bottomSheetColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Nunito-Bold',
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () async {
                              await Get.to(() => EditProfilePage());
                              profileToggle.toggle();
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
                                    fontSize: 16,
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  profileListTile(0, context,
                      'assets/images/oui_app-saved-objects.png', 'Saved'),
                  auth.currentUser == null || currentUserDataModel == null
                      ? const SizedBox()
                      : profileListTile(
                          1,
                          context,
                          'assets/images/change_pass.png',
                          'Change Password',
                        ),
                  auth.currentUser == null || currentUserDataModel == null
                      ? const SizedBox()
                      : profileListTile(
                          2,
                          context,
                          'assets/images/terms_condition-icon.png',
                          'Change preferences',
                        ),
                  profileListTile(
                    3,
                    context,
                    'assets/images/terms_condition-icon.png',
                    'Terms and conditions',
                  ),
                  profileListTile(
                    4,
                    context,
                    'assets/images/privacy_img.png',
                    'Privacy policy',
                  ),
                  profileListTile(
                    5,
                    context,
                    'assets/images/about_img.png',
                    'About app',
                  ),
                  profileListTile(
                    6,
                    context,
                    'assets/images/contact_us_img.png',
                    'Contact us',
                  ),
                  auth.currentUser == null || currentUserDataModel == null
                      ? const SizedBox()
                      : profileListTile(7, context,
                          'assets/images/privacy_img.png', 'Delete Account'),
                ],
              ),
            ),
          ),

          // //tiles section
          // Flexible(
          //   child: ListView.builder(
          //     itemCount: auth.currentUser == null
          //         ? tilesNames.length - 3 // Exclude Change Password, Change preferences, Delete Account
          //         : tilesNames.length,
          //     itemBuilder: (context, index) {
          //       int adjustedIndex = auth.currentUser == null
          //           ? (index == 0 ? 0 : index + 2) // Map index 0 to 0, others skip to 3+
          //           : index;
          //
          //       return profileListTile(adjustedIndex, context, iconPaths[adjustedIndex], tilesNames[adjustedIndex]);
          //     },
          //   ),
          // ),

          auth.currentUser == null || currentUserDataModel == null
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 75, right: 75, top: 4),
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

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

deleteAccountDialog(context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final user = auth.currentUser; // Save the user object
              final userId = user?.uid; // Save the UID before deletion

              if (user != null) {
                print(currentUserDataModel!.value.userEmail.text);
                print(currentUserDataModel!.value.password.text);

                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: currentUserDataModel!.value.userEmail.text,
                    password: currentUserDataModel!.value.password.text);

                // Delete the account from Firebase Auth
                await user.delete();
                print('User deleted from Auth: $userId');

                if (userId != null) {
                  // Delete the user document from Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .delete();
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('recentView')
                      .get()
                      .then((val) async {
                    if (val.size != 0) {
                      for (var doc in val.docs) {
                        await doc.reference.delete();
                      }
                    }
                  });
                  print('User document deleted from Firestore: $userId');
                }

                // Sign out the user
                await FirebaseAuth.instance.signOut();

                // Navigate to the Login screen
                Get.offAll(() => LoginScreen());
              }
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}

profileListTile(
    int adjustedIndex, BuildContext context, String iconPath, String tileName) {
  return GestureDetector(
    onTap: () {
      switch (adjustedIndex) {
        case 0:
          Get.to(() => SavedRestaurantsPage());
          break;
        case 1:
          changePasswordDialogBox();
          break;
        case 2:
          Get.to(Preference1(
            isComeFromSetting: true,
          ));
          break;
        case 3:
          Get.to(TermsAndCondition());
          break;
        case 4:
          Get.to(const PrivacyPolicy());
          break;
        case 5:
          Get.to(AboutApp());
          break;
        case 6:
          Get.to(ContactUs());
          break;
        case 7:
          deleteAccountDialog(context);
          // Get.to(()=>deleteAccountDialog(context));
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
            iconPath,
            height: 24,
            width: 24,
            color: AppColors.primaryColor,
          ),
          title: Text(
            tileName,
            style: TextStyle(
              fontSize: 18,
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
}
