import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../home_screen/home_controller/home_location_controller.dart';
import 'controller/favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  final controller = Get.put(FavoriteController());
  final HomeLocationController mycontroller = Get.put(HomeLocationController());

  FavoriteScreen({super.key, this.onNavigate}) {
    mycontroller.selectedTop.value='';
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold( backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          iconTheme: IconThemeData(
            color: AppColors.primaryColor,
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
                  Get.back();
                },
                child: Icon(Icons.arrow_back, size: 18),
              ),
            ),
          ),

          title: Text('Favorites',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 220,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
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
                            child: RectangleWidget(
                              onNavigate: onNavigate,
                              title: item.title,
                              description: item.description,
                              imagePath: item.imagePath,
                              timetext: item.timetext,
                              endTimeText: item.endTimeText,
                              percentText: item.percentText,
                              isFavorite: true.obs,

                            ),
                          );
                        },
                      );


                    }),
              SizedBox(height:  30 ),




                  ],
                ),
          ),
        ),
      ),
    );


  }
}
