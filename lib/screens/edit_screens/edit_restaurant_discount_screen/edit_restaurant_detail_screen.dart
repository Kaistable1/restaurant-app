import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/edit_screens/controller/edit_controller.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/account_settings_popup_widget.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../../main.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import '../../add_restaurant/add_resturant_controller/add_resturant _controller.dart';
import '../../main_screen/mainscreen_controller/main_controller.dart';
import '../../restaurant_detail_screen/controller/restaurant_detail_controller.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';
import '../../restaurant_detail_screen/widget/map_widget.dart';
import '../widgets/edit_map.dart';

class EditRestaurantDetailScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(AddRestaurantController());
  final mainController = Get.put(MainController());

  EditRestaurantDetailScreen(
      {super.key, this.onNavigate, this.isFromButtonClick});
  bool? isFromButtonClick;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: isFromButtonClick == null
          ? null
          : AppBar(
              backgroundColor: AppColors.whiteColor,
              toolbarHeight: 110,
              automaticallyImplyLeading: false,
              elevation: 1,
              title: Image.asset(
                'assets/images/appbar_logo.png',
                width: 200,
                height: 70,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 230,
                    height: 59,
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => currentUserDataModel.value!.address.text != ''
                            ? AccountSettingsPopupWidget()
                            : AccountNoAuthPopupWidget(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      body: AddEditRestaurantContent(),
    );
  }
}

class AddEditRestaurantContent extends StatefulWidget {
  @override
  State<AddEditRestaurantContent> createState() =>
      _AddEditRestaurantContentState();
}

class _AddEditRestaurantContentState extends State<AddEditRestaurantContent> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(RestaurantDetailController());
  final editController = Get.put(EditScreenController());
  final restaurantController = Get.put(AddRestaurantController());
  final RxBool data = true.obs;
  final List<String> items = [
    'Chinese',
    'Germany',
    'France',
    'Spain',
  ];
  RxString selectedValue = ''.obs;
  Uint8List? _imageBytes; // For the logo image
  Uint8List? _addedImageBytes;

  // Function to pick an image using File Picker
  Future<void> _pickImage({bool isLogo = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      final file = result.files.single;

      setState(() {
        if (isLogo) {
          _imageBytes = file.bytes; // Set the logo image bytes
        } else {
          _addedImageBytes = file.bytes; // Set the added image bytes
        }
      });
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    restaurantController.restaurantsNameError.value = '';
    restaurantController.addressError.value = '';
    restaurantController.phoneError.value = '';
    restaurantController.cityError.value = '';
    restaurantController.countryError.value = '';
    restaurantController.zipCodeError.value = '';
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 530
        ? 530
        : screenWidth * 0.9; // max width 530, else 90% of screen width

    return GetBuilder<AddRestaurantController>(builder: (addResConotroller) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;
          final isTablet =
              constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .doc(auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: Get.height * 0.6,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              RestaurantModel resModel;
              if (snapshot.data != null) {
                resModel = RestaurantModel.fromDocumentSnapshot(
                    snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
                selectedValue.value = resModel.spokenLanguage.value;
              } else {
                resModel = RestaurantModel.initialize();
              }

              return Responsive.isDesktop(context)
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: Responsive.isMobile(context)
                                          ? 30
                                          : (Responsive.isTablet(context)
                                              ? 36
                                              : 42),
                                      height: Responsive.isMobile(context)
                                          ? 30
                                          : (Responsive.isTablet(context)
                                              ? 36
                                              : 42),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        iconSize: Responsive.isMobile(context)
                                            ? 14
                                            : (Responsive.isTablet(context)
                                                ? 16
                                                : 18),
                                        icon: const Icon(Icons.arrow_back,
                                            color: AppColors.primaryColor),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Edit Restaurant',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontFamily: 'Nunito-Regular',
                                        fontSize: Responsive.isMobile(context)
                                            ? 24
                                            : Responsive.isTablet(context)
                                                ? 28
                                                : 32,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    // Placeholder for spacing to align the title to the center.
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Restaurant Name Section
                                          Text(
                                            'Restaurant name',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.resName,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "Restaurant name",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .restaurantsNameError
                                                  .value
                                                  .isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .restaurantsNameError
                                                      .value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 24),

                                          // Image Section
                                          Text(
                                            'Images',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 24),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Obx(() => Row(
                                                children: [
                                                  Wrap(
                                                    spacing: 8,
                                                    children: resModel
                                                        .resImageMemory
                                                        .map((image) {
                                                      return Stack(
                                                        clipBehavior: Clip
                                                            .none, // Allows the cross icon to overflow if needed
                                                        children: [
                                                          // Circular Image with Border
                                                          ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10),
                                                            child: Container(
                                                              width: Responsive
                                                                  .isDesktop(
                                                                  context)
                                                                  ? 160
                                                                  : 150, // Adjust the size as needed
                                                              height: Responsive
                                                                  .isDesktop(
                                                                  context)
                                                                  ? 160
                                                                  : 110,

                                                              child: Image
                                                                  .memory(
                                                                image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),

                                                          // Close Icon in Top Right
                                                          Positioned(
                                                            top:
                                                            8, // Adjust position as needed
                                                            right: 10,
                                                            child:
                                                            GestureDetector(
                                                              onTap: () {
                                                                resModel
                                                                    .resImageMemory
                                                                    .remove(
                                                                    image);
                                                              },
                                                              child:
                                                              Container(
                                                                width: 19,
                                                                height: 19,
                                                                decoration:
                                                                const BoxDecoration(
                                                                  color: AppColors
                                                                      .darkGrey,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                const Icon(
                                                                  Icons.close,
                                                                  size: 10,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                  Obx(() {
                                                   data.value;
                                                    return  Wrap(

                                                      alignment: WrapAlignment.start,
                                                      children: List.generate(resModel.resImages.length, (index) {
                                                        return Obx(() {
                                                         return data.value? Padding(
                                                           padding: const EdgeInsets.only(left: 8.0),
                                                           child: Stack(
                                                              clipBehavior: Clip
                                                                  .none, // Allows the cross icon to overflow if needed
                                                              children: [
                                                                // Circular Image with Border
                                                                ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                  child: Container(
                                                                    width: Responsive
                                                                        .isDesktop(
                                                                        context)
                                                                        ? 160
                                                                        : 150, // Adjust the size as needed
                                                                    height: Responsive
                                                                        .isDesktop(
                                                                        context)
                                                                        ? 160
                                                                        : 110,

                                                                    child: Image
                                                                        .network(
                                                                      resModel.resImages[index].value ,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),

                                                                // Close Icon in Top Right
                                                                Positioned(
                                                                  top:
                                                                  8, // Adjust position as needed
                                                                  right: 10,
                                                                  child:
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      data.value =
                                                                      false;
                                                                      resModel
                                                                          .resImages
                                                                          .removeAt(
                                                                          index);
                                                                      data.value =
                                                                      true;
                                                                    },
                                                                    child:
                                                                    Container(
                                                                      width: 19,
                                                                      height: 19,
                                                                      decoration:
                                                                      const BoxDecoration(
                                                                        color: AppColors
                                                                            .darkGrey,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                      const Icon(
                                                                        Icons.close,
                                                                        size: 10,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                         ):SizedBox();
                                                        },);
                                                      },),
                                                    );
                                                  },),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              Uint8List?
                                                              selectedImage =
                                                              await getImage();

                                                              if (selectedImage !=
                                                                  null &&
                                                                  selectedImage
                                                                      .isNotEmpty) {
                                                                resModel
                                                                    .resImageMemory
                                                                    .add(
                                                                    selectedImage);
                                                                // print(
                                                                //     '${controller.listingModel!.listingImageMemories.length}++++++++++++++++++ gallery');
                                                              }
                                                            },
                                                            child:  Container(
                                                                height: isDesktop
                                                                    ? 160
                                                                    : isTablet
                                                                    ? 150
                                                                    : 100,
                                                                width: isDesktop
                                                                    ? 160
                                                                    : isTablet
                                                                    ? 150
                                                                    : 100,
                                                                decoration:
                                                                BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                          .2)),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                ),
                                                                child: Icon(
                                                                    Icons.add,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    size: isDesktop
                                                                        ? 40
                                                                        : isTablet
                                                                        ? 30
                                                                        : 28))  ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),)
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          // Logo Section
                                          Text(
                                            'Logo',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Obx(
                                            () => GestureDetector(
                                              onTap: () async {
                                                Uint8List? selectedImage =
                                                    await getImage();
                                                if (selectedImage != null) {
                                                  resModel.logoImageMemory
                                                      .value = selectedImage;
                                                }
                                              },
                                              child: resModel.logoImage.value ==
                                                          '' &&
                                                      resModel.logoImageMemory
                                                          .value.isEmpty
                                                  ? Container(
                                                      height: isDesktop
                                                          ? 150
                                                          : isTablet
                                                              ? 120
                                                              : 110,
                                                      width: 516,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    .1)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: AppColors
                                                            .whiteColor,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(12),
                                                          dashPattern: [6, 3],
                                                          color: AppColors
                                                              .primaryColor,
                                                          strokeWidth: 1,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              color: AppColors
                                                                  .whiteColor,
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .upload_file_outlined,
                                                                      size: 32,
                                                                      color: AppColors
                                                                          .primaryColor),
                                                                  Text(
                                                                    'Upload Logo',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Responsive.isMobile(
                                                                              context)
                                                                          ? 12
                                                                          : (Responsive.isTablet(context)
                                                                              ? 14
                                                                              : 16),
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Upload a .png file only',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Responsive.isMobile(
                                                                              context)
                                                                          ? 12
                                                                          : (Responsive.isTablet(context)
                                                                              ? 14
                                                                              : 16),
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: isDesktop
                                                          ? 150
                                                          : isTablet
                                                              ? 120
                                                              : 110,
                                                      width: 516,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: resModel
                                                                  .logoImageMemory
                                                                  .value
                                                                  .isNotEmpty
                                                              ? MemoryImage(resModel
                                                                  .logoImageMemory
                                                                  .value)
                                                              : NetworkImage(
                                                                  resModel
                                                                      .logoImage
                                                                      .value),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          // Save Button
                                          Text(
                                            'Add address',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.address,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "Address",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            suffixIcon: const Icon(
                                                Icons.location_on,
                                                color: AppColors.primaryColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .addressError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .addressError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          SizedBox(
                                              height:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : 22),
                                          Text(
                                            'Map',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : 22),
                                          Container(
                                            height: Get.height * 0.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: EditMapWidget(
                                                restaurantModel: resModel),
                                          ),
                                          SizedBox(
                                              height:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : 22),
                                          Text(
                                            'Spoken languages',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          // Dropdown for spoken languages
                                          SizedBox(
                                              height:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : 22),

                                          Obx(
                                            () => DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  resModel.spokenLanguage.value,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  ),
                                                ),
                                                items: items
                                                    .map((String item) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: selectedValue.value,
                                                onChanged: (String? value) {
                                                  selectedValue.value = value!;
                                                  resModel.spokenLanguage
                                                      .value = value;
                                                },
                                                buttonStyleData:
                                                    ButtonStyleData(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppColors.darkGrey
                                                          .withOpacity(.1),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Rounded corners
                                                    color: AppColors.whiteColor,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  height: 40,
                                                  // width: 140,
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                  height: 40,
                                                ),
                                                iconStyleData:
                                                    const IconStyleData(
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined, // Custom icon for dropdown
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  iconSize: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomButton(
                                                title: "Update",
                                                textStyle: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? 16
                                                      : 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                borderRadius: 8,
                                                width:
                                                    Responsive.isMobile(context)
                                                        ? Get.width * 0.1
                                                        : Get.width * 0.2,
                                                onPressed: () {
                                                  editController
                                                      .updateRestaurantData(
                                                          context, resModel);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Restaurant Name Section
                                          Text(
                                            'Phone no',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.phoneNumber,
                                            // prefixIcon: Padding(
                                            //   padding: const EdgeInsets.all(2.0),
                                            //   child: Container(
                                            //     width: 20,
                                            //     height: 45,
                                            //     decoration: BoxDecoration(
                                            //       color: AppColors.darkGrey
                                            //           .withOpacity(.1),
                                            //     ),
                                            //     child: const Center(
                                            //       child: Text(
                                            //         '+1',
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //             FontWeight.bold),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "+1 2564552",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .phoneError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .phoneError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 8),
                                          Text(
                                            'City',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.city,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "City",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .cityError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .cityError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 8),

                                          Text(
                                            'Country',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          CustomTextField(
                                            controller: resModel.country,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "Country",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          Text(
                                            'Zip Code',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.zipCode,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "45626",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .zipCodeError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .zipCodeError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 8),

                                          const SizedBox(height: 10),
                                          Column(
                                            children: List.generate(
                                                restaurantController
                                                    .addedCuisines
                                                    .length, (index) {
                                              return _buildCuisineContainer(
                                                  index);
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : GetBuilder<AddRestaurantController>(
                      init: AddRestaurantController(),
                      builder: (restaurantController) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: restaurantController.formKey,
                              child: Container(
                                // width: containerWidth, // Width responsive to screen
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: Responsive.isMobile(context)
                                                ? 30
                                                : (Responsive.isTablet(context)
                                                    ? 36
                                                    : 42),
                                            height: Responsive.isMobile(context)
                                                ? 30
                                                : (Responsive.isTablet(context)
                                                    ? 36
                                                    : 42),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              iconSize:
                                                  Responsive.isMobile(context)
                                                      ? 14
                                                      : (Responsive.isTablet(
                                                              context)
                                                          ? 16
                                                          : 18),
                                              icon: const Icon(Icons.arrow_back,
                                                  color:
                                                      AppColors.primaryColor),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Edit Restaurant',
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontFamily: 'Nunito-Regular',
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 24
                                                  : Responsive.isTablet(context)
                                                      ? 28
                                                      : 32,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          // Placeholder for spacing to align the title to the center.
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Restaurant Name Section
                                      Text(
                                        'Restaurant name',
                                        style: TextStyle(
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CustomTextField(
                                        controller: resModel.resName,
                                        borderColor:
                                            AppColors.darkGrey.withOpacity(.1),
                                        width: 516,
                                        borderRadius: 8,
                                        hintText: "Restaurant name",
                                        fillColor: AppColors.whiteColor,
                                        cursorColor: AppColors.primaryColor,
                                        inputStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                        hintStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Obx(() => restaurantController
                                              .restaurantsNameError
                                              .value
                                              .isNotEmpty
                                          ? Text(
                                              restaurantController
                                                  .restaurantsNameError.value,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            )
                                          : const SizedBox.shrink()),
                                      const SizedBox(height: 24),

                                      // Image Section
                                      Text(
                                        'Images',
                                        style: TextStyle(
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 24),
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Obx(() => Row(
                                              children: [
                                                Wrap(
                                                  spacing: 8,
                                                  children: resModel
                                                      .resImageMemory
                                                      .map((image) {
                                                    return Stack(
                                                      clipBehavior: Clip
                                                          .none, // Allows the cross icon to overflow if needed
                                                      children: [
                                                        // Circular Image with Border
                                                        ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          child: Container(
                                                            width: Responsive
                                                                .isDesktop(
                                                                context)
                                                                ? 160
                                                                : 150, // Adjust the size as needed
                                                            height: Responsive
                                                                .isDesktop(
                                                                context)
                                                                ? 160
                                                                : 110,

                                                            child: Image
                                                                .memory(
                                                              image,
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                          ),
                                                        ),

                                                        // Close Icon in Top Right
                                                        Positioned(
                                                          top:
                                                          8, // Adjust position as needed
                                                          right: 10,
                                                          child:
                                                          GestureDetector(
                                                            onTap: () {
                                                              resModel
                                                                  .resImageMemory
                                                                  .remove(
                                                                  image);
                                                            },
                                                            child:
                                                            Container(
                                                              width: 19,
                                                              height: 19,
                                                              decoration:
                                                              const BoxDecoration(
                                                                color: AppColors
                                                                    .darkGrey,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                              const Icon(
                                                                Icons.close,
                                                                size: 10,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                                Obx(() {
                                                  data.value;
                                                  return  Wrap(

                                                    alignment: WrapAlignment.start,
                                                    children: List.generate(resModel.resImages.length, (index) {
                                                      return Obx(() {
                                                        return data.value? Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: Stack(
                                                            clipBehavior: Clip
                                                                .none, // Allows the cross icon to overflow if needed
                                                            children: [
                                                              // Circular Image with Border
                                                              ClipRRect(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                                child: Container(
                                                                  width: Responsive
                                                                      .isDesktop(
                                                                      context)
                                                                      ? 160
                                                                      : 150, // Adjust the size as needed
                                                                  height: Responsive
                                                                      .isDesktop(
                                                                      context)
                                                                      ? 160
                                                                      : 110,

                                                                  child: Image
                                                                      .network(
                                                                    resModel.resImages[index].value ,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Close Icon in Top Right
                                                              Positioned(
                                                                top:
                                                                8, // Adjust position as needed
                                                                right: 10,
                                                                child:
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    data.value =
                                                                    false;
                                                                    resModel
                                                                        .resImages
                                                                        .removeAt(
                                                                        index);
                                                                    data.value =
                                                                    true;
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    width: 19,
                                                                    height: 19,
                                                                    decoration:
                                                                    const BoxDecoration(
                                                                      color: AppColors
                                                                          .darkGrey,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child:
                                                                    const Icon(
                                                                      Icons.close,
                                                                      size: 10,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ):SizedBox();
                                                      },);
                                                    },),
                                                  );
                                                },),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            Uint8List?
                                                            selectedImage =
                                                            await getImage();

                                                            if (selectedImage !=
                                                                null &&
                                                                selectedImage
                                                                    .isNotEmpty) {
                                                              resModel
                                                                  .resImageMemory
                                                                  .add(
                                                                  selectedImage);
                                                              // print(
                                                              //     '${controller.listingModel!.listingImageMemories.length}++++++++++++++++++ gallery');
                                                            }
                                                          },
                                                          child:  Container(
                                                              height: isDesktop
                                                                  ? 160
                                                                  : isTablet
                                                                  ? 150
                                                                  : 100,
                                                              width: isDesktop
                                                                  ? 160
                                                                  : isTablet
                                                                  ? 150
                                                                  : 100,
                                                              decoration:
                                                              BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                        .2)),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                              ),
                                                              child: Icon(
                                                                  Icons.add,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  size: isDesktop
                                                                      ? 40
                                                                      : isTablet
                                                                      ? 30
                                                                      : 28))  ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),)
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Logo Section
                                      Text(
                                        'Logo',
                                        style: TextStyle(
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      ///to change
                                      GestureDetector(
                                        onTap: () async {
                                          Uint8List? selectedImage =
                                          await getImage();
                                          if (selectedImage != null) {
                                            resModel.logoImageMemory
                                                .value = selectedImage;
                                          }
                                        },
                                        child: resModel.logoImage.value ==
                                            '' &&
                                            resModel.logoImageMemory
                                                .value.isEmpty
                                            ? Container(
                                          height: isDesktop
                                              ? 150
                                              : isTablet
                                              ? 120
                                              : 110,
                                          width: 516,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(
                                                    .1)),
                                            borderRadius:
                                            BorderRadius
                                                .circular(12),
                                            color: AppColors
                                                .whiteColor,
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(16.0),
                                            child: DottedBorder(
                                              borderType:
                                              BorderType.RRect,
                                              radius: const Radius
                                                  .circular(12),
                                              dashPattern: [6, 3],
                                              color: AppColors
                                                  .primaryColor,
                                              strokeWidth: 1,
                                              child: Container(
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      12),
                                                  color: AppColors
                                                      .whiteColor,
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .min,
                                                    children: [
                                                      const Icon(
                                                          Icons
                                                              .upload_file_outlined,
                                                          size: 32,
                                                          color: AppColors
                                                              .primaryColor),
                                                      Text(
                                                        'Upload Logo',
                                                        style:
                                                        TextStyle(
                                                          fontSize: Responsive.isMobile(
                                                              context)
                                                              ? 12
                                                              : (Responsive.isTablet(context)
                                                              ? 14
                                                              : 16),
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Upload a .png file only',
                                                        style:
                                                        TextStyle(
                                                          fontSize: Responsive.isMobile(
                                                              context)
                                                              ? 12
                                                              : (Responsive.isTablet(context)
                                                              ? 14
                                                              : 16),
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            : Container(
                                          height: isDesktop
                                              ? 150
                                              : isTablet
                                              ? 120
                                              : 110,
                                          width: 516,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: resModel
                                                  .logoImageMemory
                                                  .value
                                                  .isNotEmpty
                                                  ? MemoryImage(resModel
                                                  .logoImageMemory
                                                  .value)
                                                  : NetworkImage(
                                                  resModel
                                                      .logoImage
                                                      .value),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                            BorderRadius
                                                .circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Save Button
                                      Text(
                                        'Add address',
                                        style: TextStyle(
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CustomTextField(
                                        controller: resModel.address,
                                        borderColor:
                                            AppColors.darkGrey.withOpacity(.1),
                                        width: 516,
                                        borderRadius: 8,
                                        hintText: "Address",
                                        fillColor: AppColors.whiteColor,
                                        cursorColor: AppColors.primaryColor,
                                        inputStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                        hintStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                        suffixIcon: const Icon(
                                            Icons.location_on,
                                            color: AppColors.primaryColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Obx(() => restaurantController
                                              .addressError.value.isNotEmpty
                                          ? Text(
                                              restaurantController
                                                  .addressError.value,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            )
                                          : const SizedBox.shrink()),
                                      SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 12
                                              : 22),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Restaurant Name Section
                                          Text(
                                            'Phone no',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.phoneNumber,
                                            // prefixIcon: Padding(
                                            //   padding: const EdgeInsets.all(2.0),
                                            //   child: Container(
                                            //     width: 20,
                                            //     height: 45,
                                            //     decoration: BoxDecoration(
                                            //       color: AppColors.darkGrey
                                            //           .withOpacity(.1),
                                            //     ),
                                            //     child: const Center(
                                            //       child: Text(
                                            //         '+1',
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //             FontWeight.bold),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "Phone no",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .phoneError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .phoneError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 8),
                                          Text(
                                            'City',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.city,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "City",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .cityError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .cityError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Zip Code',
                                            style: TextStyle(
                                              fontSize: Responsive.isMobile(
                                                      context)
                                                  ? 16
                                                  : Responsive.isTablet(context)
                                                      ? 18
                                                      : 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: resModel.zipCode,
                                            borderColor: AppColors.darkGrey
                                                .withOpacity(.1),
                                            width: 516,
                                            borderRadius: 8,
                                            hintText: "45625",
                                            fillColor: AppColors.whiteColor,
                                            cursorColor: AppColors.primaryColor,
                                            inputStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                            hintStyle: const TextStyle(
                                                color: AppColors.blackColor),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(() => restaurantController
                                                  .zipCodeError.value.isNotEmpty
                                              ? Text(
                                                  restaurantController
                                                      .zipCodeError.value,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const SizedBox.shrink()),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                      Text(
                                        'Map',
                                        style: TextStyle(
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 12
                                              : 22),
                                      Container(
                                        height: Get.height * 0.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: EditMapWidget(
                                            restaurantModel: resModel),
                                      ),
                                      SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 12
                                              : 22),
                                      Text(
                                        'Spoken languages',
                                        style: TextStyle(
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      // Dropdown for spoken languages
                                      SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 12
                                              : 22),

                                      Obx(
                                        () => DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              resModel.spokenLanguage.value,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                            items: items
                                                .map((String item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedValue.value,
                                            onChanged: (String? value) {
                                              selectedValue.value = value!;

                                              resModel.spokenLanguage.value =
                                                  value;
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.darkGrey
                                                      .withOpacity(.1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8), // Rounded corners
                                                color: AppColors.whiteColor,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              height: 40,
                                              // width: 140,
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_outlined, // Custom icon for dropdown
                                                color: AppColors.primaryColor,
                                              ),
                                              iconSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 12
                                              : 22),

                                      Row(
                                        children: [
                                          CustomButton(
                                            title: "Update",
                                            textStyle: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 16
                                                      : 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            borderRadius: 8,
                                            width: Responsive.isMobile(context)
                                                ? screenWidth * 0.3
                                                : screenWidth * 0.1,
                                            onPressed: () {
                                              // Save action
                                              editController
                                                  .updateRestaurantData(
                                                  context, resModel);
                                              // Get.snackbar('Saved',
                                              //     'Your data is successfully updated');
                                              //
                                              // Get.to(
                                              //     () => RestaurantDetailScreen(
                                              //           isFromButtonClick: true,
                                              //         ));
                                            },
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 12
                                              : 22),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
            },
          );
        },
      );
    });
  }

  Widget _buildCuisineContainer(int index) {
    return Stack(
      children: [
        // Container for displaying the cuisine
        Container(
          width: 203, // Adjusted width
          height: 50, // Adjusted height
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.only(
              bottom: 10), // Adds spacing between containers
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.darkGrey.withOpacity(.2),
              )
              // border: Border.all(color: Colors.blue, width: 2),
              ),
          child: Center(
            child: Text(
              restaurantController.addedCuisines[index],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // Positioned Circular Container with Cross Icon
        Positioned(
          top: 3, // Half of the cross button is above the container
          right: 3, // Half of the cross button is outside the container
          child: GestureDetector(
            onTap: () {
              setState(() {
                restaurantController.addedCuisines
                    .removeAt(index); // Remove the item when clicked
              });
            },
            child: Container(
              width: 15, // Circular button size
              height: 15, // Circular button size
              decoration: const BoxDecoration(
                color: AppColors
                    .primaryColor, // Background color for the circular container
                shape: BoxShape.circle, // Makes the container circular
              ),
              child: const Icon(
                Icons.close, // Cross icon
                color: Colors.white, // Icon color
                size: 10, // Icon size
              ),
            ),
          ),
        ),
      ],
    );
  }
}
