import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FilterController extends GetxController {
  var selectedVibes = <String>[].obs;
  var selectedAtmosphere = <String>[].obs;

  void toggleVibe(String vibe) {
    if (selectedVibes.contains(vibe)) {
      selectedVibes.remove(vibe);
    } else {
      selectedVibes.add(vibe);
    }
  }

  void toggleAtmosphere(String atmosphere) {
    if (selectedAtmosphere.contains(atmosphere)) {
      selectedAtmosphere.remove(atmosphere);
    } else {
      selectedAtmosphere.add(atmosphere);
    }
  }




  void clearFilters() {
    selectedVibes.clear();
    selectedAtmosphere.clear();
  }
}
