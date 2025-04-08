import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../constants/app_colors.dart';
import '../../controllers/drawer_controller.dart';
import '../../controllers/user_management_controller.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/customheader_widget.dart';

class UserManagementScreen extends StatelessWidget {
  UserManagementScreen({super.key});

  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;

    // Responsive padding logic
    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 12 : 14;
    double tableHeaderTextSize = mobileView ? 16 : 20;

    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderWidget(title: 'User  Management'),
          SizedBox(height: 30),
          CustomTextField(
            controller: controller.searchController,
            hintText: 'Search',
            borderColor: primaryColor,
            hintTextColor: primaryColor,
            prefixIcon: Icon(Icons.search, color: primaryColor),
          ),
          SizedBox(height: 30),
          Expanded(
            // 👈 This will allow scrollable body to take remaining space
            child: Container(
              decoration: BoxDecoration(
                color: dimWhite.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Fixed Header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    color: primaryColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "No.",
                            style: simpleText.copyWith(
                              fontSize: tableHeaderTextSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Name",
                            style: simpleText.copyWith(
                              fontSize: tableHeaderTextSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Email",
                            style: simpleText.copyWith(
                              fontSize: tableHeaderTextSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Scrollable Body
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          children: List.generate(controller.users.length, (
                            index,
                          ) {
                            final user = controller.users[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: primaryColor,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${user.id}',
                                      style: simpleText.copyWith(
                                        fontSize: tableTextSize,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      user.name,
                                      style: simpleText.copyWith(
                                        fontSize: tableTextSize,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      user.email,
                                      style: simpleText.copyWith(
                                        fontSize: tableTextSize,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          mobileView ? 5 : 10,
                                        ),
                                      ),
                                      child: Center(
                                        child: PopupMenuButton<String>(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'delete') {
                                              controller.deleteUser(index);
                                            } else if (value == 'view') {
                                              drawerController
                                                  .userDetails
                                                  .value = true;
                                            }
                                          },
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  value: 'view',
                                                  child: Text('View'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
