import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kaistable_website/constants/app_colors.dart';

import '../home_screen/my_home_screen.dart';
import '../../utils/responsive.dart';
import '../../widgets/fav_rectangle_widget.dart';
import 'controller/favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final ScrollController scrollcontroller;
  final controller = Get.put(FavoriteController());

  FavoriteScreen({super.key, required this.scrollcontroller, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: () async {
        // Clear any errors before popping the screen
        Get.offAll(MyHomeScreen()); // Navigate back to the home screen
        return false; // Prevent the default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.primaryColor, // Set your desired color for the drawer icon
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(MyHomeScreen()); // Navigate back to the home screen
                },
                child: Icon(Icons.arrow_back, size: 18),
              ),
            ),
          ),

          title: Text('Favorites',
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),),
        ),
        body: SingleChildScrollView(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   SizedBox(height:  30 ),
                  Obx(() {

                    return Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 293,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,      // Adjust this if needed for column spacing
                          mainAxisSpacing: 5,        // Reduced mainAxisSpacing to minimize row spacing
                        ),
                        itemCount: controller.favoriteItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.favoriteItems[index];
                          return InkWell(
                            onTap: () {
                              if (onNavigate != null) {
                                onNavigate!(8);
                              }
                            },
                            child: CustomRectangleWidget(
                              onNavigate: onNavigate,
                              title: item.title,
                              description: item.description,
                              imagePath: item.imagePath,
                              timetext: item.timetext,
                              percentText: item.percentText,
                              isFavorite: true.obs,

                            ),
                          );
                        },
                      )

                    );


                  })


                  ,

                ],
              ),
        ),
      ),
    );


  }
}
