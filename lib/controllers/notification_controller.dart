import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> selectedWebImage = Rx<Uint8List?>(null);

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false, // single image only
      withData: true,
    );

    if (result != null) {
      if (kIsWeb) {
        selectedWebImage.value = result.files.first.bytes!;
      } else {
        selectedImage.value = File(result.files.single.path!);
      }
    }
  }

  void removeImage() {
    selectedImage.value = null;
    selectedWebImage.value = null;
  }
}
