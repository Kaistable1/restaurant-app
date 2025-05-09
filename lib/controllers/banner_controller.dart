import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/models/banner_model.dart';
import 'package:savrly/widgets/global_functions.dart';

class BannerController extends GetxController {
  RxBool isFromEdit = false.obs;
  final searchController = TextEditingController();
  final titleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  RxBool hasMoreData = true.obs;
  RxBool isLoading = false.obs;
  RxString currentSearchQuery = ''.obs;
  final int pageSize = 10;
  RxInt totalUsersLength = 0.obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  RxList<BannerModel> filteredBannerList = <BannerModel>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;
  Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);
  RxString existingImageUrl = ''.obs;
  RxList<String> stateList = <String>["New York", "California"].obs;
  RxString editingBannerId = ''.obs;
  RxInt viewingBannerIndex =
      (-1).obs; // Track the index of the banner being viewed

  List<String> losAngelusCities = [
    "Beverly Hills",
    "Santa Monica",
    "West Hollywood",
    "Culver City",
    "Pasadena",
    "Hollywood",
    "Venice",
    "Downtown LA",
    "Westwood",
    "Silver Lake",
    "Echo Park",
    "Koreatown",
    "Bel Air",
    "Brentwood",
    "Los Feliz",
  ];
  List<String> newYorkCitiesList = [
    "Manhattan",
    "Brooklyn",
    "Queens",
    "The Bronx",
    "Staten Island",
    "Harlem",
    "Greenwich Village",
    "SoHo",
    "Upper East Side",
    "Upper West Side",
    "Williamsburg",
    "Park Slope",
    "Astoria",
    "Flushing",
    "Cobble Hill",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
    searchController.addListener(() {
      filterBanners(searchController.text);
    });
    filteredBannerList.assignAll(bannerList);
  }

  pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result != null && result.files.first.bytes != null) {
        selectedImageBytes.value = result.files.first.bytes!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  addBanner() async {
    try {
      if (titleController.text.trim().isEmpty) throw 'Please enter a title.';
      if (startDateController.text.trim().isEmpty)
        throw 'Please select a start date.';
      if (endDateController.text.trim().isEmpty)
        throw 'Please select an end date.';
      if (selectedState.value.isEmpty) throw 'Please select a state.';
      if (selectedCity.value.isEmpty) throw 'Please select a city.';
      if (selectedImageBytes.value == null) throw 'Please upload an image.';

      final startDate =
          DateFormat('MMMM dd, yyyy').parse(startDateController.text);
      final endDate = DateFormat('MMMM dd, yyyy').parse(endDateController.text);
      if (endDate.isBefore(startDate))
        throw 'End date must be after start date.';

      loadingDialog();
      String imageUrl =
          await uploadImageToFirebase('banner', selectedImageBytes.value!);
      BannerModel banner = BannerModel(
        userID: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        startDate: startDateController.text,
        endDate: endDateController.text,
        state: selectedState.value,
        city: selectedCity.value,
        bannerImage: imageUrl,
        status: 'Active',
      );

      await firestore
          .collection('banner')
          .doc(banner.userID)
          .set(banner.toJson());
      bannerList.add(banner);
      filteredBannerList.assignAll(bannerList);
      clearInputs();

      Get.back();
      Get.snackbar('Success', 'Banner added successfully',
          backgroundColor: primaryColor, colorText: white);
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString(),
          backgroundColor: primaryColor, colorText: white);
      rethrow;
    }
  }

  fetchBanners() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('banner').get();
      bannerList.value = snapshot.docs
          .map((doc) => BannerModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
      filteredBannerList.assignAll(bannerList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch banners: $e',
          backgroundColor: primaryColor, colorText: white);
    }
  }

  void filterBanners(String query) {
    query = query.trim().toLowerCase();
    if (query.isEmpty) {
      filteredBannerList
          .assignAll(bannerList); // Show all banners if query is empty
    } else {
      filteredBannerList.value = bannerList
          .where((banner) => banner.title.toLowerCase().contains(query))
          .toList();
    }
  }

  void loadBannerForEdit(int index) {
    final banner = bannerList[index];
    editingBannerId.value = banner.userID;
    titleController.text = banner.title;
    startDateController.text = banner.startDate;
    endDateController.text = banner.endDate;
    selectedState.value = banner.state;
    selectedCity.value = banner.city;
    existingImageUrl.value = banner.bannerImage;
    selectedImageBytes.value = null;
  }

  void loadBannerForView(int index) {
    viewingBannerIndex.value = index; // Set the index of the banner to view
  }

  updateBanner() async {
    try {
      if (titleController.text.trim().isEmpty) throw 'Please enter a title.';
      if (startDateController.text.trim().isEmpty)
        throw 'Please select a start date.';
      if (endDateController.text.trim().isEmpty)
        throw 'Please select an end date.';
      if (selectedState.value.isEmpty) throw 'Please select a state.';
      if (selectedCity.value.isEmpty) throw 'Please select a city.';

      final startDate =
          DateFormat('MMMM dd, yyyy').parse(startDateController.text);
      final endDate = DateFormat('MMMM dd, yyyy').parse(endDateController.text);
      if (endDate.isBefore(startDate))
        throw 'End date must be after start date.';

      loadingDialog();
      String imageUrl = existingImageUrl.value;
      if (selectedImageBytes.value != null) {
        imageUrl =
            await uploadImageToFirebase('banner', selectedImageBytes.value!);
      }

      BannerModel updatedBanner = BannerModel(
        userID: editingBannerId.value,
        title: titleController.text.trim(),
        startDate: startDateController.text,
        endDate: endDateController.text,
        state: selectedState.value,
        city: selectedCity.value,
        bannerImage: imageUrl,
        status: 'Active',
      );

      await firestore
          .collection('banner')
          .doc(updatedBanner.userID)
          .update(updatedBanner.toJson());
      final index =
          bannerList.indexWhere((b) => b.userID == updatedBanner.userID);
      if (index != -1) bannerList[index] = updatedBanner;

      clearInputs();
      isFromEdit.value = false;

      Get.back();
      Get.snackbar('Success', 'Banner updated successfully',
          backgroundColor: primaryColor, colorText: white);
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to update banner: $e',
          backgroundColor: primaryColor, colorText: white);
      rethrow;
    }
  }

  void removeImage() {
    selectedImageBytes.value = null;
  }

  void clearInputs() {
    titleController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedState.value = '';
    selectedCity.value = '';
    selectedImageBytes.value = null;
    existingImageUrl.value = '';
    editingBannerId.value = '';
    viewingBannerIndex.value = -1; // Reset view index
  }

  deleteBanner(int index) async {
    try {
      loadingDialog();
      String bannerId = bannerList[index].userID;
      await firestore.collection('banner').doc(bannerId).delete();
      bannerList.removeAt(index);
      Get.back();
      Get.snackbar('Success', 'Banner deleted successfully',
          backgroundColor: primaryColor,
          colorText: white,
          duration: Duration(seconds: 1));
      fetchBanners();
      update();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to delete banner: $e',
          backgroundColor: primaryColor, colorText: white);
    }
  }
}
