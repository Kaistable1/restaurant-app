import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/screens/Videos/video_screen.dart';
import 'package:savrly/screens/dashboard/notification_screen/notifications_screen/notification_screen.dart';
import 'package:savrly/screens/events_managements/view_events/view_event.dart';

import '../../constants/app_colors.dart';
import '../about_app/about_app.dart';
import '../banner_management/add_banner/add_banner.dart';
import '../banner_management/banner_details/banner_details_screen.dart';
import '../banner_management/banner_management.dart';
import '../contact_us/contact_us_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../../controllers/drawer_controller.dart';
import '../dashboard/notification_screen/create_notification_screen.dart';
import '../dashboard/profile_screen/profile_screen.dart';
import '../drawer/drawer_screen.dart';
import '../events_managements/add_event/add_events.dart';
import '../events_managements/events_managements.dart';
import '../events_managements/view_events/widget/event_details_gallary.dart';
import '../restaurant_claims/cliams_details/restaurants_claims_details.dart';
import '../restaurant_claims/restaurants_claims_screen.dart';
import '../restaurant_management/add_retaurants/add_restaurants_screen.dart';
import '../restaurant_management/restaurant_management_screen.dart';
import '../restaurant_management/view_restaurant_details/view_restaurant_details.dart';
import '../sub_admin/add_sub_admin/add_sub_admin_screen.dart';
import '../user_management/user_details/user_details_screen.dart';
import '../user_management/user_management_screen.dart';
import '../privacy_policy/privacy_policy.dart';
import '../sub_admin/sub_admin_screens.dart';
import '../terms_and_conditions/terms_and_conditon.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DrawerControllerX controller = Get.put(DrawerControllerX());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: MediaQuery.of(context).size.width < 800
          ? AppBar(
              backgroundColor: bgColor,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: primaryColor),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: MediaQuery.of(context).size.width < 800 ? CustomDrawer() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width >= 800) CustomDrawer(),
          Expanded(child: Obx(() => _getScreen(controller))),
        ],
      ),
    );
  }

  Widget _getScreen(DrawerControllerX controller) {
    Widget screen;

    if (controller.userDetails.value) {
      screen = UserDetailsScreen();
    } else if (controller.showCreateNotifications.value) {
      screen = CreateNotificationScreen();
    } else if (controller.showProfile.value) {
      screen = ProfileScreen();
    } else if (controller.viewRestaurantsDetails.value) {
      screen = ViewRestaurantDetails();
    } else if (controller.addRestaurants.value) {
      screen = AddRestaurantsScreen();
    } else if (controller.addSubAdmin.value) {
      screen = AddSubAdminScreen();
    } else if (controller.addEvent.value) {
      screen = AddEvents();
    } else if (controller.viewEvents.value) {
      screen = ViewEvent();
    } else if (controller.viewEventsGallery.value) {
      screen = EventDetailsGallery();
    } else if (controller.showNotifications.value) {
      screen = NotificationScreen();
    } else if (controller.viewClaimsDetails.value) {
      screen = RestaurantsClaimsDetails();
    } else if (controller.viewBannerDetails.value) {
      screen = BannerDetailsScreen();
    } else if (controller.addBanner.value) {
      screen = AddBanner();
    } else {
      if (controller.selectedScreen.value == 0) {
        screen = DashboardScreen();
      } else if (controller.selectedScreen.value == 1) {
        screen = UserManagementScreen();
      } else if (controller.selectedScreen.value == 2) {
        screen = RestaurantManagementScreen();
      } else if (controller.selectedScreen.value == 3) {
        screen = EventsManagements();
      } else if (controller.selectedScreen.value == 4) {
        screen = RestaurantsClaimsScreen();
      } else if (controller.selectedScreen.value == 5) {
        screen = BannerManagement();
      } else if (controller.selectedScreen.value == 6) {
        screen = AdminVideoPanel();
      } else if (controller.selectedScreen.value == 7) {
        screen = SubAdminScreens();
      } else if (controller.selectedScreen.value == 8) {
        screen = PrivacyPolicy();
      } else if (controller.selectedScreen.value == 9) {
        screen = AboutApp();
      } else if (controller.selectedScreen.value == 10) {
        screen = TermsAndConditions();
      } else {
        screen = ContactUsScreen();
      }
    }
    return screen;
  }
}
