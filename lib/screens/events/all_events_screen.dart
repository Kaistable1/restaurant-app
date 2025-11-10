import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/custom_widget/app_bar.dart';
import 'package:kaistable_website/models/restaurant_model.dart';
import 'package:kaistable_website/screens/events/all_events_controller.dart';
import 'package:kaistable_website/screens/events/event_screen.dart';
import 'package:kaistable_website/utils/loading.dart';

import '../../constants/app_colors.dart';
import '../../models/events.dart';
import '../../utils/firebase_datebase.dart';

class AllEventsScreen extends StatelessWidget {
  AllEventsScreen({super.key});

  AllEventsController controller = Get.put(AllEventsController());

  Widget _buildSearchBar() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                spreadRadius: 0,
                offset: Offset(0, 4),
              )
            ]),
        child: Row(
          children: [
            const Icon(Icons.search, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Events',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
                onSubmitted: (value) {
                  controller.searchToggle.toggle();
                },
                // onChanged: (query){
                //   controller.debounceSearch(query);
                // },
              ),
            ),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
                child: Obx(
              () => DropdownButton2<String>(
                buttonStyleData: ButtonStyleData(
                  width: 55,
                ),
                dropdownStyleData: DropdownStyleData(
                  width: 65,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
                hint: Text(
                  'miles',
                  style: const TextStyle(fontSize: 14),
                ),
                value: controller.selectedDistance.value == 0
                    ? 'All'
                    : controller.selectedDistance.value.toString() + ' mi',
                items: controller.distanceOptions
                    .map(
                      (ele) => DropdownMenuItem(
                        value: ele,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            ele,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val == 'All') {
                    controller.selectedDistance.value = 0;
                  } else {
                    controller.selectedDistance.value =
                        int.parse(val!.replaceAll(' mi', ''));
                  }
                  controller.searchToggle.toggle();
                },
              ),
            )),
            // GestureDetector(
            //   onTap: () {
            //     print('pressed');
            //   },
            //   child: const Icon(Icons.arrow_drop_down, size: 24),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 0, top: 4, right: 0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 16),
                            Text(
                              'Pick a City',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PlusJakartaSans',
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      // City selector
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: controller.cities.length,
                          itemBuilder: (context, index) {
                            final city = controller.cities[index];

                            return GestureDetector(
                              onTap: () {
                                controller.selectedCity.value = city['name']!;
                              },
                              child: Container(
                                width: 140,
                                margin: EdgeInsets.only(right: controller.cities.length == index+1 ? 0 : 16),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(city['image']!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      city['name']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'PlusJakartaSans',
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Obx(() {
                                      final isSelected =
                                          controller.selectedCity.value ==
                                              city['name'];
                                      return isSelected
                                          ? Container(
                                              width: 80,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade800,
                                                borderRadius:
                                                    BorderRadius.circular(1),
                                              ),
                                            )
                                          : SizedBox(height: 2);
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 32,
                              child: Obx(
                                () => ListView(
                                    scrollDirection:
                                        controller.selectedMenuItems.length == 0
                                            ? Axis.horizontal
                                            : Axis.horizontal,
                                    children: [
                                      Row(
                                        children: List.generate(
                                            controller.selectedMenuItems.length,
                                            (ind) {
                                          return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 32,
                                                  padding: EdgeInsets.only(
                                                      left: 12, right: 12),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF00B406),
                                                      borderRadius:
                                                          BorderRadius.circular(32),
                                                      border: Border.all(
                                                        color: AppColors.borderColor1,
                                                      )),
                                                  child: Center(
                                                    child: Text(
                                                      controller
                                                                      .selectedMenuItems[
                                                                  ind] ==
                                                              'Sports'
                                                          ? controller
                                                              .selectedMenuItems[ind]
                                                          : (controller
                                                                      .selectedMenuItems[
                                                                  ind] +
                                                              's'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily:
                                                              'PlusJakartaSans'),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                              ]);
                                        }),
                                      ),
                                      // Container(
                                      //   height: 32,
                                      //   padding: EdgeInsets.only(left: 12, right: 12),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.transparent,
                                      //     borderRadius: BorderRadius.circular(32),
                                      //     border: Border.all(
                                      //       color: AppColors.borderColor1,
                                      //     )
                                      //   ),
                                      //   child: Center(
                                      //     child: Text('Concerts', style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w500,
                                      //       fontFamily: 'PlusJakartaSans'
                                      //     ),),
                                      //   ),
                                      // ),
                                      // const SizedBox(width: 16),
                                      // Container(
                                      //   height: 32,
                                      //   padding: EdgeInsets.only(left: 12, right: 12),
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.transparent,
                                      //       borderRadius: BorderRadius.circular(32),
                                      //       border: Border.all(
                                      //         color: AppColors.borderColor1,
                                      //       )
                                      //   ),
                                      //   child: Center(
                                      //     child: Text('Sports', style: TextStyle(
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.w500,
                                      //         fontFamily: 'PlusJakartaSans'
                                      //     ),),
                                      //   ),
                                      // ),
                                      DropdownButtonHideUnderline(
                                        child: Obx(
                                          () => DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Events',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'PlusJakartaSans'),
                                            ),
                                            items: controller.menuItems
                                                .map((String item) {
                                              // Convert item to the format used in selectedMenuItems
                                              String checkValue = item != 'Sports'
                                                  ? item.replaceRange(item.length - 1,
                                                      item.length, '')
                                                  : item;
                                              bool isSelected = controller
                                                  .selectedMenuItems
                                                  .contains(checkValue);

                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          color: isSelected
                                                              ? Colors.green.shade800
                                                              : Colors.black,
                                                        ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(
                                                        Icons.check,
                                                        color: Colors.green.shade800,
                                                        size: 16,
                                                      ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            value:
                                                null, // controller.menuItem.value == '' ? null : controller.menuItem.value,
                                            onChanged: (value) {
                                              // controller.menuItem.value = value!;

                                              String newValue = value!;
                                              if (value != 'Sports') {
                                                newValue = value.replaceRange(
                                                    value.length - 1,
                                                    value.length,
                                                    '');
                                              }

                                              if (controller.selectedMenuItems
                                                  .contains(newValue)) {
                                                controller.selectedMenuItems
                                                    .remove(newValue);
                                              } else {
                                                controller.selectedMenuItems
                                                    .add(newValue);
                                              }
                                              // setState(() {
                                              //   selectedValue = value;
                                              // });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 32,
                                              width: 100,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: AppColors.borderColor1,
                                                ),
                                                color: Colors.transparent,
                                              ),
                                              elevation: 0,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.arrow_drop_down_sharp,
                                              ),
                                              iconSize: 16,
                                              iconEnabledColor: Colors.black,
                                              iconDisabledColor: Colors.grey,
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Colors.white,
                                              ),
                                              offset: const Offset(0, -4),
                                              scrollbarTheme: ScrollbarThemeData(
                                                radius: const Radius.circular(40),
                                                thickness:
                                                    MaterialStateProperty.all(6),
                                                thumbVisibility:
                                                    MaterialStateProperty.all(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Obx(() => Text(
                            //       controller.tabIndex.value == 0
                            //           ? 'Top Events for today'
                            //           : controller.tabIndex.value == 1
                            //               ? 'Top Events this week'
                            //               : 'Top Events for ${DateTime.now().year}',
                            //       style: TextStyle(
                            //           fontSize: 24,
                            //           fontWeight: FontWeight.w600,
                            //           fontFamily: 'PlusJakartaSans'),
                            //     )),
                            // const SizedBox(height: 8),
                            // Text(
                            //   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore',
                            //   style: TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w500,
                            //       fontFamily: 'PlusJakartaSans'),
                            // ),
                            // const SizedBox(height: 16),
                            TabBar(
                              tabs: [
                                Tab(text: 'Today'),
                                Tab(text: 'This week'),
                                Tab(text: '${DateTime.now().year}'),
                              ],
                              onTap: (index) {
                                controller.tabIndex.value = index;
                              },
                              labelColor: Colors.green,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.green,
                              tabAlignment: TabAlignment.fill,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PlusJakartaSans',
                              ),
                            ),
                            const SizedBox(height: 8),

                            Obx(
                              () {
                                // Observe selectedCity to trigger rebuild when city changes
                                var _ = controller.selectedCity.value;

                                return FutureBuilder<QuerySnapshot<Event>>(
                                    future:
                                        getEventsForYear(controller.selectedMenuItems)
                                            .withConverter(
                                                fromFirestore: (snapshot, _) =>
                                                    Event.fromMap(
                                                        snapshot.id,
                                                        snapshot.data() == null
                                                            ? {}
                                                            : snapshot.data()!),
                                                toFirestore: (event, _) =>
                                                    event.toMap())
                                            .get(),
                                    builder: (context, events) {
                                      if (events.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: SizedBox(
                                            height: 32,
                                            width: 32,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }

                                      if (!events.hasData) {
                                        return Center(
                                          child: Text('No events available'),
                                        );
                                      }

                                      DateTime dt = DateTime.now();
                                      DateTime weekStartDate =
                                          dt.subtract(Duration(days: dt.weekday - 1));
                                      DateTime weekEndDate =
                                          dt.add(Duration(days: 7 - dt.weekday));

                                      return Obx(
                                        () {
                                          if ((controller.searchToggle.value ||
                                                  !controller.searchToggle.value) &&
                                              controller.searchController.text ==
                                                  '') {
                                            controller.filteredEventsList = events
                                                .data!.docs
                                                .map((e) => e.data())
                                                .toList();
                                          } else {
                                            controller.filteredEventsList = events
                                                .data!.docs
                                                .where((ele) =>
                                                    (ele
                                                        .data()
                                                        .eventName
                                                        .toLowerCase()
                                                        .contains(controller
                                                            .searchController.text
                                                            .toLowerCase())) ||
                                                    (ele
                                                        .data()
                                                        .location
                                                        .toLowerCase()
                                                        .contains(controller
                                                            .searchController.text
                                                            .toLowerCase())))
                                                .map((e) => e.data())
                                                .toList();
                                          }

                                          if (controller.selectedDistance.value > 0 &&
                                              controller.currentPosition != null) {
                                            controller.filteredEventsList = controller
                                                .filteredEventsList
                                                .where((event) {
                                              double distanceInMeters =
                                                  Geolocator.distanceBetween(
                                                controller.currentPosition!.latitude,
                                                controller.currentPosition!.longitude,
                                                event.latitude,
                                                event.longitude,
                                              );
                                              double distanceInMiles = distanceInMeters /
                                                  1609.34; // Convert meters to miles
                                              print(distanceInMiles.toString() +
                                                  ' miles');
                                              return distanceInMiles <=
                                                  controller.selectedDistance.value;
                                            }).toList();
                                          }

                                          // Filter by selected city

                                          controller.filteredEventsList = controller
                                              .filteredEventsList
                                              .where((event) {
                                            print(
                                                'event city ${event.city.toLowerCase()}');
                                            print(
                                                'selected city ${controller.selectedCity.value.toLowerCase()}');

                                            return event.city.toLowerCase() ==
                                                controller.selectedCity.value
                                                    .toLowerCase();
                                          }).toList();

                                          List<Event> tabList = [];
                                          if (controller.tabIndex.value == 0) {
                                            tabList = controller.filteredEventsList
                                                .where((ele) =>
                                                    ele.date ==
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(dt))
                                                .toList();
                                          } else if (controller.tabIndex.value == 1) {
                                            tabList = controller.filteredEventsList
                                                .where((ele) =>
                                                    (ele.dtDate!
                                                        .isAfter(weekStartDate)) &&
                                                    (ele.dtDate!
                                                        .isBefore(weekEndDate)))
                                                .toList();
                                          } else {
                                            tabList = controller.filteredEventsList
                                                .where((ele) =>
                                                    (ele.dtDate!.year == dt.year))
                                                .toList();
                                          }

                                          return ListView.builder(
                                              padding: EdgeInsets.only(
                                                  bottom: 16, top: 16),
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: tabList.length,
                                              // tabIndex.value == 0 ? 2 : tabIndex.value == 1 ? 3 : 6,
                                              itemBuilder: (context, index) {
                                                RxBool bookmarked = false.obs;

                                                return Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        RestaurantModel? restModel = await FirebaseFirestore
                                                            .instance
                                                            .collection('restaurants')
                                                            .where('address',
                                                                isEqualTo:
                                                                    tabList[index]
                                                                        .location)
                                                            .withConverter(
                                                                fromFirestore: (snapshot,
                                                                        _) =>
                                                                    RestaurantModel
                                                                        .fromDocumentSnapshot(
                                                                            snapshot),
                                                                toFirestore:
                                                                    (RestaurantModel
                                                                                rest,
                                                                            _) =>
                                                                        rest.toMap())
                                                            .get()
                                                            .then((val) =>
                                                                val.docs.first.data());

                                                        if (restModel != null) {
                                                          Get.to(() => EventScreen(
                                                              restModel: restModel));
                                                        } else {
                                                          loadingDialog(
                                                              message:
                                                                  'Restaurant location for this event does not exist in database',
                                                              button: true);
                                                        }
                                                      },
                                                      child: Card(
                                                        elevation: 0,
                                                        color: Colors.white,
                                                        margin: const EdgeInsets.only(
                                                            right: 6),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(10),
                                                            bottomLeft:
                                                                Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      ClipRRect(
                                                                        clipBehavior:
                                                                            Clip.hardEdge,
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    10),
                                                                        child: tabList[
                                                                                    index]
                                                                                .imageUrls
                                                                                .isEmpty
                                                                            ? Image
                                                                                .asset(
                                                                                'assets/images/event_img5.png',
                                                                                width:
                                                                                    120,
                                                                                height:
                                                                                    150,
                                                                                fit: BoxFit
                                                                                    .cover,
                                                                              )
                                                                            : Image
                                                                                .network(
                                                                                tabList[index]
                                                                                    .imageUrls
                                                                                    .first,
                                                                                width:
                                                                                    120,
                                                                                height:
                                                                                    150,
                                                                                fit: BoxFit
                                                                                    .cover,
                                                                              ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width: 16),
                                                                      Expanded(
                                                                        child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment
                                                                                    .start,
                                                                            children: [
                                                                              Text(
                                                                                tabList[index]
                                                                                    .eventName,
                                                                                // 'Kaistable at Drews',
                                                                                style:
                                                                                    TextStyle(
                                                                                  fontSize:
                                                                                      24,
                                                                                  fontWeight:
                                                                                      FontWeight.w600,
                                                                                  fontFamily:
                                                                                      'PlusJakartaSans',
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Image.asset('assets/icons/location.png', height: 12, width: 12, color: Colors.grey),
                                                                                      const SizedBox(width: 6),
                                                                                      Expanded(
                                                                                          child: Text(
                                                                                        DateFormat("MMMM d'th' yyyy").format(tabList[index].createdAt).replaceFirst('th', (tabList[index].createdAt.day%10) == 1 ? 'st': (tabList[index].createdAt.day%10) == 2 ? 'nd' : (tabList[index].createdAt.day%10) == 3 ? 'rd' : 'th') + ', @ ' + tabList[index].location,
                                                                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'PlusJakartaSans', color: Colors.grey),
                                                                                      ))
                                                                                    ]),
                                                                              ),
                                                                              Container(
                                                                                height: 24,
                                                                                width: 72,
                                                                                // padding: EdgeInsets.only(left: 8, right: 8),
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: BorderRadius.circular(32),
                                                                                    border: Border.all(
                                                                                      color: AppColors.borderColor1,
                                                                                    )),
                                                                                child:
                                                                                    Column(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      tabList[index].eventType,
                                                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'PlusJakartaSans'),
                                                                                    ),
                                                                                    const SizedBox(height: 2),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      ),
                                                                    ]),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    bookmarked
                                                                        .toggle();
                                                                  },
                                                                  child: Obx(() => Icon(
                                                                      bookmarked.value
                                                                          ? Icons
                                                                              .bookmark
                                                                          : Icons
                                                                              .bookmark_border,
                                                                      size: 20,
                                                                      color: bookmarked
                                                                              .value
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .black)))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Divider(
                                                        color:
                                                            AppColors.dividerColor),
                                                    const SizedBox(height: 4),
                                                  ],
                                                );
                                              });
                                        },
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
