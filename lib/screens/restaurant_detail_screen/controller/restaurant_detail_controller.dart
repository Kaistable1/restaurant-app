import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';
import '../../../main.dart';
import '../../../universal_models/discount_model.dart';

class RestaurantDetailController extends GetxController {
  ///backend
  var selectedIndexTab = ''.obs;
  // var selectedIndex = 0.obs;
  // void changeIndex(int index) {
  //   selectedIndexTab.value = index;
  // }

  var operatingHours = <String, OperatingHours>{}.obs;
  var isLoading = false.obs;
  // var discountModels = <DiscountModel>[].obs;
  // var discountModels2 = <DiscountModel>[].obs;
  var selectedIndex = 0.obs;
  var selectedCategory = Rxn<CategoryModel>(); // Observable category model

  void selectCategory(int index, CategoryModel category) {
    selectedIndex.value = index;
    selectedCategory.value = category;
  }

  @override
  void onInit() async {
    super.onInit();
    fetchOperatingHours();
    await fetchMenuData();
    await fetchMenuDataSpecial();
    if(menuItems.isNotEmpty){
      selectCategory(0, menuItems[0]);

    }
    if(menuItemsSpecial.isNotEmpty){
      selectCategory2(0, menuItemsSpecial[0]);

    }
  }

  ///getting Percentage Off data

  var menuItems =
      <CategoryModel>[].obs; // Define menuItems as an observable list
  Future<void> fetchMenuData() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .collection('MealMenu')
          .where('discountType', isEqualTo: 'Percentage Off')
          .get();
      print(snapshot.docs.length);
      print('ist');
      if (snapshot.docs.isNotEmpty) {
        List<CategoryModel> menuList = snapshot.docs
            .map((doc) =>
                DiscountModel.fromJson(doc.data() as Map<String, dynamic>).menu)
            .expand((menu) => menu) // Flattening the list of menus
            .toList();

        menuItems.value =
            menuList; // Assuming you have an observable list like RxList<CategoryModel>
      }
    } catch (e) {
      print("Error fetching menu data: $e");
    }
    finally{
      isLoading.value = false;
    }
  }

  ///getting Happy Hour Special data
  var menuItemsSpecial =
      <CategoryModel>[].obs; // Define menuItems as an observable list
  Future<void> fetchMenuDataSpecial() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .collection('MealMenu')
          .where('discountType', isEqualTo: 'Happy Hour Special ')
          .get();
      print(snapshot.docs.length);
      print('aefdjfd');
      if (snapshot.docs.isNotEmpty) {
        List<CategoryModel> menuList = snapshot.docs
            .map((doc) =>
                DiscountModel.fromJson(doc.data() as Map<String, dynamic>).menu)
            .expand((menu) => menu) // Flattening the list of menus
            .toList();

        menuItemsSpecial.value =
            menuList; // Assuming you have an observable list like RxList<CategoryModel>
      }
    } catch (e) {
      print("Error fetching menu data: $e");
    }
  }

  var selectedIndexTabSpecial = 0.obs;

  void changeIndexSpecial(int index) {
    selectedIndexSpecial.value = index;
  }

  void selectCategory2(int index, CategoryModel category) {
    selectedIndexSpecial.value = index;
    selectedCategorySpecial.value = category;
  }

  var selectedCategorySpecial =
      Rxn<CategoryModel>(); // Observable category model

  var selectedIndexSpecial = 0.obs;
  Future<void> fetchOperatingHours() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the operatingHours sub-collection
      QuerySnapshot snapshot = await firestore
          .collection('restaurants')
          .doc(userId)
          .collection('operatingHours')
          .get();

      Map<String, OperatingHours> fetchedData = {};

      for (var doc in snapshot.docs) {
        fetchedData[doc.id] =
            OperatingHours.fromMap(doc.data() as Map<String, dynamic>);
      }

      operatingHours.assignAll(fetchedData);
      operatingHours.refresh();
    } catch (e) {
      print("Error fetching operating hours: $e");
    } finally {
      isLoading(false);
    }
  }

  ///frontend
  ///get image from gallery
  String mediaType = '';
  Future<Uint8List?> getImage() async {
    // loadingDialog(message: 'Please wait ...',loading: true);
    try {
      var mediaData = await ImagePickerWeb.getImageInfo;

      String? mimeType = mime(Path.basename(mediaData!.fileName!));
      File mediaFile =
          File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

      if (mediaFile.name.isNotEmpty) {
        // Get.back();
        mediaType = 'image';
        return mediaData.data!;
      }
    } catch (e) {
      // Get.back();
      loadingDialog(
          message: 'Please select an image file (JPG or PNG format only)',
          button: true);
    }

    return null;
  }

  List<String> texts = [
    "Ut nobis quo. Laudantium sint tempore voluptas illo quibusdam similique officiis. Natus ea similique sed rerum repudiandae deserunt. Deleniti et velit nam ut qui voluptatem voluptate.",
    "Saepe explicabo non odit. Necessitatibus eius et rem alias. Ipsa reprehenderit debitis repellendus voluptas nesciunt. Ut maiores perspiciatis illo deserunt voluptatem. Voluptatem iste ea aut non dolores ea eum.",
    "Assumenda deleniti corporis exercitationem ut blanditiis id aut quo. Nisi cupiditate nihil velit. Beatae similique suscipit dolor neque ut.",
    "Assumenda deleniti corporis exercitationem ut blanditiis id aut quo. Nisi cupiditate nihil velit. Beatae similique suscipit dolor neque ut.",
  ];
  List top = ['Menu', 'About', 'Reviews'];
  RxBool isFavorite = false.obs;
  RxString selectedTop = 'Menu'.obs;

  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();
  ScrollController scrollController = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  ScrollController scrollController4 = ScrollController();
  final List<LocationListModel> circleItems = [
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '10% off',
    ),
    LocationListModel(
      timeText: '20:00 t0 21:00',
      persentText: '30% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '75% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '20% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '55% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '60% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '40% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '25% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '15% off',
    ),
  ];
  final List<LocationListModel> circleItems2 = [
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '10% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '50% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '30% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '40% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '50% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '60% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '70% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '25% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '15% off',
    ),
  ];
  final List<LocationListModel> circleItems3 = [
    LocationListModel(
      timeText: '15:00 to 15:00',
      persentText: '5% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '15% off',
    ),
    LocationListModel(
      timeText: '14:00 to 14:00',
      persentText: '20% off',
    ),
    LocationListModel(
      timeText: '17:00 to 17:00',
      persentText: '25% off',
    ),
    LocationListModel(
      timeText: '18:00 to 18:00',
      persentText: '30% off',
    ),
    LocationListModel(
      timeText: '20:00 to 21:00',
      persentText: '35% off',
    ),
    LocationListModel(
      timeText: '21:00 to 21:00',
      persentText: '40% off',
    ),
    LocationListModel(
      timeText: '14:00 to 14:00',
      persentText: '25% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '15% off',
    ),
  ];
  final List<LocationListModel> circleItems4 = [
    LocationListModel(
      timeText: '15:00 to 15:00',
      persentText: 'Deal 01',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: 'Deal 02',
    ),
    LocationListModel(
      timeText: '14:00 to 14:00',
      persentText: 'Deal 03',
    ),
  ];
  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollLeft2() {
    scrollController2.animateTo(
      scrollController2.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight2() {
    scrollController2.animateTo(
      scrollController2.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollLeft3() {
    scrollController3.animateTo(
      scrollController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollLeft4() {
    scrollController4.animateTo(
      scrollController4.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight3() {
    scrollController3.animateTo(
      scrollController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight4() {
    scrollController4.animateTo(
      scrollController4.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose(); // Dispose the controller when not in use
    super.onClose();
  }
}

class LocationListModel {
  final String timeText;
  final String persentText;
  LocationListModel({
    required this.timeText,
    required this.persentText,
  });
}
