
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:savrly_data_entry_app/screens/service/yelp_api_model.dart';

class YelpController extends GetxController {
  RxList<YelApiBusiness> businessList = <YelApiBusiness>[].obs;
  RxBool isLoading = false.obs;

  final String apiKey = "wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx";

  Future<void> fetchBusinesses() async {
    isLoading.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx',
      };

      String url =
          "https://api.yelp.com/v3/businesses/search?location=New York&limit=40";
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        businessList.assignAll(YelApiBusiness.fromJsonList(response.body));
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoading.value = false;
  }
}


class YelpScreen extends StatelessWidget {
  final YelpController yelpController = Get.put(YelpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yelp Restaurants")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              yelpController.fetchBusinesses();
            },
            child: Text("Fetch Restaurants"),
          ),
          Expanded(
            child: Obx(() {
              if (yelpController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (yelpController.businessList.isEmpty) {
                return Center(child: Text("No businesses found"));
              }

              return ListView.builder(
                itemCount: yelpController.businessList.length,
                itemBuilder: (context, index) {
                  final business = yelpController.businessList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.network(
                        business.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image),
                      ),
                      title: Text(business.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(business.address),
                          Text("⭐ ${business.rating} (${business.reviewCount} reviews)"),
                          Text("📍 ${business.latitude}, ${business.longitude}"),
                          Text("💵 ${business.price}"),
                          Text(business.isOpenNow ? "🟢 Open" : "🔴 Closed"),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Get.snackbar(
                          business.name,
                          "More details at Yelp!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
