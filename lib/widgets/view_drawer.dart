import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';


class ViewDrawer extends StatelessWidget {
  const ViewDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<GlobalController>();

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Drawer(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 195),
                  // Center(
                  //   child: CircleAvatar(
                  //     radius: 66,
                  //     backgroundImage: controller.um == null ||
                  //         controller.um!.pic == ''
                  //         ? const AssetImage(
                  //       'assets/images/end_drawer_img.png',
                  //     )
                  //         : NetworkImage(controller.um!.pic) as ImageProvider,
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      "fff",
                      //style: subHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 35),
                          Container(
                            width: Get.width,
                            height: 0.5,
                            decoration: const BoxDecoration(
                              color: AppColors.navInactive,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Contact information',
                            style: TextStyle(
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "qqqq",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.navInactive),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Phone number',
                            style: TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "qqqq",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.navInactive),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "qqqq",
                            style:TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.navInactive),
                          ),
                        Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 32),
                                Text(
                                  'Number of traveler uploaded',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "qqqq"
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.navInactive),
                                ),
                              ]),

                          const SizedBox(height: 32),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
