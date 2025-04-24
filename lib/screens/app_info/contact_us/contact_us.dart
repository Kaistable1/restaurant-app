import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/app_info/contact_us/controller/contact_us_controller.dart';
import 'package:restaurant_web_app/utils/responsive.dart';
import 'package:restaurant_web_app/widgets/button.dart';
import 'package:restaurant_web_app/widgets/button1.dart';

class ContactUs extends StatelessWidget {
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

  ContactUs({
    super.key,
    this.onNavigate,
  });

  // Validation method

  @override
  Widget build(BuildContext context) {
    controller.resetErrors();
    return WillPopScope(
      onWillPop: () async {
        controller.resetErrors(); // Clear any errors before popping the screen
        Get.back();
        ; // Navigate back to the home screen
        return false; // Prevent the default back navigation
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          iconTheme: const IconThemeData(
            color: AppColors
                .primaryColor, // Set your desired color for the drawer icon
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,

          title: const Text(
            'Contact us',
            style: TextStyle(
              fontSize: 17,
              color: AppColors.botomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Add some spacing at the top
              SizedBox(height: Responsive.isMobile(context) ? 10 : 20),
              Padding(
                padding: const EdgeInsets.only(left: 19.0, right: 19),
                child: Text(
                  'You have questions, we have answers - you can find the most frequently asked questions in our FAQ section.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context) ? 11 : 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 19.0, right: 17),
                child: Text(
                  'Can\'t find the answers you need in the faq section? Send us an email now or contact us via live chat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context) ? 11 : 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/email_img.png",
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Nunito-Regulr",
                              fontWeight: FontWeight.w600,
                              color: AppColors.botomSheetColor),
                        ),
                        Text(
                          "Support@example.com",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito-Regular",
                              color: AppColors.botomSheetColor,
                              fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: const Color(0xFF98A2B34D).withOpacity(.2),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/phone_img.png",
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone number",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Nunito-Regular",
                              fontWeight: FontWeight.w600,
                              color: AppColors.botomSheetColor),
                        ),
                        Text(
                          "(704) 555-0127",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito-Regular",
                              color: AppColors.botomSheetColor,
                              fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: 568,
                child: Column(
                  children: [
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16),
                            child: Text(
                              "Reason",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Nunito-Regular",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.botomSheetColor),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                buttonStyleData: ButtonStyleData(
                                  padding: const EdgeInsets.only(left: 14),
                                  height:
                                      Responsive.isMobile(context) ? 44 : 44,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Responsive.isMobile(context) ? 10 : 10),
                                    color: AppColors.whiteColor,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     spreadRadius: 3,
                                    //     blurRadius: 12,
                                    //     offset: const Offset(0, 1),
                                    //   ),
                                    // ],
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
                                      width: Responsive.isMobile(context)
                                          ? 20
                                          : 16,
                                      height: Responsive.isMobile(context)
                                          ? 20
                                          : 16,
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
                                value:
                                    (controller.contactingUs.value?.isEmpty ??
                                            true)
                                        ? null
                                        : controller.contactingUs.value,

                                hint: Padding(
                                  padding: EdgeInsets.only(
                                      right: Responsive.isMobile(context)
                                          ? 0
                                          : 14.0),
                                  child: Text(
                                    "Tell us why you're contacting us",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontFamily: 'Nunito-Regular',
                                      fontWeight: FontWeight.w500,
                                      fontSize: Responsive.isMobile(context)
                                          ? 14
                                          : 14,
                                    ),
                                  ),
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return items.map((String item) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          right: Responsive.isMobile(context)
                                              ? 0
                                              : 14.0,
                                          top: 12),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: AppColors.darkGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Responsive.isMobile(context)
                                              ? 14
                                              : 14,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item,
                                          style: TextStyle(
                                            color: AppColors.darkGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                Responsive.isMobile(context)
                                                    ? 16
                                                    : 14,
                                            fontFamily: 'Nunito-Regular',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (controller.contactingUs.value ==
                                            item)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Icon(
                                              Icons.check,
                                              color: AppColors.primaryColor,
                                              size: Responsive.isMobile(context)
                                                  ? 20
                                                  : 16,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),

                                // Modified onChanged to allow unselecting the selected value
                                onChanged: (String? newValue) {
                                  if (newValue ==
                                      controller.contactingUs.value) {
                                    // If clicked again on the selected value, unselect it by setting to null or empty
                                    controller.contactingUs.value =
                                        ''; // Set to null or empty to unselect
                                  } else {
                                    controller.contactingUs.value =
                                        newValue ?? ''; // Set the new value
                                  }
                                  controller.dropdownError.value =
                                      ''; // Clear error when value changes
                                  controller.isDropdownOpen.value =
                                      false; // Close dropdown
                                },

                                onMenuStateChange: (bool isOpen) {
                                  controller.isDropdownOpen.value = isOpen;
                                },
                              ),
                            ),
                          ),
                          if (controller.dropdownError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 16),
                              child: Text(
                                controller.dropdownError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize:
                                      Responsive.isMobile(context) ? 10 : 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Nunito-Regular",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.botomSheetColor),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: CustomTextField(
                              hintText: 'Deanna.Curtis@Example.com',
                              controller: controller.emailController,
                            ),
                          ),
                          // Validation message for email
                          if (controller.emailError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 16),
                              child: Text(
                                controller.emailError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize:
                                      Responsive.isMobile(context) ? 10 : 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16),
                            child: Text(
                              "Note",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Nunito-Regular",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.botomSheetColor),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: CustomTextField(
                              hintText: 'Message note',
                              controller: controller.messagreController,
                            ),
                          ),
                          // Validation message for message
                          if (controller.messageError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 16),
                              child: Text(
                                controller.messageError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize:
                                      Responsive.isMobile(context) ? 10 : 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      width: 200,
                      radius: BorderRadius.circular(10),
                      height: Responsive.isMobile(context) ? 48 : 64,
                      laBelText: 'Submit',
                      textColor: AppColors.whiteColor,
                      fontFamily: 'Nunito-Regular',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.isMobile(context) ? 20 : 20,
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
                            duration: const Duration(seconds: 3),
                          );

                          // Clear the text fields after showing the success message
                          controller.emailController
                              .clear(); // Clear email field
                          controller.messagreController
                              .clear(); // Clear message field
                          controller.contactingUs.value =
                              ''; // Clear dropdown selection (if needed)
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
