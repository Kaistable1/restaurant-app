import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/text_styles.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../../utils/validations.dart';
import '../../../widgets/button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/customheader_widget.dart';

class CreateNotificationScreen extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(NotificationController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreateNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    double paddingValue = mobileView ? 16 : 24;
    bool isLargeScreen = screenWidth > 1600;
    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderWidget(
                title: 'Create New Notifications',
                back: true,
                onBackTap: () {
                  drawerController.showCreateNotifications.value = false;
                },
              ),
              SizedBox(
                height: isMobile ? 16 : 32,
              ),

              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Title',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen
                          ? 24
                          : isMobile
                              ? 14
                              : 20),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 12.0,
                      right: isLargeScreen
                          ? 400
                          : isMobile
                              ? 12
                              : 280),
                  child: CustomTextField(
                    controller: controller.titleController,
                    validator: (value) => isTitle(value!),
                    // maxHeight: isMobile?30:48,
                    // maxWidth: isMobile?380:458,
                    borderRadius: isMobile ? 4 : 10,
                    hintText: 'Title',
                  )),

              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Description',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen
                          ? 24
                          : isMobile
                              ? 14
                              : 20),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 12.0,
                      right: isLargeScreen
                          ? 400
                          : isMobile
                              ? 12
                              : 280),
                  child: CustomTextField(
                    maxLines: 5,
                    controller: controller.descriptionController,
                    validator: (value) => isDescription(value!),
                    // maxHeight: isMobile?30:48,
                    // maxWidth: isMobile?380:458,
                    borderRadius: isMobile ? 4 : 10,
                    hintText: 'Description',
                  )),

              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child: Text('Upload Image',
              //     style: headingText.copyWith(
              //         fontSize: isLargeScreen?24:isMobile?14:20
              //     ),
              //   ),
              // ),
              // SizedBox(height: isMobile?8:12,),
              //
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child: Container(
              //     width:  size.width * 0.38,
              //     height: 150,
              //     decoration: BoxDecoration(
              //       color:Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black
              //               .withOpacity(0.1), // subtle shadow
              //           blurRadius: 8, // how soft the shadow is
              //           offset: Offset(
              //               0, 4), // horizontal & vertical offset
              //         ),
              //       ],
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: DottedBorder(
              //         dashPattern: const [7, 5],
              //         color: primaryColor,
              //         strokeWidth: 1,
              //         borderType: BorderType.RRect,
              //         radius: const Radius.circular(6),
              //         child: ClipRRect(
              //           borderRadius: const BorderRadius.all(Radius.circular(4)),
              //           child: InkWell(
              //             onTap: controller.pickImage,
              //             child: Obx(() {
              //               final image = kIsWeb
              //                   ? controller.selectedWebImage.value
              //                   : controller.selectedImage.value;
              //
              //               if (image == null) {
              //                 return Center(
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Image.asset(
              //                         'assets/images/upload_doc.png',
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                       const SizedBox(height: 16),
              //                        Text(
              //                         'Upload Image',
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           fontSize: isMobile?12:16,
              //                           fontFamily: GoogleFonts.nunitoSans().fontFamily,
              //                           fontWeight: FontWeight.w500,
              //                           color: Color(0xFF232931),
              //                         ),
              //                       ),
              //                       const SizedBox(height: 10),
              //                       Text(
              //                         'Upload a .png file only',
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           fontSize: isMobile?12:16,
              //                           fontFamily: GoogleFonts.nunitoSans().fontFamily,
              //                           fontWeight: FontWeight.w500,
              //                           color:primaryColor,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 );
              //               } else {
              //                 return Stack(
              //                   children: [
              //                     kIsWeb
              //                         ? Image.memory(image as Uint8List,
              //                         width:  size.width * 0.38, height: 150, fit: BoxFit.fill)
              //                         : Image.file(image as File,
              //                         width:  size.width * 0.38, height: 150, fit: BoxFit.fill),
              //                     Positioned(
              //                       top: 8,
              //                       right: 8,
              //                       child: GestureDetector(
              //                         onTap: controller.removeImage,
              //                         child: Container(
              //                           padding: const EdgeInsets.all(4.0),
              //                           decoration: BoxDecoration(
              //                             color: Colors.white,
              //                             borderRadius: BorderRadius.circular(50),
              //                             boxShadow: [
              //                               BoxShadow(
              //                                 color: Colors.black.withOpacity(0.2),
              //                                 blurRadius: 3,
              //                                 offset: Offset(0, 1),
              //                               ),
              //                             ],
              //                           ),
              //                           child: Icon(
              //                             Icons.delete,
              //                             color: Colors.red,
              //                             size: 18,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 );
              //               }
              //             }),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(
                height: isMobile ? 8 : 24,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CustomButton(
                      ontapp: () {
                        if (formKey.currentState!.validate()) {
                          drawerController.showCreateNotifications.value =
                              false;
                          drawerController.showNotifications.value = true;
                          // controller.titleController.clear();
                          // controller.descriptionController.clear();
                          controller.selectedImage.value = null;
                          controller.selectedWebImage.value = null;
                        }
                      },
                      height: 48,
                      width: 162,
                      laBelText: 'Specific Users',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CustomButton(
                      ontapp: () {
                        if (formKey.currentState!.validate()) {
                          controller.sendPushAllUsersNotification(
                              title: controller.titleController.text,
                              message: controller.descriptionController.text);
                        }
                      },
                      height: 48,
                      width: 162,
                      laBelText: 'Send All User',
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: isMobile ? 8 : 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
