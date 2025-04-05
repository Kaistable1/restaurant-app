import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../constants/app_colors.dart';
import '../../controllers/user_management_controller.dart';
import '../../widgets/custom_textfield.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsive padding logic
    double paddingValue = screenWidth < 900 ? 16 : 24;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Management', style: headingText),
          SizedBox(height: 40),
          CustomTextField(
            controller: controller.searchController,
            hintText: 'Search',
            borderColor: primaryColor,
            hintTextColor: primaryColor,
            prefixIcon: Icon(Icons.search, color: primaryColor),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: dimWhite.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      color: primaryColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "No.",
                              style: simpleText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Name",
                              style: simpleText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Email",
                              style: simpleText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),
                    // Table body
                    Obx(
                      () => Column(
                        children: List.generate(controller.users.length, (index) {
                          final user = controller.users[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: primaryColor, width: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('${user.id}', style: simpleText),
                                ),
                                Expanded(
                                  child: Text(user.name, style: simpleText),
                                ),
                                Expanded(
                                  child: Text(user.email, style: simpleText),
                                ),
                                Center(
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
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
                                          // Handle actions
                                        },
                                        itemBuilder:
                                            (context) => [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
