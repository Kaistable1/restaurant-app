import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/main.dart';

import '../../utils/responsive.dart';
import '../../widgets/round_button.dart';
import '../add_restaurant/add_restaurant.dart';
import '../main_screen/mainscreen_controller/main_controller.dart';

class HomeScreen extends StatelessWidget {
  // final controller = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return _buildProfileView(context);
  }

  Widget _buildProfileView(BuildContext context) {
    final controller = Get.put(MainController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 24 : 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => (currentUserDataModel.value?.zipCode?.text ?? '')
                          .isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomButton(
                              title: "Add Restaurant Details",
                              textStyle: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize:
                                    Responsive.isMobile(context) ? 16 : 24,
                                fontWeight: FontWeight.w700,
                              ),
                              backgroundColor: AppColors.primaryColor,
                              borderRadius: 10,
                              width: Responsive.isMobile(context) ? 200 : 300,
                              onPressed: () {
                                Get.to(() => AddEditRestaurantScreen(
                                      isFromButtonClick: true,
                                    ));
                              },
                            ),
                          ],
                        )
                      : Container(),
                )
              ],
            ),
            const SizedBox(height: 20),
            Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Obx(
                        () => Container(
                          width: 625,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileRow(
                                  'Resturant name:',
                                  controller.restaurantModel.value.resName.text,
                                  Responsive.isMobile(context)),
                              const SizedBox(height: 10),
                              const Divider(
                                  thickness: 0.2,
                                  color: AppColors.primaryColor),
                              _buildProfileRow(
                                  'Contact:',
                                  controller
                                      .restaurantModel.value.phoneNumber.text,
                                  Responsive.isMobile(context)),
                              const SizedBox(height: 10),
                              const Divider(
                                  thickness: 0.2,
                                  color: AppColors.primaryColor),
                              _buildProfileRow(
                                  'Email:',
                                  controller
                                      .restaurantModel.value.resEmail.text,
                                  Responsive.isMobile(context)),
                              const SizedBox(height: 10),
                              const Divider(
                                  thickness: 0.2,
                                  color: AppColors.primaryColor),
                              _buildProfileRow(
                                  'City:',
                                  controller.restaurantModel.value.city.text,
                                  Responsive.isMobile(context)),
                              const SizedBox(height: 10),
                              const Divider(
                                  thickness: 0.2,
                                  color: AppColors.primaryColor),
                              _buildProfileRow(
                                  'Address:',
                                  controller.restaurantModel.value.address.text,
                                  Responsive.isMobile(context)),
                              const SizedBox(height: 10),
                              const Divider(
                                  thickness: 0.2,
                                  color: AppColors.primaryColor),
                              _buildProfileRow(
                                  'Password:',
                                  controller
                                      .restaurantModel.value.password.text,
                                  Responsive.isMobile(context)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(
                        () =>
                            controller.restaurantModel.value.logoImage.value !=
                                    ''
                                ? Container(
                                    width: screenWidth * .46,
                                    height: screenHeight * .5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          controller.restaurantModel.value
                                              .logoImage.value,
                                        ),
                                        fit: BoxFit
                                            .fitHeight, // Adjusts how the image fits inside the container
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Obx(
                        () {
                          return Container(
                            width: 625,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileRow(
                                    'Restaurant name:',
                                    controller
                                        .restaurantModel.value.resName.text,
                                    Responsive.isMobile(context)),
                                const SizedBox(height: 10),
                                const Divider(
                                    thickness: 0.2,
                                    color: AppColors.primaryColor),
                                _buildProfileRow(
                                    'Contact:',
                                    controller
                                        .restaurantModel.value.phoneNumber.text,
                                    Responsive.isMobile(context)),
                                const SizedBox(height: 10),
                                const Divider(
                                    thickness: 0.2,
                                    color: AppColors.primaryColor),
                                _buildProfileRow(
                                    'Email:',
                                    controller
                                        .restaurantModel.value.resEmail.text,
                                    Responsive.isMobile(context)),
                                const SizedBox(height: 10),
                                const Divider(
                                    thickness: 0.2,
                                    color: AppColors.primaryColor),
                                _buildProfileRow(
                                    'City:',
                                    controller.restaurantModel.value.city.text,
                                    Responsive.isMobile(context)),
                                const SizedBox(height: 10),
                                const Divider(
                                    thickness: 0.2,
                                    color: AppColors.primaryColor),
                                _buildProfileRow(
                                    'Address:',
                                    controller
                                        .restaurantModel.value.address.text,
                                    Responsive.isMobile(context)),
                                const SizedBox(height: 10),
                                const Divider(
                                    thickness: 0.2,
                                    color: AppColors.primaryColor),
                                _buildProfileRow(
                                    'Password:',
                                    controller
                                        .restaurantModel.value.password.text,
                                    Responsive.isMobile(context)),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => Container(
                          width: Get.width,
                          height: screenHeight * .5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                controller
                                    .restaurantModel.value.logoImage.value,
                              ),
                              fit: BoxFit
                                  .fitHeight, // Adjusts how the image fits inside the container
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 14 : 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 12 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
