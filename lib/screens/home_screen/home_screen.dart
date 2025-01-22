import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';

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
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 24 : 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomButton(
                      title: "Add Restaurant Details",
                      textStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: Responsive.isMobile(context) ? 16 : 24,
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
                ),
              ],
            ),
            SizedBox(height: 20),
            Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Container(
                        width: 625,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileRow('Resturant name:', 'Abc',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('Contact:', '(225) 555-0118',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow(
                                'Email:',
                                'jessica.hanson@example.com',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('City:', 'Viet Nam',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('Address:', 'Abc',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('Password:', 'xyz',
                                Responsive.isMobile(context)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: screenWidth * .46,
                        height: screenHeight * .5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage('assets/images/p1.png'),
                            fit: BoxFit
                                .cover, // Adjusts how the image fits inside the container
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        width: 625,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileRow('Resturant name:', 'Abc',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('Contact:', '(225) 555-0118',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow(
                                'Email:',
                                'jessica.hanson@example.com',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('City:', 'Viet Nam',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('Address:', 'Abc',
                                Responsive.isMobile(context)),
                            SizedBox(height: 10),
                            Divider(
                                thickness: 0.2, color: AppColors.primaryColor),
                            _buildProfileRow('Password:', 'xyz',
                                Responsive.isMobile(context)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: Get.width,
                        height: screenHeight * .5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage('assets/images/p1.png'),
                            fit: BoxFit
                                .cover, // Adjusts how the image fits inside the container
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
          SizedBox(width: 8),
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
