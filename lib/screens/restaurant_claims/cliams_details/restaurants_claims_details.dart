import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/models/claims_model.dart';
import 'package:savrly/widgets/button.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/restaurants_claims_controller.dart';
import '../../../utils/validations.dart';
import '../../../widgets/customheader_widget.dart';
import '../../../widgets/text_and_field_drop_down.dart';

class RestaurantsClaimsDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final controller = Get.put(RestaurantsClaimsController());
  final drawerController = Get.put(DrawerControllerX());
  RestaurantsClaimsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;
    // Define view breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;

    // Adjust padding based on view
    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);

    // Define container dimensions as a percentage of screen size

    double containerHeight =
        screenHeight * (isMobile ? 0.38 : (isTablet ? 0.38 : 0.4));
    RestaurantClaimsModel claimsModel = controller.viewClaimsDetails!;
    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeaderWidget(
                  title: 'Restaurant claim details',
                  back: true,
                  onBackTap: () {
                    drawerController.viewClaimsDetails.value = false;
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  width:
                      isLargeScreen ? 680 : 500, // Fixed width as per your code
                  height: isLargeScreen
                      ? 260
                      : containerHeight, // Height set using MediaQuery
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        isMobile ? 10 : (isTablet ? 10 : 10)),
                    image: DecorationImage(
                      image: NetworkImage(claimsModel.photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Add content inside the container if needed
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: Container(
                    width: isLargeScreen ? 680 : 500,
                    height: isLargeScreen
                        ? screenHeight * 0.12
                        : screenHeight * 0.15,
                    decoration: BoxDecoration(
                      color: dimWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 20),
                          child: Text(
                            'Restaurant information',
                            style: headingText.copyWith(
                              fontSize: isLargeScreen
                                  ? 24
                                  : (isMobile ? 14 : (isTablet ? 18 : 20)),
                              fontFamily: GoogleFonts.nunitoSans().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Restaurant name: ',
                                  style: headingText.copyWith(
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 12 : 14)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight
                                        .bold, // Example: Make "Event name" bold
                                  ),
                                ),
                                TextSpan(
                                  text: claimsModel.restaurantsName,
                                  style: headingText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 11 : 13)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    color:
                                        secondaryColor, // Example: Make the colon grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: Container(
                    width: isLargeScreen ? 680 : 500,
                    height: isLargeScreen
                        ? screenHeight * 0.28
                        : screenHeight * 0.42,
                    decoration: BoxDecoration(
                      color: dimWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 20),
                          child: Text(
                            'Ownership details',
                            style: headingText.copyWith(
                              fontSize: isLargeScreen
                                  ? 24
                                  : (isMobile ? 14 : (isTablet ? 18 : 20)),
                              fontFamily: GoogleFonts.nunitoSans().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Owner name: ',
                                  style: headingText.copyWith(
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 12 : 14)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight
                                        .bold, // Example: Make "Event name" bold
                                  ),
                                ),
                                TextSpan(
                                  text: claimsModel.ownerName,
                                  style: headingText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 11 : 13)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    color:
                                        secondaryColor, // Example: Make the colon grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Email: ',
                                  style: headingText.copyWith(
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 12 : 14)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight
                                        .bold, // Example: Make "Event name" bold
                                  ),
                                ),
                                TextSpan(
                                  text: claimsModel.email,
                                  style: headingText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 11 : 13)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    color:
                                        secondaryColor, // Example: Make the colon grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Message: ',
                                  style: headingText.copyWith(
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 12 : 14)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight
                                        .bold, // Example: Make "Event name" bold
                                  ),
                                ),
                                TextSpan(
                                  text: claimsModel.message,
                                  style: headingText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 11 : 13)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    color:
                                        secondaryColor, // Example: Make the colon grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Contact: ',
                                  style: headingText.copyWith(
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 12 : 14)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight
                                        .bold, // Example: Make "Event name" bold
                                  ),
                                ),
                                TextSpan(
                                  text: claimsModel.contact,
                                  style: headingText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isLargeScreen
                                        ? 16
                                        : (isMobile
                                            ? 10
                                            : (isTablet ? 11 : 13)),
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    color:
                                        secondaryColor, // Example: Make the colon grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: isLargeScreen ? 680 : 500,
                  child: TextAndFieldsOrDropDown(
                    labelText: 'Assign password',
                    fieldHintText: '1234',
                    fieldController: controller.passwordController,
                    isDropDown: false,
                    fieldValidator: (value) => isPasswordValid(value!),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: isLargeScreen ? 140 : 90.0),
                  child: CustomButton(
                      ontapp: () {
                        if (formKey.currentState!.validate()) {
                          Get.snackbar(
                              'Success!', "Restaurant approved successfully",
                              maxWidth: 400,
                              backgroundColor: primaryColor,
                              colorText: Colors.white);
                          controller.passwordController.clear();
                          drawerController.viewClaimsDetails.value = false;
                        }
                      },
                      width: 339,
                      laBelText: 'Approve'),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
