import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:savrly/models/sub_admins_model.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/sub_admins_controller.dart';
import '../../../utils/validations.dart';
import '../../../widgets/button.dart';
import '../../../widgets/customheader_widget.dart';
import '../../../widgets/text_and_field_drop_down.dart';

class AddSubAdminScreen extends StatelessWidget {
  AddSubAdminScreen({super.key});

  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Get.put(SubAdminsController());
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    double paddingValue = mobileView ? 16 : 24;
    double buttonTextSize = mobileView ? 11 : 16;

    SubAdminsModel? subAdminsModel = controller.subAdminsModel;
    if (subAdminsModel != null) {
      controller.fullNameController.text = subAdminsModel.name;
      controller.contactController.text = subAdminsModel.contact;
      controller.emailController.text = subAdminsModel.email;
      controller.assignPasswordController.text = subAdminsModel.passwords;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomHeaderWidget(
                title: 'Add Sub Admin',
                back: true,
                onBackTap: () {
                  drawerController.addSubAdmin.value = false;
                },
              ),
              SizedBox(height: 30),
              !mobileView
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextAndFieldsOrDropDown(
                                labelText: 'Full Name',
                                fieldHintText: 'Joe Adward',
                                fieldController: controller.fullNameController,
                                isDropDown: false,
                                fieldValidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter full name.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: TextAndFieldsOrDropDown(
                                labelText: 'Contact',
                                fieldHintText: '09876766363',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                fieldController: controller.contactController,
                                fieldValidator: (value) =>
                                    isPhoneNumberValid(value!),
                                isDropDown: false,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextAndFieldsOrDropDown(
                                labelText: 'Email',
                                fieldHintText: 'abc@dff.com',
                                readOnly: subAdminsModel != null ? true : false,
                                fieldController: controller.emailController,
                                fieldValidator: (value) => isEmailValid(value!),
                                isDropDown: false,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Obx(
                                () => TextAndFieldsOrDropDown(
                                  labelText: 'Assign Password',
                                  fieldHintText: '123@abc',
                                  readOnly:
                                      subAdminsModel != null ? true : false,
                                  fieldController:
                                      controller.assignPasswordController,
                                  fieldValidator: (value) =>
                                      isPasswordValid(value!),
                                  isObscure:
                                      !controller.isPasswordVisible.value,
                                  fieldSuffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: primaryColor,
                                    ),
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                  ),
                                  isDropDown: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        TextAndFieldsOrDropDown(
                          labelText: 'Full Name',
                          fieldHintText: 'Joe Adward',
                          fieldController: controller.fullNameController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter full name.';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Contact',
                          fieldHintText: '09876766363',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          fieldController: controller.contactController,
                          fieldValidator: (value) => isPhoneNumberValid(value!),
                          isDropDown: false,
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Email',
                          fieldHintText: 'abc@dff.com',
                          fieldController: controller.emailController,
                          fieldValidator: (value) => isEmailValid(value!),
                          isDropDown: false,
                        ),
                        Obx(
                          () => TextAndFieldsOrDropDown(
                            labelText: 'Assign Password',
                            fieldHintText: '123@abc',
                            fieldController:
                                controller.assignPasswordController,
                            fieldValidator: (value) => isPasswordValid(value!),
                            isObscure: !controller.isPasswordVisible.value,
                            fieldSuffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryColor,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                            isDropDown: false,
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 24),
              CustomButton(
                laBelText: subAdminsModel != null ? 'Update' : 'Save',
                fontSize: buttonTextSize,
                width: mobileView ? 150 : 200,
                shadow: [],
                containerColor: primaryColor,
                ontapp: () async {
                  if (formKey.currentState!.validate()) {
                    if (subAdminsModel != null) {
                      await controller.updateSubAdminInfo(
                          docID: subAdminsModel.docID);
                    } else {
                      await controller.createSubAdmin();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
