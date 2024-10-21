import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantDetailController extends GetxController {
  List<String> texts = [
    "Ut nobis quo. Laudantium sint tempore voluptas illo quibusdam similique officiis. Natus ea similique sed rerum repudiandae deserunt. Deleniti et velit nam ut qui voluptatem voluptate.",
    "Saepe explicabo non odit. Necessitatibus eius et rem alias. Ipsa reprehenderit debitis repellendus voluptas nesciunt. Ut maiores perspiciatis illo deserunt voluptatem. Voluptatem iste ea aut non dolores ea eum.",
    "Assumenda deleniti corporis exercitationem ut blanditiis id aut quo. Nisi cupiditate nihil velit. Beatae similique suscipit dolor neque ut.",
    "Assumenda deleniti corporis exercitationem ut blanditiis id aut quo. Nisi cupiditate nihil velit. Beatae similique suscipit dolor neque ut."
  ];
  List top = ['menu', 'about', 'reviews'];
  RxBool isFavorite = false.obs;
  RxString selectedTop = 'menu'.obs;

  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();
}
