import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/about_app/about_app.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_cusiness_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_filter_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_new_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_recently_viewed_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_theme_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_trending_controller.dart';

import 'package:kaistable_website/screens/home_screen/location_pages/location_screen.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_view_all/location_view_all.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/widgets/custom_button.dart';

import '../../constants/app_colors.dart';
import '../../widgets/home_widgets/all_categories.dart';
import '../../widgets/home_widgets/filter_widget.dart';
import '../../widgets/rectangle_widget.dart';
import '../change_pass/changePassword_dialoge.dart';
import '../edit_profile/edit_profile_page.dart';
import 'home_controller/filter_selection_controller.dart';

class MyHomeScreen extends StatefulWidget {
  final String? countryName;

  const MyHomeScreen({super.key, this.countryName});

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final RxBool isTapped = false.obs;

  final RxBool showFilterOptions = false.obs;
  final List<String> imagePaths = [
    "assets/images/banner.png",
    "assets/images/banner.png",
    "assets/images/banner.png",
  ];

  List<String> countries = [
    "New York",
    "Los Angeles",
    "Paris",
  ];

  // Selected country

  final HomeLocationController controller = Get.put(HomeLocationController());
  final HomeThemeController themeController = Get.put(HomeThemeController());
  final FilterSelectionController filterSelectionController =
      Get.put(FilterSelectionController());
  final HomeRecentlyViewedController recentlyViewedController =
      Get.put(HomeRecentlyViewedController());
  final HomeCusinessController cusinessController =
      Get.put(HomeCusinessController());
  final HomeTrendingController trendingController =
      Get.put(HomeTrendingController());
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeFilterController filterController = Get.put(HomeFilterController());
  final scrollController = ScrollController();
  int _selectedIndex = 0; // Track the selected index
  Color decorationLineColor =
      Colors.transparent; // Default color for decoration line

  void _onItemTapped(int index, {isHome}) {
    setState(() {
      _selectedIndex = index; // Update selected index
      decorationLineColor = Theme.of(context).primaryColor;
      if (isHome) Get.back(); // Set decoration line color to primary
    });

    // Navigate to the corresponding screen based on the index
    switch (index) {
      case 0:
        Get.to(const MyHomeScreen());
        break;
      case 1:
        Get.to(FavoriteScreen());
        break;
      case 2:
        Get.to(EditProfilePage());
        break;
      case 3:
        changePasswordDialogBox();
        break;
      case 4:
        Get.to(const TermsAndCondition());
        break;
      case 5:
        Get.to(const PrivacyPolicy());
        break;
      case 6:
        Get.to(const AboutApp());
        break;
      case 7:
        Get.to(ContactUs(scrollcontroller: scrollController));
        break;
    }
  }

  String selectedCountry = 'Select Country';

  @override
  void initState() {
    super.initState();
    // Initialize the state with the passed country name
    selectedCountry = widget.countryName!;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          iconTheme: const IconThemeData(
            color: AppColors.primaryColor,
          ),
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
          actions: [
            const SizedBox(width: 20),
            _selectedIndex == 0 // Only show on the home screen
                ? Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(LocationScreen());
                        },
                        child: const Image(
                          image: AssetImage('assets/images/location_icon.png'),
                          height: 12,
                          width: 12,
                        ),
                      ),
                      const SizedBox(width: 1),
                      InkWell(
                        onTap: () {
                          Get.to(LocationScreen());
                        },
                        child: Text(
                          'USA.Los Vegas',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Nunito-Regular',
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/topbar_logo.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              _buildDrawerItem('Home', 0),
              _buildDrawerItem('Favorites', 1),
              _buildDrawerItem('Edit profile', 2),
              _buildDrawerItem('Change Password', 3),
              _buildDrawerItem('Terms and conditions', 4),
              _buildDrawerItem('Privacy policy', 5),
              _buildDrawerItem('About app', 6),
              _buildDrawerItem('Contact us', 7),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: CustomButton(
                  laBelText: 'Logout',
                  fontSize: 20,
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 43,
                  width: 200,
                  ontapp: () {
                    Get.offAll(() => LoginScreen());
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterWidget(),
              Obx(
                () => filterSelectionController.isFilterListVisible.value &&
                        filterSelectionController.aggregatedFilters.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore Restaurants',
                              style: TextStyle(
                                color: AppColors.bottomSheetColor,
                                fontFamily: 'aftika-regular',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Obx(() {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 220,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount:
                                    cusinessController.cusinessItem.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      cusinessController.cusinessItem[index];
                                  return RectangleWidget(
                                    title: item.title,
                                    description: item.description,
                                    imagePath: item.imagePath,
                                    timetext: item.timeText,
                                    percentText: item.percentText,
                                    endTimeText: item.endTimeText,
                                    isFavorite: false.obs,
                                  );
                                },
                              );
                            }),
                            SizedBox(height: 16,),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 18,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCountry,
                                  style: TextStyle(
                                    color: AppColors.bottomSheetColor,
                                    fontFamily: 'aftika-regular',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      Get.to(LocationViewAll());
                                    },
                                    child: Text(
                                      "view all",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColors.primaryColor,
                                          fontFamily: 'Nunito-Regular',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryColor),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                          AllCategories(),
                        ],
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDrawerItem(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              decoration: _selectedIndex == index
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationThickness: 1.5,
              decorationColor: AppColors.primaryColor,
              fontSize: 14,
              fontFamily: 'Nunito-Bold',
              color: _selectedIndex == index
                  ? AppColors.primaryColor
                  : AppColors.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () =>
              _onItemTapped(index, isHome: title == 'Home' ? true : false),
        ),
      ],
    );
  }
}
