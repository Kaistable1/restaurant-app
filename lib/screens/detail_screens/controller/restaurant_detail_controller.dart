import 'package:get/get.dart';

class RestaurantDetailController extends GetxController {
  List top = ['menu', 'about', 'reviews'];

  RxString selectedTop = 'menu'.obs;
}
