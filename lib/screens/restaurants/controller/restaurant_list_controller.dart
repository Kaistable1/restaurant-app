import 'package:get/get.dart';

import '../../../models/restaurant_model.dart';

class RestaurantListController extends GetxController {
  var restaurants = <Restaurant>[
    Restaurant(
      name: "Green Leaf Cafe",
      address: "123 Greenway Blvd, Springfield",
      imageUrl: "assets/images/rome.png",
    ),
    Restaurant(
      name: "City Lights Bistro",
      address: "456 Downtown St, Metropolis",
      imageUrl: "assets/images/berlin.png",
    ),
    Restaurant(
      name: "Vintage Bakery",
      address: "789 Old Town Rd, Villageville",
      imageUrl: "assets/images/tokyo.png",
    ),
    Restaurant(
      name: "Sunset Diner",
      address: "321 Oceanview Ave, Seaside",
      imageUrl: "assets/images/mumbai.png",
    ),
    Restaurant(
      name: "Mountain Grill",
      address: "555 Highland Road, Aspen",
      imageUrl: "assets/images/rome.png",
    ),
    Restaurant(
      name: "Lakeside Seafood",
      address: "987 Lake St, Rivertown",
      imageUrl: "assets/images/berlin.png",
    ),
  ].obs;
}
