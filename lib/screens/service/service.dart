// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'GoogleResponse.dart';
// import 'api_model.dart';
//
// class YelpService {
//   static const String apiKey = 'wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx';
//   static const String baseUrl = 'https://api.yelp.com/v3/businesses/search';
//
//   Future<List<YelpBusiness>> fetchBusinesses(String city) async {
//     final url = Uri.parse('$baseUrl?location=$city&limit=50'); // Get 50 restaurants
//     print("Fetching data from: $url");
//
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer $apiKey',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     print("Response Status Code: ${response.statusCode}");
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//
//       if (!data.containsKey('businesses')) {
//         print("Key 'businesses' not found in response!");
//         throw Exception("Invalid API response format");
//       }
//
//       List<dynamic> businesses = data['businesses'];
//       print("Number of restaurants received: ${businesses.length}");
//
//       return businesses.map((json) => YelpBusiness.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load restaurants');
//     }
//   }
// }
//
//
//
//
// class GoogleService {
//   static const String apiKey = 'AIzaSyCh8VHJnq_7G4_lZ2t9hDkxdd_P2KTYuoI';
//   static const String baseUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
//
//   Future<List<Business>> fetchBusinesses(String city) async {
//     List<Business> allRestaurants = [];
//     String? nextPageToken;
//
//     do {
//       final url = Uri.parse(
//         '$baseUrl?query=restaurants+in+$city&type=restaurant&key=$apiKey${nextPageToken != null ? '&pagetoken=$nextPageToken' : ''}',
//       );
//
//       print("Fetching data from: $url");
//
//       final response = await http.get(url);
//       print("Response Status Code: ${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//
//         if (!data.containsKey('results')) {
//           print("Key 'results' not found in response!");
//           throw Exception("Invalid API response format");
//         }
//
//         List<dynamic> results = data['results'];
//         allRestaurants.addAll(results.map((json) => Business.fromJson(json)).toList());
//
//         // Check for next page token (for more results)
//         nextPageToken = data['next_page_token'];
//         if (nextPageToken != null) {
//           print("Next page token found, fetching more results...");
//           await Future.delayed(Duration(seconds: 2)); // Wait before next request (Google API requirement)
//         }
//
//       } else {
//         throw Exception('Failed to load restaurants from Google API');
//       }
//     } while (nextPageToken != null && allRestaurants.length < 50); // Fetch until 50 results or no more pages
//
//     return allRestaurants.take(50).toList(); // Ensure max 50 results
//   }
// }
//
