import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/drawer_controller.dart';
import '../../controllers/sub_admins_controller.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';

class SubAdminScreens extends StatelessWidget {
  SubAdminScreens({super.key});

  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(SubAdminsController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    TextEditingController searchController = TextEditingController();
    // Responsive padding logic
    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 9 : 14;
    double buttonTextSize = mobileView ? 11 : 16;
    double tableHeaderTextSize = mobileView ? 12 : 20;
    double popUpContainerSize = mobileView ? 20 : 36;
    double popUpSize = mobileView ? 12 : 18;
    double titleTextSize = mobileView ? 24 : 32;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub Admins',
                style: headingText.copyWith(fontSize: titleTextSize),
              ),
              !mobileView
                  ? SizedBox(
                      width: screenWidth * 0.3,
                      child: CustomTextField(
                        controller: searchController,
                        hintText: 'Search',
                        borderColor: primaryColor,
                        onChanged: (v) {
                          controller.filteredSubAdmins(search: v);
                        },
                        hintTextColor: primaryColor,
                        prefixIcon: Icon(Icons.search, color: primaryColor),
                      ),
                    )
                  : SizedBox(),
              CustomButton(
                laBelText: 'Add Sub admin',
                isPrefixIcon: true,
                iconWidget: Icon(Icons.add_circle_outline_sharp, color: white),
                fontSize: buttonTextSize,
                width: mobileView ? 150 : 200,
                shadow: [],
                containerColor: primaryColor,
                ontapp: () {
                  controller.subAdminsModel = null;
                  controller.update();
                  drawerController.addSubAdmin.value = true;
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          mobileView
              ? CustomTextField(
                  controller: controller.searchController,
                  hintText: 'Search',
                  borderColor: primaryColor,
                  hintTextColor: primaryColor,
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                )
              : SizedBox(),
          SizedBox(height: mobileView ? 20 : 0),
          Expanded(
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
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Name",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Contact",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Passwords",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Status",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                  ),

                  // Scrollable rows
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            searchController.text.isEmpty
                                ? controller.subAdminsList.length
                                : controller.subAdminsFilteredList.length,
                            (index) {
                              final subAdmins =
                                  controller.subAdminsFilteredList.isEmpty
                                      ? controller.subAdminsList[index]
                                      : controller.subAdminsFilteredList[index];
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
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          subAdmins.name,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          subAdmins.contact,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          subAdmins.email,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          subAdmins.passwords,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          subAdmins.status,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                            color:
                                                subAdmins.status == "Inactive"
                                                    ? Colors.red
                                                    : primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: popUpContainerSize,
                                      width: popUpContainerSize,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
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
                                            size: popUpSize,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'delete') {
                                              controller.deleteSubAdmin(
                                                index,
                                                docID: subAdmins.docID,
                                              );
                                            } else if (value == 'edit') {
                                              controller.subAdminsModel =
                                                  subAdmins;
                                              controller.update();
                                              drawerController
                                                  .addSubAdmin.value = true;
                                            }
                                          },
                                          itemBuilder: (context) => [
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
                                  ],
                                ),
                              );
                            },
                          ),
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
