import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/user_management_model.dart';

class UserController extends GetxController {
  final searchController = TextEditingController();
  var users = <UserManagementModel>[
    UserManagementModel(id: 1, name: 'John Doe', email: 'john@example.com'),
    UserManagementModel(id: 2, name: 'Emma Watson', email: 'emma@example.com'),
    UserManagementModel(id: 3, name: 'Liam Smith', email: 'liam@example.com'),
    UserManagementModel(id: 4, name: 'Olivia Brown', email: 'olivia@example.com'),
    UserManagementModel(id: 5, name: 'Noah Wilson', email: 'noah@example.com'),
    UserManagementModel(id: 6, name: 'Ava Johnson', email: 'ava@example.com'),
    UserManagementModel(id: 7, name: 'William Davis', email: 'william@example.com'),
    UserManagementModel(id: 8, name: 'Sophia Martinez', email: 'sophia@example.com'),
    UserManagementModel(id: 9, name: 'James Anderson', email: 'james@example.com'),
    UserManagementModel(id: 10, name: 'Isabella Thomas', email: 'isabella@example.com'),
    UserManagementModel(id: 11, name: 'Benjamin Taylor', email: 'benjamin@example.com'),
    UserManagementModel(id: 12, name: 'Mia Moore', email: 'mia@example.com'),
    UserManagementModel(id: 13, name: 'Lucas Jackson', email: 'lucas@example.com'),
    UserManagementModel(id: 14, name: 'Charlotte White', email: 'charlotte@example.com'),
    UserManagementModel(id: 15, name: 'Henry Harris', email: 'henry@example.com'),
  ].obs;

  void deleteUser(int index) {
    users.removeAt(index);
  }

}
