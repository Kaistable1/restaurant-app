import 'package:get/get.dart';

class RestaurantDetailController extends GetxController {
  final String name = "La Bella Italia";
  final double rating = 4.8;
  final int reviewsCount = 230;
  final String address = "123 Culinary Street, Food City, FC 12345";
  final String phone = "(123) 456-7890";
  final String email = "contact@labellaitalia.com";

  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Emily R.",
      "rating": 5,
      "comment": "Amazing food and a cozy atmosphere. Highly recommend!"
    },
    {
      "name": "John D.",
      "rating": 5,
      "comment": "The best Italian food I’ve ever had!"
    },
    {
      "name": "Sarah L.",
      "rating": 4.5,
      "comment": "Great service and delightful dishes!"
    },
  ];
}
