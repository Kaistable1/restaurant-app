// import 'package:flutter/material.dart';
// import 'package:google_place/google_place.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kaistable_website/secert.dart';

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   final GooglePlace googlePlace = GooglePlace(googleApiKey);
//   List<AutocompletePrediction> predictions = [];

//   void autoCompleteSearch(String value) async {
//     var result = await googlePlace.autocomplete.get(value);
//     if (result != null && result.predictions != null) {
//       setState(() {
//         predictions = result.predictions!;
//       });
//     }
//   }

//   void getPlaceDetails(String placeId) async {
//     var details = await googlePlace.details.get(placeId);
//     if (details != null && details.result != null) {
//       String? city, country, postalCode;

//       for (var component in details.result!.addressComponents!) {
//         if (component.types!.contains("locality")) {
//           city = component.longName;
//         } else if (component.types!.contains("country")) {
//           country = component.longName;
//         } else if (component.types!.contains("postal_code")) {
//           postalCode = component.longName;
//         }
//       }

//       filterRestaurants(city: city, country: country, zip: postalCode);
//     }
//   }

//   void filterRestaurants({String? city, String? country, String? zip}) {
//     FirebaseFirestore.instance
//         .collection("restaurants")
//         .where("city", isEqualTo: city)
//         .get()
//         .then((value) {
//           // handle filtered restaurants
//         });
//   }

//   void getCurrentLocationAndFilter() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);

//     if (placemarks.isNotEmpty) {
//       var place = placemarks.first;
//       filterRestaurants(
//           city: place.locality,
//           country: place.country,
//           zip: place.postalCode);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: TextField(
//           controller: _searchController,
//           onChanged: autoCompleteSearch,
//           decoration: const InputDecoration(
//             hintText: "Search...",
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//       body: ListView(
//         children: predictions.map((p) => ListTile(
//           title: Text(p.description ?? ""),
//           onTap: () {
//             _searchController.text = p.description!;
//             getPlaceDetails(p.placeId!);
//             Navigator.pop(context); // Go back to the previous screen
//           },
//         )).toList(),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart'
    show RestaurantDetailScreen;
import 'package:kaistable_website/secert.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final GooglePlace googlePlace = GooglePlace(googleApiKey);
  List<AutocompletePrediction> predictions = [];
  List<DocumentSnapshot> filteredRestaurants = [];

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getPlaceDetails(String placeId) async {
    var details = await googlePlace.details.get(placeId);
    if (details != null && details.result != null) {
      String? placeName = details.result!.name;

      if (placeName != null && placeName.isNotEmpty) {
        filterRestaurantsByName(placeName);
      }
    }
  }

 void filterRestaurantsByName(String input) async {
  if (input.isEmpty) {
    setState(() {
      filteredRestaurants = [];
    });
    return;
  }

  var snapshot =
      await FirebaseFirestore.instance.collection("restaurants").get();

  List<DocumentSnapshot> allDocs = snapshot.docs;

  List<DocumentSnapshot> matchingDocs = allDocs.where((doc) {
    var data = doc.data() as Map<String, dynamic>;

    String resName = (data['resName'] ?? '').toString().toLowerCase();
    String city = (data['city'] ?? '').toString().toLowerCase();
    String country = (data['country'] ?? '').toString().toLowerCase();
    String zipcode = (data['zipcode'] ?? '').toString().toLowerCase();

    String searchInput = input.toLowerCase();

    return resName.contains(searchInput) ||
        city.contains(searchInput) ||
        country.contains(searchInput) ||
        zipcode.contains(searchInput);
  }).toList();

  setState(() {
    filteredRestaurants = matchingDocs;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            autoCompleteSearch(value);
            filterRestaurantsByName(value);
          },
          decoration: const InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Google Place Predictions
          ...predictions.map((p) => ListTile(
                title: Text(p.description ?? ""),
                onTap: () {
                  _searchController.text = p.description!;
                  getPlaceDetails(p.placeId!);
                },
              )),

          const SizedBox(height: 20),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Filtered Restaurants:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Filtered Restaurants from Firestore
          ...filteredRestaurants.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: data['logoImage'] != null
                  ? Image.network(data['logoImage'], width: 50, height: 50)
                  : Icon(Icons.restaurant),
              title: Text(data['resName'] ?? 'No Name'),
              subtitle: Text(data['address'] ?? 'No Address'),
              onTap: () {
                RestaurantModel restaurant = RestaurantModel.fromMap(data);
                Get.to(
                    () => RestaurantDetailScreen(restaurantModel: restaurant));
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
