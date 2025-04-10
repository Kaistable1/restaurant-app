import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/sub_admins_model.dart';

class SubAdminsController extends GetxController {

  final searchController = TextEditingController();
  final fullNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final assignPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  var subAdminsList = <SubAdminsModel>[
    SubAdminsModel(
      name: 'User1 Tandoori Flame',
      contact: '03001234567',
      email: 'user1@example.com',
      passwords: 'pass1234',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User2 Pizza Roma',
      contact: '03111234567',
      email: 'user2@example.com',
      passwords: 'roma2023',
      status: 'Inactive',
    ),
    SubAdminsModel(
      name: 'User3 Tandoori Flame',
      contact: '03009876543',
      email: 'user3@example.com',
      passwords: 'flame987',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User4 Pizza Roma',
      contact: '03119876543',
      email: 'user4@example.com',
      passwords: 'pizza456',
      status: 'Inactive',
    ),
    SubAdminsModel(
      name: 'User5 Tandoori Flame',
      contact: '03001239876',
      email: 'user5@example.com',
      passwords: 'tandoor789',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User6 Pizza Roma',
      contact: '03117654321',
      email: 'user6@example.com',
      passwords: 'roma654',
      status: 'Inactive',
    ),
    SubAdminsModel(
      name: 'User7 Tandoori Flame',
      contact: '03005432198',
      email: 'user7@example.com',
      passwords: 'flame321',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User8 Pizza Roma',
      contact: '03114321987',
      email: 'user8@example.com',
      passwords: 'pizza987',
      status: 'Inactive',
    ),
    SubAdminsModel(
      name: 'User9 Tandoori Flame',
      contact: '03008765432',
      email: 'user9@example.com',
      passwords: 'tandoor123',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User10 Pizza Roma',
      contact: '03116543210',
      email: 'user10@example.com',
      passwords: 'roma789',
      status: 'Inactive',
    ),
    SubAdminsModel(
      name: 'User11 Tandoori Flame',
      contact: '03001237654',
      email: 'user11@example.com',
      passwords: 'flame654',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User12 Pizza Roma',
      contact: '03119873210',
      email: 'user12@example.com',
      passwords: 'pizza321',
      status: 'Inactive',
    ),
    SubAdminsModel(
      name: 'User13 Tandoori Flame',
      contact: '03005439876',
      email: 'user13@example.com',
      passwords: 'tandoor456',
      status: 'Active',
    ),
    SubAdminsModel(
      name: 'User14 Pizza Roma',
      contact: '03112345678',
      email: 'user14@example.com',
      passwords: 'roma999',
      status: 'Inactive',
    ),
  ].obs; // Assuming .obs is from GetX for reactivity

  void deleteSubAdmin(int index) {
    subAdminsList.removeAt(index);
  }

}