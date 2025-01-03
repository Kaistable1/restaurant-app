import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../tabbar/tabbar_controller/tab_controller.dart';

class CustomTabBarWidget extends StatefulWidget {
  final List<String> tabs; // List of tab names
  final List<Widget> tabViews; // List of tab views
  final Color activeColor; // Selected tab text color
  final Color inactiveColor; // Unselected tab text color
  final Color backgroundColor;
  final double? width1; // Background color for the container

  const CustomTabBarWidget({
    Key? key,
    required this.tabs,
    required this.tabViews,
    this.activeColor = Colors.teal,
    this.inactiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.width1,
  }) : super(key: key);

  @override
  _CustomTabBarWidgetState createState() => _CustomTabBarWidgetState();
}

class _CustomTabBarWidgetState extends State<CustomTabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TabControllerModel tabControllerModel;

  @override
  void initState() {
    super.initState();
    tabControllerModel = Get.put(TabControllerModel());
    _tabController = TabController(length: widget.tabs.length, vsync: this);

    // Sync TabController with GetX selectedTabIndex
    tabControllerModel.selectedTabIndex.listen((index) {
      _tabController.animateTo(index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.width1 ?? 800,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.darkGrey.withOpacity(.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                )
              ],
            ),
            labelColor: widget.activeColor,
            dividerColor: Colors.transparent,
            unselectedLabelColor: widget.inactiveColor,
            onTap: (index) {
              tabControllerModel.setTabIndex(index); // Update GetX state
            },
            tabs: widget.tabs.map((tab) {
              return Container(
                width: 229,
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            // Use IndexedStack to keep the views in place without rebuilding
            return IndexedStack(
              index: tabControllerModel.selectedTabIndex.value,
              children: widget.tabViews,
            );
          }),
        ),
      ],
    );
  }
}
