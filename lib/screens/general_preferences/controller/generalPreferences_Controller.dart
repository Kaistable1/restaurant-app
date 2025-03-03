import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';

class GeneralPreferencesController extends GetxController {
  final screen1Controller = TextEditingController();
  final screen2Controller = TextEditingController();
  final screen3Controller = TextEditingController();
  final screen4Controller = TextEditingController();
  final screen8Controller = TextEditingController();
  final screen12Controller = TextEditingController();
  final zipCodeController = TextEditingController();

  RxString selectedCountry = ''.obs;
  RxString selectedCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserPreferences();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// **Fetch User Preferences from Firestore**
  fetchUserPreferences() async {
    String? uid = auth.currentUser?.uid;
    if (uid == null) return;

    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // print("Fetched User Data: $data"); // Debugging
        selectedPreferences.value =
            List<String>.from(data["topThreeCuisines"] ?? []);

        selectedPreferences2.value = data["dietaryPref"] is List
            ? List<String>.from(data["dietaryPref"])
            : [data["dietaryPref"] ?? ''];

        selectedPreferences3.value = data["interestedDeals"] is List
            ? List<String>.from(data["interestedDeals"])
            : [data["interestedDeals"] ?? ''];

        selectedPreferences4.value =
            List<String>.from(data["prefRestSettingList"] ?? []);

        selectedPreferences5.value = data["notifyDiningOpportunities"] is List
            ? List<String>.from(data["notifyDiningOpportunities"])
            : [data["notifyDiningOpportunities"] ?? ''];

        selectedPreferences6.value = data["restaurantReviewImp"] is List
            ? List<String>.from(data["restaurantReviewImp"])
            : [data["restaurantReviewImp"] ?? ''];

        selectedPreferences7.value = data["enjoyDiningRestEnter"] is List
            ? List<String>.from(data["enjoyDiningRestEnter"])
            : [data["enjoyDiningRestEnter"] ?? ''];

        selectedPreferences8.value =
            List<String>.from(data["notifyLiveEntertainment"] ?? []);

        selectedPreferences9.value = data["attendingHolidays"] is List
            ? List<String>.from(data["attendingHolidays"])
            : [data["attendingHolidays"] ?? ''];

        selectedPreferences10.value = data["enjoyDiningActivities"] is List
            ? List<String>.from(data["enjoyDiningActivities"])
            : [data["enjoyDiningActivities"] ?? ''];

        selectedPreferences11.value = data["notifyHappyHour"] is List
            ? List<String>.from(data["notifyHappyHour"])
            : [data["notifyHappyHour"] ?? ''];

        selectedPreferences12.value = data["favTypeOfLiveMusic"] is List
            ? List<String>.from(data["favTypeOfLiveMusic"])
            : [data["favTypeOfLiveMusic"] ?? ''];

        zipCodeController.text = data["zipCode"] ?? '';
        selectedCountry.value = data["country"] ?? '';
        selectedCity.value = data["city"] ?? '';
        if (selectedPreferences.contains('Other')) {
          screen1Controller.text = selectedPreferences.last;
        }
        if (selectedPreferences2.contains('Other')) {
          screen2Controller.text = selectedPreferences2.last;
        }
        if (selectedPreferences3.contains('Other')) {
          screen3Controller.text = selectedPreferences3.last;
        }
        if (selectedPreferences4.contains('Other')) {
          screen4Controller.text = selectedPreferences4.last;
        }
        if (selectedPreferences5.contains('Other')) {
          screen4Controller.text = selectedPreferences5.last;
        }
        if (selectedPreferences8.contains('Other')) {
          screen8Controller.text = selectedPreferences8.last;
        }
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching preferences: $e");
    }
  }

  final preferences = [
    {
      "name": "Private Dining Rooms",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "Outdoor Seating", "image": "assets/images/dinning_image..png"},
    {"name": "Family Friendly", "image": "assets/images/dinning_image..png"},
    {"name": "Other", "image": "assets/images/dinning_image..png"},
  ];

  var selectedPreferences = <String>[].obs;

  void toggleSelection(String name) {
    if (selectedPreferences.contains(name)) {
      selectedPreferences.remove(name);
    } else if (selectedPreferences.length < 3) {
      selectedPreferences.add(name);
    }
  }

  ///------------------------------------------------------------------------\\\
  var selectedPreferences2 = <String>[].obs;

  void toggleSelection2(String name) {
    if (selectedPreferences2.contains(name)) {
      selectedPreferences2.remove(name);
    } else if (selectedPreferences2.length < 1) {
      selectedPreferences2.add(name);
    }
  }

  final preferences2 = [
    {"name": "None", "image": "assets/images/dinning_image..png"},
    {"name": "Vegetarian", "image": "assets/images/dinning_image..png"},
    {"name": "Vegan", "image": "assets/images/dinning_image..png"},
    {"name": "Gluten-Free", "image": "assets/images/dinning_image..png"},
    {"name": "Halal", "image": "assets/images/dinning_image..png"},
    {"name": "Kosher", "image": "assets/images/dinning_image..png"},
    {"name": "Other", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences3 = <String>[].obs;

  void toggleSelection3(String name) {
    if (selectedPreferences3.contains(name)) {
      selectedPreferences3.remove(name);
    } else if (selectedPreferences3.length < 1) {
      selectedPreferences3.add(name);
    }
  }

  final preferences3 = [
    {
      "name": "Discounts Off The Bill",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Buy One, Get One Free",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Happy Hour Specials",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Set Menus Or Combo Deals",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences4 = <String>[].obs;

  void toggleSelection4(String name) {
    if (selectedPreferences4.contains(name)) {
      selectedPreferences4.remove(name);
    } else if (selectedPreferences4.length < 2) {
      selectedPreferences4.add(name);
    }
  }

  final preferences4 = [
    {"name": "Casual Dinning", "image": "assets/images/dinning_image..png"},
    {"name": "Fine Dinning", "image": "assets/images/dinning_image..png"},
    {"name": "Outdoor Seating", "image": "assets/images/dinning_image..png"},
    {
      "name": "Family Friendly Dinning",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "Group Dinning", "image": "assets/images/dinning_image..png"},
    {
      "name": "Themed Or Unique Dining Experiences",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences5 = <String>[].obs;

  void toggleSelection5(String name) {
    if (selectedPreferences5.contains(name)) {
      selectedPreferences5.remove(name);
    } else if (selectedPreferences5.length < 1) {
      selectedPreferences5.add(name);
    }
  }

  final preferences5 = [
    {"name": "Daily", "image": "assets/images/dinning_image..png"},
    {"name": "Weekly", "image": "assets/images/dinning_image..png"},
    {"name": "Occasionally", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences6 = <String>[].obs;

  void toggleSelection6(String name) {
    if (selectedPreferences6.contains(name)) {
      selectedPreferences6.remove(name);
    } else if (selectedPreferences6.length < 1) {
      selectedPreferences6.add(name);
    }
  }

  final preferences6 = [
    {"name": "Very Important", "image": "assets/images/dinning_image..png"},
    {"name": "Somewhat Important", "image": "assets/images/dinning_image..png"},
    {"name": "Not Important", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences7 = <String>[].obs;

  void toggleSelection7(String name) {
    if (selectedPreferences7.contains(name)) {
      selectedPreferences7.remove(name);
    } else if (selectedPreferences7.length < 1) {
      selectedPreferences7.add(name);
    }
  }

  final preferences7 = [
    {"name": "Yes, I Love it", "image": "assets/images/dinning_image..png"},
    {"name": "Occasionally", "image": "assets/images/dinning_image..png"},
    {
      "name": "Prefer Quiet Settings",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences8 = <String>[].obs;

  void toggleSelection8(String name) {
    if (selectedPreferences8.contains(name)) {
      selectedPreferences8.remove(name);
    } else {
      selectedPreferences8.add(name);
    }
  }

  final preferences8 = [
    {"name": "DJs", "image": "assets/images/dinning_image..png"},
    {"name": "Live Bands", "image": "assets/images/dinning_image..png"},
    {
      "name": "Acoustic Performances",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "Karaoke Nights", "image": "assets/images/dinning_image..png"},
    {"name": "Comedy Shows", "image": "assets/images/dinning_image..png"},
    {"name": "Trivia Nights", "image": "assets/images/dinning_image..png"},
    {"name": "Other", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences9 = <String>[].obs;

  void toggleSelection9(String name) {
    if (selectedPreferences9.contains(name)) {
      selectedPreferences9.remove(name);
    } else if (selectedPreferences9.length < 1) {
      selectedPreferences9.add(name);
    }
  }

  final preferences9 = [
    {"name": "Yes, I Love Them", "image": "assets/images/dinning_image..png"},
    {
      "name": "Occasionally, For Major Holidays",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "No, I Prefer Regular Dinning Experiences",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences10 = <String>[].obs;

  void toggleSelection10(String name) {
    if (selectedPreferences10.contains(name)) {
      selectedPreferences10.remove(name);
    } else if (selectedPreferences10.length < 1) {
      selectedPreferences10.add(name);
    }
  }

  final preferences10 = [
    {"name": "Yes, I Love Them", "image": "assets/images/dinning_image..png"},
    {"name": "Occasionally", "image": "assets/images/dinning_image..png"},
    {
      "name": "No, I Prefer Low-Key Dinning",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences11 = <String>[].obs;

  void toggleSelection11(String name) {
    if (selectedPreferences11.contains(name)) {
      selectedPreferences11.remove(name);
    } else if (selectedPreferences11.length < 1) {
      selectedPreferences11.add(name);
    }
  }

  final preferences11 = [
    {"name": "Yes, Definitely", "image": "assets/images/dinning_image..png"},
    {
      "name": "Maybe, If It Fits My Schedule",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "No, I Prefer Happy Hours Without Entertainment",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences12 = <String>[].obs;

  void toggleSelection12(String name) {
    if (selectedPreferences12.contains(name)) {
      selectedPreferences12.remove(name);
    } else if (selectedPreferences12.length < 1) {
      selectedPreferences12.add(name);
    }
  }

  final preferences12 = [
    {"name": "Jazz", "image": "assets/images/dinning_image..png"},
    {"name": "Pop/Rock", "image": "assets/images/dinning_image..png"},
    {"name": "R&B/Soul", "image": "assets/images/dinning_image..png"},
    {"name": "Country", "image": "assets/images/dinning_image..png"},
    {"name": "Other", "image": "assets/images/dinning_image..png"},
  ];
}
