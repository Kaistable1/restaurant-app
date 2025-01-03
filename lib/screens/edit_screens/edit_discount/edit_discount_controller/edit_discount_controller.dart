import 'package:get/get.dart';

class DiscountController extends GetxController {
  var discountItems = List.generate(6, (index) => index).obs;
  final List<LocationListModel> circleItems4 = [
    LocationListModel(
      timeText: '15:00 to 15:00',
      persentText: '5% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '15% off',
    ),
    LocationListModel(
      timeText: '14:00 to 14:00',
      persentText: '20% off',
    ),
  ];

  void removeDiscountItem(int index) {
    discountItems.removeAt(index);
  }
}

class LocationListModel {
  final String timeText;
  final String persentText;
  LocationListModel({
    required this.timeText,
    required this.persentText,
  });
}
