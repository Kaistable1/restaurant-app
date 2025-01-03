import 'package:get/get.dart';

class EditFacilitiesController extends GetxController {
  // Observable variables to track the selected facility and atmosphere
  var selectedFacility = ''.obs;
  var selectedAtmosphere = ''.obs;

  // Observable list for facilities
  var facilities = <String>[
    'Free wi-fi',
    'Parking',
    'Takeout',
    'Drive-thru',
    'Wheelchair accessibility',
    'High chairs',
    'Restrooms'
  ].obs;

  // Observable list for atmosphere options
  var atmosphere = <String>[
    'Outdoor seating',
    'Private dining rooms',
    'Bar/lounge area',
    'Buffet service'
  ].obs;

  // Set the selected facility
  void selectFacility(String facility) {
    selectedFacility.value = facility;
  }

  // Set the selected atmosphere
  void selectAtmosphere(String atmosphereOption) {
    selectedAtmosphere.value = atmosphereOption;
  }

  // Add a new facility
  void addFacility(String facility) {
    if (!facilities.contains(facility)) {
      facilities.add(facility);
    }
  }

  // Add a new atmosphere option
  void addAtmosphere(String atmosphereOption) {
    if (!atmosphere.contains(atmosphereOption)) {
      atmosphere.add(atmosphereOption);
    }
  }
}
