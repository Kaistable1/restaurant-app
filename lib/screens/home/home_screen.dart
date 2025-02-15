import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/constants/text_styles.dart';
import 'package:savrly_data_entry_app/widgets/custom_textfield.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align error to left
            children: [
              CustomTextField(
                hintText: 'Search for restaurants...',
                fillColor: white,
                borderRadius: 20,
                controller: controller.searchController,
                onChanged: (value) {
                  controller.errorMessage.value = ""; // Clear error when typing
                },
              ),
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    )
                  : SizedBox()), // Show error message if exists
              SizedBox(height: 20),
              Obx(() => Column(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Google Api",
                                style: btnTextCustom,
                              ),
                            ),
                          ),
                        ),
                        leading: Radio<String>(
                          value: "Option 1",
                          groupValue: controller.selectedOption.value,
                          onChanged: (value) {
                            controller.setSelected(value!);
                          },
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Yelp Api",
                                style: btnTextCustom,
                              ),
                            ),
                          ),
                        ),
                        leading: Radio<String>(
                          value: "Option 2",
                          groupValue: controller.selectedOption.value,
                          onChanged: (value) {
                            controller.setSelected(value!);
                          },
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Center(
                child: Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator() // Show loading when isLoading is true
                      : CustomButton(
                          btnText: 'Search',
                          onTap: () {
                            controller.search();
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
