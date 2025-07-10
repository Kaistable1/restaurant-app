import 'package:get/get.dart';

class HomeFilterSearchController extends GetxController {
  var selectedVibes = <String>[].obs;
  var selectedExperiences = <String>[].obs;
  var selectedCuisines = <String>[].obs;

  void setSelectedVibes(List<String> values) {
    selectedVibes.assignAll(values);
  }

  void setSelectedExperiences(List<String> values) {
    selectedExperiences.assignAll(values);
  }

  void setSelectedCuisines(List<String> values) {
    selectedCuisines.assignAll(values);
  }

  void clearAll() {
    selectedVibes.clear();
    selectedExperiences.clear();
    selectedCuisines.clear();
  }
}
