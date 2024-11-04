import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/contact_us/controller/contact_us_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_screen.dart';


import '../../constants/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dropdown.dart';

class ContactUs extends StatelessWidget {
  final ScrollController scrollcontroller;
  final Function(int)? onNavigate;
  RxBool isDropdownOpen = false.obs;
  final List<String> items = [
    "Olivia Rhye",
    "Phoenix Baker",
    "Lana Steiner",
    "Demi Wilkinson",
    "Candice Wu",
    "Natali Craig",
    "Drew Cano"
  ];

  final ContactUsController controller = Get.put(ContactUsController());

  ContactUs({super.key, this.onNavigate, required this.scrollcontroller});

  // Validation method




  @override
  Widget build(BuildContext context) {
    controller.resetErrors();
    return WillPopScope(
      onWillPop: () async {
        controller.resetErrors(); // Clear any errors before popping the screen
        Get.offAll(MyHomeScreen()); // Navigate back to the home screen
        return false; // Prevent the default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.primaryColor, // Set your desired color for the drawer icon
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(MyHomeScreen()); // Navigate back to the home screen
                },
                child: Icon(Icons.arrow_back, size: 18),
              ),
            ),
          ),

          title: Text('Contact us',
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),),
        ),
        body: Center(
          child: Container(
            width: Responsive.isMobile(context) ? 300 : 677,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Add some spacing at the top
                SizedBox(height: Responsive.isMobile(context) ? 10 : 20),
                Text(
                  'You have questions, we have answers - you can find the most frequently asked questions in our FAQ section. Can\'t find the answers you need? Send us an email or contact us via live chat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context) ? 11 : 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/email_icon.png',
                      height: 11,
                      width: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'xyz@support.com',
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: Responsive.isMobile(context) ? 11 : 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Image.asset(
                      'assets/images/phone_icon.png',
                      height: 14,
                      width: 14,
                    ),
                    SizedBox(width: Responsive.isMobile(context) ? 4 : 6),
                    Text(
                      '648-393-3115',
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: Responsive.isMobile(context) ? 11 : 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Container(
                  width: 568,
                  child: Column(
                    children: [
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                buttonStyleData: ButtonStyleData(
                                  padding: EdgeInsets.only(left: 14),
                                  height: Responsive.isMobile(context) ? 44 : 44,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4 : 10),
                                    color: AppColors.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 3,
                                        blurRadius: 12,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  elevation: 0,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Image.asset(
                                      controller.isDropdownOpen.value
                                          ? 'assets/images/arrow_down_icon.png'
                                          : 'assets/images/aerrow.png',
                                      width: Responsive.isMobile(context) ? 20: 16,
                                      height: Responsive.isMobile(context) ? 20 : 16,
                                    ),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                 // maxHeight: 200,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                // Add null check here, fallback to null if contactingUs.value is null
                                value: (controller.contactingUs.value?.isEmpty ?? true) ? null : controller.contactingUs.value,

                                hint: Padding(
                                  padding: EdgeInsets.only(right: Responsive.isMobile(context) ? 0 : 14.0),
                                  child: Text(
                                    "Tell us why you're contacting us",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontFamily: 'Nunito-Regular',
                                      fontWeight: FontWeight.w400,
                                      fontSize: Responsive.isMobile(context) ? 12 : 14,
                                    ),
                                  ),
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return items.map((String item) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: Responsive.isMobile(context) ? 0 : 14.0, top: 12),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: AppColors.darkGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Responsive.isMobile(context) ? 12 : 14,
                                          fontFamily: 'Nunito-Regular',
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: items.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item,
                                          style: TextStyle(
                                            color: AppColors.darkGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: Responsive.isMobile(context) ? 12 : 14,
                                            fontFamily: 'Nunito-Regular',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (controller.contactingUs.value == item)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Icon(
                                              Icons.check,
                                              color: AppColors.primaryColor,
                                              size: Responsive.isMobile(context) ? 20 : 16,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),

                                // Modified onChanged to allow unselecting the selected value
                                onChanged: (String? newValue) {
                                  if (newValue == controller.contactingUs.value) {
                                    // If clicked again on the selected value, unselect it by setting to null or empty
                                    controller.contactingUs.value = ''; // Set to null or empty to unselect
                                  } else {
                                    controller.contactingUs.value = newValue ?? ''; // Set the new value
                                  }
                                  controller.dropdownError.value = ''; // Clear error when value changes
                                  controller.isDropdownOpen.value = false; // Close dropdown
                                },

                                onMenuStateChange: (bool isOpen) {
                                  controller.isDropdownOpen.value = isOpen;
                                },
                              ),
                            ),



                            if (controller.dropdownError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5,left: 14),
                                child: Text(
                                  controller.dropdownError.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: Responsive.isMobile(context) ? 10 : 12,
                                  ),
                                ),
                              ),




                          ],
                        ),
                      ),



                      SizedBox(height: 20),
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(

                              imgHeight: Responsive.isMobile(context) ? 2 : 11,
                              imgWidth: Responsive.isMobile(context) ? 2 : 14,
                              prefixImagePath: 'assets/images/email_icon_black.png',
                              height: Responsive.isMobile(context) ? 44 : 44,
                              hintText: 'Please enter your email',
                              controller: controller.emailController,
                              containerColor: AppColors.whiteColor,
                              fontfamily: 'Nunito-Regular',
                              hintfontsize: Responsive.isMobile(context) ? 12 : 14,
                              textColor: AppColors.textColor,
                            ),
                            // Validation message for email
                            if (controller.emailError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5,left: 14),
                                child: Text(
                                  controller.emailError.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: Responsive.isMobile(context) ? 10 : 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(

                              height: Responsive.isMobile(context) ? 90 : 89,
                              hintText: 'Message note',
                              topPadding: 2,
                              controller: controller.messagreController,
                              containerColor: AppColors.whiteColor,
                              fontfamily: 'Nunito-Regular',
                              hintfontsize: Responsive.isMobile(context) ? 12 : 14,
                              textColor: AppColors.textColor,
                            ),
                            // Validation message for message
                            if (controller.messageError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5,left: 14
                                ),
                                child: Text(
                                  controller.messageError.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: Responsive.isMobile(context) ? 10   : 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                      CustomButton(

                        height: Responsive.isMobile(context) ? 36 : 64,
                        laBelText: 'Send',
                        textColor: AppColors.whiteColor,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.isMobile(context) ? 14 : 20,
                        ontapp: () {
                          // Call validateFields to perform validation
                          controller.validateFields();

                          // Check if all the error messages are empty, meaning validation passed
                          if (controller.dropdownError.value.isEmpty &&
                              controller.emailError.value.isEmpty &&
                              controller.messageError.value.isEmpty) {

                            //
                            // FlutterToastr.show("Your message has been sent successfully!",
                            //     context, duration: 2, position:  FlutterToastr.bottom);

                            //Show a snackbar with a success message instead of navigating
                            Get.snackbar(
                              'Success',
                              'Your message has been sent successfully!',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: AppColors.primaryColor,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );

                            // Clear the text fields after showing the success message
                            controller.emailController.clear(); // Clear email field
                            controller.messagreController.clear(); // Clear message field
                            controller.contactingUs.value = ''; // Clear dropdown selection (if needed)

                          }
                        },
                      ),



                    ],
                  ),
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
