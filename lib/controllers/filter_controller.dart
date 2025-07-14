import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FilterController extends GetxController {
  var selectedVibes = <String>[].obs;
  var selectedAtmosphere = <String>[].obs;

  var selectedCuisine = <String>[].obs;
  var selectedExperience = <String>[].obs;

  void toggleVibe(String vibe) {
    if (selectedVibes.contains(vibe)) {
      selectedVibes.remove(vibe);
    } else {
      selectedVibes.add(vibe);
    }
  }

  void toggleCuisine(String cuisine) {
    if (selectedCuisine.contains(cuisine)) {
      selectedCuisine.remove(cuisine);
    } else {
      selectedCuisine.add(cuisine);
    }
  }


 void toggleAtmosphere(String atmosphere) {
    if (selectedAtmosphere.contains(atmosphere)) {
      selectedAtmosphere.remove(atmosphere);
    } else {
      selectedAtmosphere.add(atmosphere);
    }
  }





 void toggleExperience(String experience) {
    if (selectedExperience.contains(experience)) {
      selectedExperience.remove(experience);
    } else {
      selectedExperience.add(experience);
    }
  }



  void clearFilters() {
    selectedVibes.clear();
    selectedAtmosphere.clear();
    selectedExperience.clear();
    selectedCuisine.clear();


  }
}
