
class YelpBusiness {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String price;
  final String phone;
  final String displayPhone;
  final String url;
  final List<String> categories;
  final bool isClosed;
  final double latitude;
  final double longitude;
  final List<String> displayAddress;
  final List<String> transactions;

  YelpBusiness({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.phone,
    required this.displayPhone,
    required this.url,
    required this.categories,
    required this.isClosed,
    required this.latitude,
    required this.longitude,
    required this.displayAddress,
    required this.transactions,
  });

  factory YelpBusiness.fromJson(Map<String, dynamic> json) {
    return YelpBusiness(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      price: json['price'] ?? '',
      phone: json['phone'] ?? '',
      displayPhone: json['display_phone'] ?? '',
      url: json['url'] ?? '',
      categories: (json['categories'] as List)
          .map((category) => category['title'].toString())
          .toList(),
      isClosed: json['is_closed'] ?? false,
      latitude: json['coordinates']['latitude'] ?? 0.0,
      longitude: json['coordinates']['longitude'] ?? 0.0,
      displayAddress: (json['location']['display_address'] as List)
          .map((address) => address.toString())
          .toList(),
      transactions: (json['transactions'] as List)
          .map((transaction) => transaction.toString())
          .toList(),
    );
  }
}





