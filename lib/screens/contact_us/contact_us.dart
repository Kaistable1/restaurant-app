import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/contact_us/controller/contact_us_controller.dart';

import '../../constants/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ContactUs extends StatelessWidget {
  final RxBool _isDropdownOpen = false.obs;
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

  ContactUs({super.key});

  // Validation method
  void validateFields() {
    controller.dropdownError.value = controller.contactingUs.value!.isEmpty
        ? "Please select a reason for contacting us"
        : "";

    controller.emailError.value = controller.emailController.text.isEmpty
        ? "Please enter your email"
        : "";

    controller.messageError.value = controller.messagreController.text.isEmpty
        ? "Please enter a message"
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.isMobile(context) ? 300 : 677,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Add some spacing at the top
            Text(
              'Contact us',
              style: TextStyle(
                fontFamily: 'aftika-regular',
                fontWeight: FontWeight.w400,
                fontSize: Responsive.isMobile(context) ? 15 : 30,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 10 : 20),
            Text(
              'You have questions, we have answers - you can find the most frequently asked questions in our FAQ section. Can\'t find the answers you need? Send us an email or contact us via live chat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 : 14,
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
                    fontSize: Responsive.isMobile(context) ? 9 : 14,
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
                    fontSize: Responsive.isMobile(context) ? 9 : 14,
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
                        DropdownButton2<String>(
                          buttonStyleData: ButtonStyleData(

                              // padding: EdgeInsets.only(left: 22, right: 22),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Responsive.isMobile(context)? 4 :10),
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
                              elevation:0
                          ),
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                             // width: 200,
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10))),
                          hint: Text(
                            "Tell us why you're contacting us",
                            style: TextStyle(
                              color:  AppColors.textColor,
                              fontFamily: 'Nunito-Regular',
                              fontWeight: FontWeight.w400,
                              fontSize:  Responsive.isMobile(context) ? 7 : 14,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Image.asset(
                                _isDropdownOpen.value ?
                                'assets/images/aerrow_up.png' : // Image when dropdown is open
                                'assets/images/drop_down_img.png', // Path to your image asset
                                width: Responsive.isMobile(context) ? 6:12, // Adjust width of the image as per your requirement
                                height: Responsive.isMobile(context) ? 6: 12,
                              ),
                            ),
                          ),
                          underline: SizedBox(),
                          items: items.map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                color:  AppColors.textColor,
                                fontFamily: 'Nunito-Regular',
                                fontWeight: FontWeight.w400,
                                fontSize:  Responsive.isMobile(context) ? 7 : 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )).toList(),
                          value: controller.contactingUs.value, // Ensure this is valid
                          onChanged: (value) {
                            controller.contactingUs.value = value; // Update the dropdown value
                            controller.dropdownError.value = ""; // Clear any previous errors
                          },
                          // ... rest of your dropdown setup
                        )
,
                        if (controller.dropdownError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              controller.dropdownError.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: Responsive.isMobile(context) ? 7 : 12,
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
                          imgHeight: Responsive.isMobile(context) ? 8 : 11,
                          imgWidth: Responsive.isMobile(context) ? 9 : 14,
                          prefixImagePath: 'assets/images/email_icon_black.png',
                          height: Responsive.isMobile(context) ? 34 : 44,
                          hintText: 'Please enter your email',
                          controller: controller.emailController,
                          containerColor: AppColors.whiteColor,
                          fontfamily: 'Nunito-Regular',
                          hintfontsize: Responsive.isMobile(context) ? 7 : 14,
                          textColor: AppColors.textColor,
                        ),
                        // Validation message for email
                        if (controller.emailError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              controller.emailError.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: Responsive.isMobile(context) ? 7 : 12,
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
                          height: Responsive.isMobile(context) ? 70 : 89,
                          hintText: 'Message note',
                          controller: controller.messagreController,
                          containerColor: AppColors.whiteColor,
                          fontfamily: 'Nunito-Regular',
                          hintfontsize: Responsive.isMobile(context) ? 7 : 14,
                          textColor: AppColors.textColor,
                        ),
                        // Validation message for message
                        if (controller.messageError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              controller.messageError.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: Responsive.isMobile(context) ? 7 : 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  CustomButton(
                    height: Responsive.isMobile(context) ? 34 : 64,
                    laBelText: 'Send',
                    textColor: AppColors.whiteColor,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w500,
                    fontSize: Responsive.isMobile(context) ? 12 : 20,
                    ontapp: () {
                      validateFields(); // Call validateFields directly
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
