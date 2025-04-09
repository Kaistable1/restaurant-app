import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:savrly/models/banner_model.dart';


class BannerController extends GetxController{
  RxBool isFromEdit=false.obs;

  final titleController=TextEditingController();
  final startDateController=TextEditingController();
  final endDateController=TextEditingController();
  final stateController=TextEditingController();
  final cityController=TextEditingController();



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





  var banner =
      <BannerModel>[
        BannerModel(
          id: 1,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Active',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 2,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Active',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 3,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Expired',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 4,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Active',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 5,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Expired',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 6,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Active',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 7,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Expired',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 8,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Active',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 9,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Expired',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 10,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Active',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        BannerModel(
          id: 11,
          title: 'Summer Sale',
          startDate: '2023-06-01',
          endDate: '2023-07-01',
          status: 'Expired',
          photoUrl: 'assets/images/res_table_1.png',
        ),


        // Add more restaurants...
      ].obs;

  void deleteBanner(int index) {
    banner.removeAt(index);
  }
}