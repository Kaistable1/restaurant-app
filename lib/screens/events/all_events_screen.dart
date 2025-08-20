import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/custom_widget/app_bar.dart';
import 'package:kaistable_website/screens/events/event_screen.dart';

import '../../constants/app_colors.dart';

class AllEventsScreen extends StatelessWidget {
  AllEventsScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  List<String> menuItems = [
    'Day Parties',
    'Pool Parties',
    'Pop-ups',
    'Festivals',
  ];
  RxString menuItem = ''.obs;

  RxInt tabIndex = 0.obs;

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
            ]
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Events',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.arrow_drop_down, size: 24),
            ),
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
                padding: const EdgeInsets.only(left: 24, top: 4, right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          height: 32,
                          padding: EdgeInsets.only(left: 12, right: 12),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppColors.borderColor1,
                            )
                          ),
                          child: Center(
                            child: Text('Concerts', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PlusJakartaSans'
                            ),),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 32,
                          padding: EdgeInsets.only(left: 12, right: 12),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: AppColors.borderColor1,
                              )
                          ),
                          child: Center(
                            child: Text('Sports', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PlusJakartaSans'
                            ),),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          ()=> DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Events',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PlusJakartaSans'
                                ),
                              ),
                              items: menuItems
                                  .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'PlusJakartaSans',
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                                  .toList(),
                              value: menuItem.value == '' ? null : menuItem.value,
                              onChanged: (value) {
                                menuItem.value = value!;
                                // setState(() {
                                //   selectedValue = value;
                                // });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 32,
                                width: 100,
                                padding: const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
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
                                iconSize: 14,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                offset: const Offset(-20, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: MaterialStateProperty.all(6),
                                  thumbVisibility: MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                    const SizedBox(height: 16),
                    Text('Top Events for today',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PlusJakartaSans'
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PlusJakartaSans'
                ),
              ),
                    const SizedBox(height: 16),
                    TabBar(
                      tabs: [
                        Tab(text: 'Today'),
                        Tab(text: 'This week'),
                        Tab(text: 'This month'),
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
                    const SizedBox(height: 8),
                    Obx(
                        ()=> ListView.builder(
                        padding: EdgeInsets.only(bottom: 16, top: 16),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: tabIndex.value == 0 ? 2 : tabIndex.value == 1 ? 3 : 6,
                          itemBuilder: (context, index){
              
                          RxBool bookmarked = false.obs;
              
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=> EventScreen());
                                },
                                child: Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(right: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 84,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                clipBehavior: Clip.hardEdge,
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.asset(
                                                  'assets/images/event_img5.png',
                                                  width: 68,
                                                  height: 84,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                  Text(
                                                    'Kaistable at Drews',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'PlusJakartaSans',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset('assets/icons/location.png', height: 12, width: 12, color: Colors.grey),
                                                          const SizedBox(width: 6),
                                                          Expanded(child: Text('Lorem ipsum dolor sit amet, consectetur.', style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'PlusJakartaSans',
                                                            color: Colors.grey
                                                          ),))
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
                                                        )
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Sports', style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'PlusJakartaSans'
                                                        ),),
                                                        const SizedBox(height: 2),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ]
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        GestureDetector(
                                            onTap: (){
                                              bookmarked.toggle();
                                            },
                                            child: Obx(()=> Icon(bookmarked.value ? Icons.bookmark : Icons.bookmark_border, size: 20, color: bookmarked.value ? Colors.green : Colors.black)))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: AppColors.dividerColor),
                              const SizedBox(height: 16),
                            ],
                          );
                          }),
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
