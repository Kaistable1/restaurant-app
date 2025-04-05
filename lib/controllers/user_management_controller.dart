import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/user_management_model.dart';

class UserController extends GetxController {
  final searchController = TextEditingController();
  var users =
      <UserManagementModel>[
        UserManagementModel(id: 1, name: 'John Doe', email: 'john@example.com'),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        UserManagementModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
        // Add more data
      ].obs;
}
