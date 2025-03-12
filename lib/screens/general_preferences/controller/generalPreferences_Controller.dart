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

        selectedPreferences.value =
            List<String>.from(data["topThreeCuisines"] ?? []);

        selectedPreferences2.value = data["dietaryPrefList"] is List
            ? List<String>.from(data["dietaryPrefList"])
            : [data["dietaryPrefList"]];
        selectedPreferences3.value = data["whereToEat"] is List
            ? List<String>.from(data["whereToEat"])
            : [data["whereToEat"]];

        selectedPreferences4.value = data["planner"] is List
            ? List<String>.from(data["planner"])
            : [data["planner"]];

        selectedPreferences5.value = data["impDiningOut"] is List
            ? List<String>.from(data["impDiningOut"])
            : [data["impDiningOut"]];

        selectedPreferences6.value = data["diningExp"] is List
            ? List<String>.from(data["diningExp"])
            : [data["diningExp"]];

        selectedPreferences7.value = data["willingToTravel"] is List
            ? List<String>.from(data["willingToTravel"])
            : [data["willingToTravel"]];

        selectedPreferences8.value =
            List<String>.from(data["notificationType"] ?? []);

        selectedPreferences9.value = data["notifiedDiningOpp"] is List
            ? List<String>.from(data["notifiedDiningOpp"])
            : [data["notifiedDiningOpp"]];
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching preferences: $e");
    }
  }

  final preferences = [
    {"name": "American", "image": "assets/images/dinning_image..png"},
    {"name": "Caribbean", "image": "assets/images/dinning_image..png"},
    {"name": "Chinese", "image": "assets/images/dinning_image..png"},
    {"name": "Creole/Cajun", "image": "assets/images/dinning_image..png"},
    {"name": "Ethiopian", "image": "assets/images/dinning_image..png"},
    {"name": "French", "image": "assets/images/dinning_image..png"},
    {"name": "Greek", "image": "assets/images/dinning_image..png"},
    {"name": "Indian", "image": "assets/images/dinning_image..png"},
    {"name": "Italian", "image": "assets/images/dinning_image..png"},
    {"name": "Japanese", "image": "assets/images/dinning_image..png"},
    {"name": "Mexican", "image": "assets/images/dinning_image..png"},
    {"name": "Middle Eastern", "image": "assets/images/dinning_image..png"},
    {"name": "Southern", "image": "assets/images/dinning_image..png"},
    {"name": "Thai", "image": "assets/images/dinning_image..png"},
    {"name": "Vietnamese", "image": "assets/images/dinning_image..png"},
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
    } else
    // if (selectedPreferences2.length < 1)
    {
      selectedPreferences2.add(name);
    }
  }

  final preferences2 = [
    {
      "name": "Vegan & Plant-Based",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "Vegetarian", "image": "assets/images/dinning_image..png"},
    {"name": "Gluten-Free", "image": "assets/images/dinning_image..png"},
    {"name": "Pescatarian", "image": "assets/images/dinning_image..png"},
    {"name": "Flexitarian", "image": "assets/images/dinning_image..png"},
    {"name": "Raw Food", "image": "assets/images/dinning_image..png"},
    {"name": "Keto", "image": "assets/images/dinning_image..png"},
    {"name": "Paleo", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences3 = <String>[].obs;

  void toggleSelection3(String name) {
    if (selectedPreferences3.contains(name)) {
      selectedPreferences3.remove(name);
    } else if (selectedPreferences3.length < 3) {
      selectedPreferences3.add(name);
    }
  }

  final preferences3 = [
    {
      "name": "Recommendations from friends/family",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Online reviews & ratings",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Social media posts & food influencers",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Special promotions & discounts",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Restaurant ambiance & atmosphere",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences4 = <String>[].obs;

  void toggleSelection4(String name) {
    if (selectedPreferences4.contains(name)) {
      selectedPreferences4.remove(name);
    } else if (selectedPreferences4.length < 1) {
      selectedPreferences4.add(name);
    }
  }

  final preferences4 = [
    {
      "name": "I plan my meals in advance",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "I like to go with the flow and decide last minute",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "A mix of both", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences5 = <String>[].obs;

  void toggleSelection5(String name) {
    if (selectedPreferences5.contains(name)) {
      selectedPreferences5.remove(name);
    } else if (selectedPreferences5.length < 7) {
      selectedPreferences5.add(name);
    }
  }

  final preferences5 = [
    {"name": "Food quality", "image": "assets/images/dinning_image..png"},
    {"name": "Service", "image": "assets/images/dinning_image..png"},
    {"name": "Atmosphere & decor", "image": "assets/images/dinning_image..png"},
    {
      "name": "Entertainment (live music, DJs, etc.)",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "Pricing & discount", "image": "assets/images/dinning_image..png"},
    {"name": "Location/Proximity", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences6 = <String>[].obs;

  void toggleSelection6(String name) {
    if (selectedPreferences6.contains(name)) {
      selectedPreferences6.remove(name);
    } else {
      selectedPreferences6.add(name);
    }
  }

  final preferences6 = [
    {"name": "Cozy & intimate", "image": "assets/images/dinning_image..png"},
    {"name": "Trendy & social", "image": "assets/images/dinning_image..png"},
    {
      "name": "Lively with entertainment",
      "image": "assets/images/dinning_image..png"
    },
    {"name": "Outdoor & scenic", "image": "assets/images/dinning_image..png"},
    {"name": "Family-friendly", "image": "assets/images/dinning_image..png"},
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences7 = <String>[].obs;

  void toggleSelection7(String name) {
    if (selectedPreferences7.contains(name)) {
      selectedPreferences7.remove(name);
    } else if (selectedPreferences7.length < 2) {
      selectedPreferences7.add(name);
    }
  }

  final preferences7 = [
    {"name": "Under 5 miles", "image": "assets/images/dinning_image..png"},
    {"name": "5-15 miles", "image": "assets/images/dinning_image..png"},
    {"name": "15-30 miles", "image": "assets/images/dinning_image..png"},
    {
      "name": "I’d travel anywhere for an amazing meal",
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
    {
      "name": "New restaurant openings",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Happy Hour & special discounts",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Live entertainment events",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "Personalized dining recommendations",
      "image": "assets/images/dinning_image..png"
    },
    {
      "name": "No notifications, I prefer browsing on my own",
      "image": "assets/images/dinning_image..png"
    },
  ];

  ///------------------------------------------------------------------------///

  var selectedPreferences9 = <String>[].obs;

  void toggleSelection9(String name) {
    if (selectedPreferences9.contains(name)) {
      selectedPreferences9.remove(name);
    } else if (selectedPreferences9.length < 2) {
      selectedPreferences9.add(name);
    }
  }

  final preferences9 = [
    {"name": "Daily", "image": "assets/images/dinning_image..png"},
    {"name": "Weekly", "image": "assets/images/dinning_image..png"},
    {"name": "Occasionally", "image": "assets/images/dinning_image..png"},
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
