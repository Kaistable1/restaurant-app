import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../controllers/drawer_controller.dart';
import '../../models/discover_list_model.dart';
import '../../widgets/button.dart';
import '../../widgets/customheader_widget.dart';
import 'controller/add_dicover_list_controller.dart';

class DiscoveryListScreen extends StatelessWidget {
  DiscoveryListScreen({super.key});

  final addController = Get.put(AddDiscoverListController());
  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;

    // Responsive padding logic
    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 9 : 14;
    double buttonTextSize = mobileView ? 11 : 16;
    double tableHeaderTextSize = mobileView ? 12 : 20;
    double imageSize = mobileView ? 30 : 50;
    double popUpContainerSize = mobileView ? 20 : 36;
    double popUpSize = mobileView ? 12 : 18;

    // // Create ScrollController
    // final ScrollController scrollController = ScrollController();

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
            CustomHeaderWidget(
              title: 'Discover Lists',
              end: true,
              endWidget: CustomButton(
                laBelText: 'Add List',
                isPrefixIcon: true,
                iconWidget: Icon(Icons.add_circle_outline_sharp, color: white),
                fontSize: buttonTextSize,
                width: mobileView ? 150 : 200,
                shadow: [],
                containerColor: primaryColor,
                ontapp: () {
                  addController.selectedDiscoverListModel = null;
                  addController.clearForm();
                  addController.isEdit.value = false;
                  addController.update();
                  drawerController.addDiscoveryLists.value = true;
                },
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('discoverLists').snapshots(),
                builder: (context, asyncSnapshot) {

                  if(asyncSnapshot.connectionState == ConnectionState.waiting){
                    return Center(child: Container(height: 32, padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator(color: primaryColor),));
                  }

                  if(!asyncSnapshot.hasData || asyncSnapshot.data!.size == 0){
                    return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Text('No discovery lists available', style: TextStyle(fontSize: 20),),
                        ),
                    );
                  }

                  return ListView.builder(
                      itemCount: asyncSnapshot.data!.size,
                      padding: EdgeInsets.only(top: 16),
                      itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        addController.selectedDiscoverListModel = DiscoverListModel.fromDocumentSnapshot(asyncSnapshot.data!.docs[index]);
                        drawerController.addDiscoveryLists.value = true;
                      },
                      child: Container(
                        height: 176,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(1, 2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10),),
                              child: Container(
                                  height: 176,
                                  width: 124,
                                  color: Colors.grey.shade200,
                                  child: asyncSnapshot.data!.docs[index]['image'] == '' ?
                                     Center(child: Icon(Icons.image_not_supported, color: Colors.grey,),) :
                                  Image.network(asyncSnapshot.data!.docs[index]['image'], fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(asyncSnapshot.data!.docs[index]['name'],
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                    ),
                                  ),
                                  Text('By ${asyncSnapshot.data!.docs[index]['by']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                    ),
                                  ),
                                ]),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                                onTap: () async {
                                  final confirm =
                                      await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => Dialog(
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            16),
                                      ),
                                      backgroundColor:
                                      white, // Light lavender background
                                      child: Container(
                                        width: 391,
                                        height:
                                        391, // fixed width for web feel
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 24,
                                            vertical: 32),
                                        child: Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons
                                                  .warning_amber_rounded,
                                              color: Colors.red,
                                              size: 60,
                                            ),
                                            const SizedBox(
                                                height: 20),
                                            const Text(
                                              'Are you sure you want\nto delete this discover list?',
                                              textAlign: TextAlign
                                                  .center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                                color:
                                                Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 30),
                                            SizedBox(
                                              width:
                                              double.infinity,
                                              height: 48,
                                              child:
                                              ElevatedButton(
                                                style:
                                                ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                  primaryColor,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        6),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context,
                                                        true),
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      fontSize:
                                                      16,
                                                      color: Colors
                                                          .white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 12),
                                            SizedBox(
                                              width:
                                              double.infinity,
                                              height: 48,
                                              child:
                                              OutlinedButton(
                                                style:
                                                OutlinedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                  Colors
                                                      .transparent,
                                                  side: const BorderSide(
                                                      color: Colors
                                                          .grey),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        6),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context,
                                                        false),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize:
                                                      16,
                                                      color: Colors
                                                          .black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                  if (confirm == true) {
                                    if(asyncSnapshot.data!.docs[index]['image'] != ''){
                                      await FirebaseStorage.instance.refFromURL(asyncSnapshot.data!.docs[index]['image']).delete();
                                    }
                                    await asyncSnapshot.data!.docs[index].reference.delete();
                                  }
                                },
                                child: Icon(Icons.delete, size: 32, color: Colors.red,)),
                            SizedBox(width: 16),
                          ]),
                      ),
                    );
                  });
                }
              ),
            ),
      ]),
    );
  }
}
