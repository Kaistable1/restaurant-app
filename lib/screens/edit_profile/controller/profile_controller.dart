import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ProfileController extends GetxController {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;


  ///Image Picker
  var imagePath = ''.obs;

  pickImage(RxString imagePath, ImageSource imageSource) async {
    Get.back();
    final ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: imageSource);
    if (image == null) {
      imagePath.value = "";
    } else {
      imagePath.value = image.path;
    }
  }
}
