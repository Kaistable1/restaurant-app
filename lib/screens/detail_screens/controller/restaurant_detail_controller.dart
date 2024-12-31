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
  List top = ['Menu', 'Entertainment', 'About', 'Reviews'];
  RxBool isFavorite = false.obs;
  RxString selectedTop = 'Menu'.obs;
  RxString selectedMenu = 'Percentage Off'.obs;
  List menuList = [
    'Percentage Off',
    'Happy Hours Specials',
  ];

  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();

  final List<Map<String, String>> rowData = [
    {
      "Name": "Live Music",
      "By": "Neil Young",
      "Day": "Tuesday",
      "Date": "31 Dec, 2024",
      "Time": "10:00 AM-22:00 PM"
    },
    {
      "Name": "DJ Nights",
      "By": "Neil Young",
      "Day": "Tuesday",
      "Date": "01 Dec, 2024",
      "Time": "11:00 AM-22:00 PM"
    },
    {
      "Name": "Karaoke",
      "By": "Neil Young",
      "Day": "Wednesday",
      "Date": "03 Dec, 2024",
      "Time": "12:00 PM-22:00 PM"
    },
    {
      "Name": "Trivia Nights",
      "By": "Neil Young",
      "Day": "Thursday",
      "Date": "11 Dec, 2024",
      "Time": "1:00 PM-22:00 PM"
    },
    {
      "Name": "Sports Screenings",
      "By": "Neil Young",
      "Day": "Friday",
      "Date": "21 Dec, 2024",
      "Time": "2:00 PM-22:00 PM"
    },
    {
      "Name": "Diana",
      "By": "Neil Young",
      "Day": "Saturday",
      "Date": "01 Dec, 2024",
      "Time": "3:00 PM-22:00 PM"
    },
    {
      "Name": "Hookah",
      "By": "Neil Young",
      "Day": "Sunday",
      "Date": "21 Dec, 2024",
      "Time": "4:00 PM-22:00 PM"
    },
  ];
}
