import 'dart:typed_data';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:get/get.dart';

class AddEventController extends GetxController{
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

  final eventNameController=TextEditingController();
  final locationController=TextEditingController();
  final phoneNumberController=TextEditingController();
  final urlController=TextEditingController();
  final dateController=TextEditingController();
  final timeController=TextEditingController();
  final descriptionController=TextEditingController();
  RxString selectEvent = 'Concert'.obs;
  RxList<String> events =
      <String>['Concert', 'Festival', ].obs;

}