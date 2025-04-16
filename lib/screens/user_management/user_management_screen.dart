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
  final UserController controller = Get.put(UserController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Add scroll listener to detect when user reaches the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          controller.hasMoreData.value &&
          !controller.isLoading.value) {
        controller.fetchUsers(); // Fetch more users when scrolled to bottom
      }
    });

    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;

    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 12 : 14;
    double tableHeaderTextSize = mobileView ? 16 : 20;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderWidget(title: 'User Management'),
          const SizedBox(height: 30),
          CustomTextField(
            controller: controller.searchController,
            hintText: 'Search by username',
            borderColor: primaryColor,
            hintTextColor: primaryColor,
            prefixIcon: Icon(Icons.search, color: primaryColor),
            onChanged: (value) {
              controller.currentSearchQuery.value = value ?? '';
              // No need to call fetchInitialUsers here; debounce handles it
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: dimWhite.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    color: primaryColor,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text("No.",
                                style: _headerStyle(tableHeaderTextSize))),
                        Expanded(
                            child: Text("Name",
                                style: _headerStyle(tableHeaderTextSize))),
                        Expanded(
                            child: Text("Email",
                                style: _headerStyle(tableHeaderTextSize))),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.userManagement.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      }
                      if (controller.userManagement.isEmpty &&
                          !controller.hasMoreData.value &&
                          !controller.isLoading.value) {
                        return Center(
                          child: Text(
                            controller.currentSearchQuery.value.isNotEmpty
                                ? 'No users found for "${controller.currentSearchQuery.value}"'
                                : 'No users available',
                            style: simpleText.copyWith(
                              fontSize: tableTextSize,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: controller.userManagement.length +
                            (controller.hasMoreData.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.userManagement.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: controller.isLoading.value
                                    ? CircularProgressIndicator(
                                        color: primaryColor,
                                      )
                                    : Text(
                                        'Load More',
                                        style: simpleText.copyWith(
                                          fontSize: tableTextSize,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          }
                          final user = controller.userManagement[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
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
                                    child: Text('${index + 1}',
                                        style: _textStyle(tableTextSize))),
                                Expanded(
                                    child: Text(user.username,
                                        style: _textStyle(tableTextSize))),
                                Expanded(
                                    child: Text(user.userEmail,
                                        style: _textStyle(tableTextSize))),
                                Center(
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          mobileView ? 5 : 10),
                                    ),
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.white, size: 20),
                                        onSelected: (value) {
                                          if (value == 'delete') {
                                            controller.deleteUser(user.userId);
                                          } else if (value == 'view') {
                                            drawerController.selectedUser(user);
                                            drawerController.userDetails.value =
                                                true;
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: 'view',
                                              child: Text('View')),
                                          const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle(double fontSize) => simpleText.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  TextStyle _textStyle(double fontSize) =>
      simpleText.copyWith(fontSize: fontSize);
}
