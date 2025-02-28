import 'dart:convert';

class YelApiBusiness {
  String id;
  String name;
  String imageUrl;
  bool isClosed;
  String url;
  int reviewCount;
  double rating;
  List<String> categories;
  double latitude;
  double longitude;
  String price;
  String address;
  String phone;
  bool isOpenNow;

  YelApiBusiness({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isClosed,
    required this.url,
    required this.reviewCount,
    required this.rating,
    required this.categories,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.address,
    required this.phone,
    required this.isOpenNow,
  });

  factory YelApiBusiness.fromJson(Map<String, dynamic> json) {
    return YelApiBusiness(
      id: json["id"],
      name: json["name"],
      imageUrl: json["image_url"] ?? "",
      isClosed: json["is_closed"],
      url: json["url"],
      reviewCount: json["review_count"],
      rating: (json["rating"] ?? 0).toDouble(),
      categories: (json["categories"] as List<dynamic>)
          .map((c) => c["title"] as String)
          .toList(),
      latitude: json["coordinates"]["latitude"],
      longitude: json["coordinates"]["longitude"],
      price: json["price"] ?? "N/A",
      address: json["location"]["display_address"].join(", "),
      phone: json["display_phone"] ?? "N/A",
      isOpenNow: json["business_hours"]?[0]["is_open_now"] ?? false,
    );
  }

  static List<YelApiBusiness> fromJsonList(String str) {
    final jsonData = json.decode(str);
    return (jsonData["businesses"] as List<dynamic>)
        .map((json) => YelApiBusiness.fromJson(json))
        .toList();
  }
}
