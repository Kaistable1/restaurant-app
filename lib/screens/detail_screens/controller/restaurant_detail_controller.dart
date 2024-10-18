import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantDetailController extends GetxController {
  List top = ['menu', 'about', 'reviews'];

  RxString selectedTop = 'menu'.obs;

  final Completer<GoogleMapController> completer =
  Completer<GoogleMapController>();
}
