import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/restaurant_model.dart';

import '../../constants/app_colors.dart';
import '../../custom_widget/app_bar.dart';

class EventScreen extends StatelessWidget {

  RestaurantModel restModel;

  EventScreen({super.key, required this.restModel});

  RxInt tabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lakers Vs Mavericks',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Image.asset('assets/icons/car.png',
                                  height: 12,
                                  width: 12,
                                ),
                              ),
                              Text(
                                '   3.5 miles',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'PlusJakartaSans',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Restaurant',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/images/restaurant_detail_img1.png', height: 246, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/restaurant_detail_img2.png', height: (246 - 8)/2, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/restaurant_detail_img3.png', height: (246 - 8)/2, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      TabBar(
                        tabs: [
                          Tab(text: 'Venue'),
                          Tab(text: 'Details'),
                          Tab(text: 'Tickets'),
                          Tab(text: 'Videos'),
                        ],
                        onTap: (index){
                          tabIndex.value = index;
                        },
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                        tabAlignment: TabAlignment.fill,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                      // // Replaced TabBar with a row of buttons for navigation
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.white,
                      //         foregroundColor: Colors.green,
                      //         side: BorderSide(color: Colors.green),
                      //       ),
                      //       child: Text('Info'),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.white,
                      //         foregroundColor: Colors.grey,
                      //         side: BorderSide(color: Colors.grey),
                      //       ),
                      //       child: Text('Filter'),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.white,
                      //         foregroundColor: Colors.grey,
                      //         side: BorderSide(color: Colors.grey),
                      //       ),
                      //       child: Text('Map'),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.white,
                      //         foregroundColor: Colors.grey,
                      //         side: BorderSide(color: Colors.grey),
                      //       ),
                      //       child: Text('Videos'),
                      //     ),
                      //   ],
                      // ),
                      // Info Container
                      Obx(()=>
                      tabIndex.value == 0 ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.04)
                                  )
                              ),
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'PlusJakartaSans',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(color: AppColors.dividerColor),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Image.asset('assets/icons/location.png', height: 12, width: 12)),
                                const SizedBox(width: 8),
                                // Icon(Icons.location_on, color: Colors.green),
                                Text('304 Liverpool Blvd, Portsmouth, CA 30103',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PlusJakartaSans',
                                  ),),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: AppColors.dividerColor),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/icons/time.png', height: 12, width: 12),
                                ),
                                const SizedBox(width: 8),
                                // Icon(Icons.access_time, color: Colors.green),
                                Text('Open',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PlusJakartaSans',
                                    color: Colors.green,
                                  ),),
                                Text('        Closes 10PM',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PlusJakartaSans',
                                  ),),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: AppColors.dividerColor),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/icons/site.png', height: 12, width: 12),
                                ),
                                const SizedBox(width: 8),
                                // Icon(Icons.language, color: Colors.green),
                                Text('www.website.com',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PlusJakartaSans',
                                  ),),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: AppColors.dividerColor),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/icons/cuisine.png', height: 12, width: 12),
                                ),
                                const SizedBox(width: 8),
                                // Icon(Icons.restaurant_outlined, color: Colors.green),
                                Text('Cuisine',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PlusJakartaSans',
                                  ),),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: AppColors.dividerColor),
                          ],
                        ),
                      ) :
                      tabIndex.value == 1 ? SizedBox()
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 16),
                      //   child: Column(
                      //       children: [
                      //         InkWell(
                      //           onTap:(){},
                      //           child: Container(
                      //             padding: EdgeInsets.all(16),
                      //             child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                      //                 children: [
                      //                   Text(
                      //                     'Experiences',
                      //                     style: TextStyle(
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: 'PlusJakartaSans',
                      //                     ),
                      //                   ),
                      //                   Icon(Icons.chevron_right, size: 14)
                      //                 ]
                      //             ),
                      //           ),
                      //         ),
                      //         Divider(color: AppColors.dividerColor),
                      //         InkWell(
                      //           onTap:(){},
                      //           child: Container(
                      //             padding: EdgeInsets.all(16),
                      //             child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                      //                 children: [
                      //                   Text(
                      //                     'Vibes',
                      //                     style: TextStyle(
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: 'PlusJakartaSans',
                      //                     ),
                      //                   ),
                      //                   Icon(Icons.chevron_right, size: 14)
                      //                 ]
                      //             ),
                      //           ),
                      //         ),
                      //         Divider(color: AppColors.dividerColor),
                      //         InkWell(
                      //           onTap:(){},
                      //           child: Container(
                      //             padding: EdgeInsets.all(16),
                      //             child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                      //                 children: [
                      //                   Text(
                      //                     'Atmosphere',
                      //                     style: TextStyle(
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: 'PlusJakartaSans',
                      //                     ),
                      //                   ),
                      //                   Icon(Icons.chevron_right, size: 14)
                      //                 ]
                      //             ),
                      //           ),
                      //         ),
                      //         Divider(color: AppColors.dividerColor),
                      //         InkWell(
                      //           onTap:(){},
                      //           child: Container(
                      //             padding: EdgeInsets.all(16),
                      //             child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                      //                 children: [
                      //                   Text(
                      //                     'Facilities',
                      //                     style: TextStyle(
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: 'PlusJakartaSans',
                      //                     ),
                      //                   ),
                      //                   Icon(Icons.chevron_right, size: 14)
                      //                 ]
                      //             ),
                      //           ),
                      //         ),
                      //         Divider(color: AppColors.dividerColor),
                      //         const SizedBox(height: 16),
                      //         GestureDetector(
                      //           onTap: (){},
                      //           child: Container(
                      //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      //             decoration: BoxDecoration(
                      //               color: Colors.transparent,
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: Text('Reset', style: TextStyle(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w500,
                      //               fontFamily: 'PlusJakartaSans',
                      //               color: Colors.green,
                      //             ),),
                      //           ),
                      //         )
                      //       ]),
                      // )
                          :
                      tabIndex.value == 2 ? SizedBox()
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 16),
                      //   child: Column(
                      //       children: [
                      //         SizedBox(
                      //           height: 256,
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(10),
                      //             clipBehavior: Clip.hardEdge,
                      //             child: GoogleMap(
                      //               initialCameraPosition: const CameraPosition(
                      //                 target: LatLng(40.7128, -74.0060),
                      //                 zoom: 14,
                      //               ),
                      //               markers: {
                      //                 Marker(
                      //                   markerId: MarkerId('1'),
                      //                   position: LatLng(40.7128, -74.0060),
                      //                 )
                      //               },
                      //               zoomControlsEnabled: false,
                      //               myLocationEnabled: true,
                      //               myLocationButtonEnabled: false,
                      //               mapType: MapType.normal,
                      //               gestureRecognizers: {
                      //                 Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(height: 32),
                      //         Row(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Expanded(
                      //               child: Row(
                      //                 children: [
                      //                   Padding(
                      //                       padding: EdgeInsets.only(top: 2),
                      //                       child: Image.asset('assets/icons/location.png', height: 12, width: 12)),
                      //                   const SizedBox(width: 8),
                      //                   // Icon(Icons.location_on, color: Colors.green),
                      //                   Expanded(
                      //                     child: Text('304 Liverpool Blvd, Portsmouth, CA 30103',
                      //                       style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.w500,
                      //                         fontFamily: 'PlusJakartaSans',
                      //                       ),),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             const SizedBox(width: 24),
                      //             Text('3.5 km away',
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w500,
                      //                 fontFamily: 'PlusJakartaSans',
                      //                 color: Colors.grey[400],
                      //               ),),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 16),
                      //         Row(
                      //           children: [
                      //             Padding(
                      //               padding: EdgeInsets.only(top: 2),
                      //               child: Image.asset('assets/icons/time.png', height: 12, width: 12),
                      //             ),
                      //             const SizedBox(width: 8),
                      //             // Icon(Icons.access_time, color: Colors.green),
                      //             Text('6PM-9PM',
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w500,
                      //                 fontFamily: 'PlusJakartaSans',
                      //               ),),
                      //             Text('        Closed now',
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w500,
                      //                 fontFamily: 'PlusJakartaSans',
                      //                 color: Colors.red,
                      //               ),),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 32),
                      //         CustomButton(
                      //           laBelText: 'Get Directions',
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //           fontFamily: 'PlusJakartaSans',
                      //           textColor: Colors.white,
                      //           containerColor: AppColors.primaryColor,
                      //           height: 32,
                      //           radius: BorderRadius.circular(15),
                      //         ),
                      //         const SizedBox(height: 16),
                      //         CustomButton(
                      //           laBelText: 'Copy Address',
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //           fontFamily: 'PlusJakartaSans',
                      //           textColor: Colors.black,
                      //           containerColor: AppColors.secondaryColor.withOpacity(0.4),
                      //           height: 32,
                      //           radius: BorderRadius.circular(15),
                      //         ),
                      //       ]
                      //   ),
                      // )
                          :
                      tabIndex.value == 3 ? SizedBox()
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 16),
                      //   child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         GridView.builder(
                      //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 3,
                      //               crossAxisSpacing: 8,
                      //               childAspectRatio: 110/120,
                      //               mainAxisSpacing: 8,
                      //             ),
                      //             itemCount: 10,
                      //             shrinkWrap: true,
                      //             primary: false,
                      //             itemBuilder: (context, index){
                      //               return ClipRRect(
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   clipBehavior: Clip.hardEdge,
                      //                   child: Image.asset('assets/images/restaurant_detail_img2.png', /*height: (246 - 8)/2, width: (Get.width-24-24-8)/2,*/ fit: BoxFit.cover,));
                      //             })
                      //       ]),
                      // )
                          : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
