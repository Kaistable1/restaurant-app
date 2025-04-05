import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

class AddRestaurantTabController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedSpokenLanguage = ''.obs;

  RxList<String> spokenLanguageList =
      <String>['Urdu', 'Punjabi', 'Spanish',].obs;

  RxList<String> cityList =
      <String>['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Peshawar'].obs;

  RxList<String> stateList =
      <String>['Pakistani', 'Chinese', 'Italian', 'Fast Food', 'Indian'].obs;
  final List<String> tabs = [
    'Basic Info',
    'Amenities',
    'Experiences',
    'Operating Hours',
    'Menu',
  ];

  // Store uploaded images
  var uploadedImages = <Uint8List>[].obs;

  void pickImageWeb() async {
    print("Upload tapped");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      print("Picked ${result.files.length} files");
      for (var file in result.files) {
        if (file.bytes != null) {
          uploadedImages.add(file.bytes!);
        }
      }
    } else {
      print("No file selected");
    }
  }
  void removeImage(int index) {
    if (index >= 0 && index < uploadedImages.length) {
      uploadedImages.removeAt(index);
    }
  }
}
