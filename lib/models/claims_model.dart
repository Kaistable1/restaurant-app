class RestaurantClaimsModel {
  final int id;
  final String restaurantsName;
  final String ownerName;
  final String email;
  final String message;
  final String status;
  final String photoUrl;

  RestaurantClaimsModel({
    required this.id,
    required this.restaurantsName,
    required this.ownerName,
    required this.email,
    required this.message,
    required this.status,
    required this.photoUrl,
  });
}