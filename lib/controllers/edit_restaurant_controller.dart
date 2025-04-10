import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/controllers/amenities_sub_screen_controller.dart';
import 'package:savrly/controllers/experiences_sub_screen_controller.dart';
import 'package:savrly/controllers/menu_sub_screen_controller.dart';
import 'package:savrly/controllers/operating_hours_sub_screen_controller.dart';
import 'package:savrly/models/resaturant_model.dart';

class EditRestaurantController extends GetxController {
  final restaurantController = Get.find<AddRestaurantTabController>();
  RestaurantModel? restaurantDetailsModel;

  @override
  void onInit() {
    restaurantDetailsModel = restaurantController.restaurantModel;
    fillAllVariable();
    super.onInit();
  }

  fillAllVariable() async {
    if (restaurantDetailsModel != null) {
      await fillAllVarsInRestManagmentController();
      // await fillAllVarsforAmmenitiesController();
      // await fillAllVarsforExperiencesController();
      // await fillAllVarsforOperatingHoursController();
      // await fillAllVarsforMenuController();
    }
  }

  // Fill variables in AddRestaurantTabController (Basic Info)
  fillAllVarsInRestManagmentController() {
    final addRestaurantController = Get.put(AddRestaurantTabController());
    if (restaurantDetailsModel != null) {
      addRestaurantController.restaurantNameController.text =
          restaurantDetailsModel!.resName;
      addRestaurantController.emailController.text =
          restaurantDetailsModel!.resEmail;
      addRestaurantController.assignPasswordController.text =
          restaurantDetailsModel!.password;
      addRestaurantController.areaController.text =
          restaurantDetailsModel!.address;
      addRestaurantController.instagramController.text =
          restaurantDetailsModel!.instaLink;
      addRestaurantController.tiktokLinkController.text =
          restaurantDetailsModel!.tiktokLink;
      addRestaurantController.selectedState.value =
          restaurantDetailsModel!.country;
      addRestaurantController.selectedCity.value = restaurantDetailsModel!.city;
      addRestaurantController.selectedSpokenLanguage.value =
          restaurantDetailsModel!.spokenLanguage;
      addRestaurantController.currentRestaurantID =
          restaurantDetailsModel!.docID;
      // addRestaurantController.uploadedImages.value =
      //     restaurantDetailsModel!.imagesList;
      //     print('addRestaurantController.uploadedImages.value ${addRestaurantController.uploadedImages}');
      addRestaurantController.update();
    }
  }

  // Fill variables in AmenitiesSubScreenController (Amenities)
  fillAllVarsforAmmenitiesController() {
    final amenitiesController = Get.put(AmenitiesSubScreenController());
    if (restaurantDetailsModel != null) {
      // Update facilities
      for (var facility in amenitiesController.facilities) {
        facility['isChecked'] =
            restaurantDetailsModel!.facilityList.contains(facility['name']);
      }

      // Update dietary preferences
      for (var dietary in amenitiesController.dietaryPreferences) {
        dietary['isChecked'] =
            restaurantDetailsModel!.dietaryList.contains(dietary['name']);
      }

      // Update atmosphere
      for (var atm in amenitiesController.atmosphere) {
        atm['isChecked'] =
            restaurantDetailsModel!.atmopshereList.contains(atm['name']);
      }

      // Update price range
      for (var price in amenitiesController.priceRange) {
        price['isChecked'] =
            restaurantDetailsModel!.priceRange == price['name'];
      }

      amenitiesController.facilities.refresh();
      amenitiesController.dietaryPreferences.refresh();
      amenitiesController.atmosphere.refresh();
      amenitiesController.priceRange.refresh();
      amenitiesController.update();
    }
  }

  // Fill variables in ExperiencesSubScreenController (Experiences)
  fillAllVarsforExperiencesController() {
    final experiencesController = Get.put(ExperiencesSubScreenController());
    if (restaurantDetailsModel != null) {
      experiencesController.events.clear();
      experiencesController.events.addAll(restaurantDetailsModel!
          .entertainmentScheduleList
          .map((items) => items) as Iterable<Map<String, dynamic>>);
      experiencesController.events.refresh();
      experiencesController.update();
    }
  }

  // Fill variables in OperatingHoursSubScreenController (Operating Hours)
  fillAllVarsforOperatingHoursController() async {
    final operatingHoursController =
        Get.put(OperatingHoursSubScreenController());
    if (restaurantDetailsModel != null &&
        restaurantDetailsModel!.docID != null) {
      // Fetch operating hours from Firestore subcollection
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantDetailsModel!.docID)
          .collection('operatingHours')
          .get();

      for (var doc in snapshot.docs) {
        final day = doc.id;
        final data = doc.data();
        operatingHoursController.daySwitches[day] =
            true; // Assume day is active unless all slots are closed

        // Check if all slots are closed
        bool allClosed = true;
        for (var meal in ['Breakfast', 'Brunch', 'Lunch', 'Dinner']) {
          if (data[meal] != null && data[meal]['isClosed'] == false) {
            allClosed = false;
            break;
          }
        }
        if (allClosed) {
          operatingHoursController.daySwitches[day] = false;
        }

        // Update slot states and times
        for (var meal in ['Breakfast', 'Brunch', 'Lunch', 'Dinner']) {
          operatingHoursController.slotStates[day]![meal] =
              data[meal] != null && data[meal]['isClosed'] == false;
          if (data[meal] != null && data[meal]['isClosed'] == false) {
            operatingHoursController.slotTimes[day]![meal] =
                '${data[meal]['startTime']} - ${data[meal]['endTime']}';
          } else {
            operatingHoursController.slotTimes[day]![meal] = '';
          }
        }
      }

      operatingHoursController.daySwitches.refresh();
      operatingHoursController.slotStates.refresh();
      operatingHoursController.slotTimes.refresh();
      operatingHoursController.update();
    }
  }

  // Fill variables in MenuSubScreenController (Menu)
  fillAllVarsforMenuController() {
    final menuController = Get.put(MenuSubScreenController());
    if (restaurantDetailsModel != null) {
      menuController.specialConditionsController.text =
          restaurantDetailsModel!.specialConditions;
      if (restaurantDetailsModel!.menuList.isNotEmpty) {
        final menu = restaurantDetailsModel!.menuList.first;
        menuController.selectedCuisine.value = menu.cuisineType ?? '';
        menuController.isFoodMenuSelected.value = menu.menuType == 'food';
        menuController.isDrinkMenuSelected.value = menu.menuType == 'drink';
      }
      menuController.update();
    }
  }
}
