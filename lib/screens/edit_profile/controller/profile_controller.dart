import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';

class ProfileController extends GetxController {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  ///Image Picker
  var imagePath = ''.obs;
  Uint8List? imageBytes;
  pickImage(RxString imagePath, ImageSource imageSource) async {
    Get.back();
    final ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: imageSource);
    if (image == null) {
      imagePath.value = "";
    } else {
      imagePath.value = image.path;
      imageBytes = await image.readAsBytes();
      update();
    }
  }

  getData() async {
    try {
      UserModel? user = currentUserDataModel?.value;
      if (user != null) {
        userNameController.text = user.username.text;
        emailController.text = user.userEmail.text;
      }
    } catch (e) {
      print('Error $e');
    }
  }

//update user profile
  updateProfile() async {
    try {
      loadingDialog(message: 'Please wait!', height: 150, loading: true);
      String imgUrl = await uploadImageToFirebase('profile', imageBytes!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .update({
        'userImage': imgUrl,
        'username': userNameController.text,
      });
      Get.back();
    } catch (e) {
      Get.back();
      print('Error update profile $e');
    }
  }
}
