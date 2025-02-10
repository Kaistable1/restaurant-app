import 'dart:typed_data';

import 'package:get/get.dart';

import '../widgets/global_functions.dart';

class DiscountModel {
  final String discountType;
  final String fromDate;
  final List<CategoryModel> menu;
  final String toDate;
  final DateTime timestamp;

  DiscountModel({
    required this.discountType,
    required this.fromDate,
    required this.menu,
    required this.toDate,
    required this.timestamp,
  });
  // Initialize with default values
  factory DiscountModel.initialize() {
    return DiscountModel(
      discountType: '',
      fromDate: '',
      toDate: '',
      timestamp: DateTime.now(),
      menu: [],
    );
  }

  // Convert DiscountModel to Map
  Map<String, dynamic> toMap() {
    return {
      'discountType': discountType,
      'fromDate': fromDate,
      'menu': menu.map((category) => category.toMap()).toList(),
      'toDate': toDate,
      'timestamp': timestamp,
    };
  }

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      discountType: json['discountType'] ?? '',
      fromDate: json['fromDate'] ?? '',
      menu: (json['menu'] as List<dynamic>)
          .map((e) => CategoryModel.fromMap(e))
          .toList(),
      toDate: json['toDate'] ?? '',
      timestamp: DateTime.parse(json['timestamp'].toDate().toString()),
    );
  }
}

class CategoryModel {
  // String category;
  // String subcategory;
  String fromDate;
  String toDate;
  String percentageValue;
  String fromTime;
  String toTime;
  String discountType;
  String toTimeType;
  bool lifeTime;
  bool isAllDay;
  List<ItemModel> items;

  CategoryModel({
    // required this.category,
    // required this.subcategory,
    required this.fromDate,
    required this.percentageValue,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.discountType,
    required this.lifeTime,
    required this.isAllDay,
    required this.toTimeType,
    required this.items,
  });

  // Convert CategoryModel to Map
  Map<String, dynamic> toMap() {
    return {
      // 'category': category,
      // 'subcategory': subcategory,
      // 'fromDate': fromDate,
      'percentageValue': percentageValue,
      'toDate': toDate,
      'toTimeType': toTimeType,
      'fromTime': fromTime,
      'discountType': discountType,
      'toTime': toTime,
      'isAllDay': isAllDay,
      'lifeTime': lifeTime,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Create CategoryModel from Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      // category: map['category'] ?? '',
      discountType: map['discountType'] ?? '',
      fromTime: map['fromTime'] ?? '',
      toTime: map['toTime'] ?? '',
      isAllDay: map['isAllDay'] ?? '',
      toTimeType: map['toTimeType'] ?? '',
      // subcategory: map['subcategory'] ?? '',
      percentageValue: map['percentageValue'] ?? '',
      toDate: map['toDate'] ?? '',
      lifeTime: map['lifeTime'] ?? '',
      fromDate: map['fromDate'] ?? '',
      items: List<ItemModel>.from(
          map['items']?.map((item) => ItemModel.fromMap(item)) ?? []),
    );
  }
}

class ItemModel {
  String cuisineMenu;
  String cuisineName;
  String offer;
  List<RxString> itemImages;
  RxList<Uint8List> itemMemoryImages;

  ItemModel({
    required this.cuisineMenu,
    required this.cuisineName,
    required this.offer,
    required this.itemImages,
    required this.itemMemoryImages,
  });

  // Convert ItemModel to Map
  // ✅ Convert ItemModel to Map (Firestore now supports it)
  Map<String, dynamic> toMap() {
    return {
      'cuisineMenu': cuisineMenu,
      'cuisineName': cuisineName,
      'offer': offer,
      'itemImages': itemImages.map((e) => e.value).toList(), // Store URLs only
    };
  }

  // Create ItemModel from Map
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    ///images
    List<String> images = List<String>.from(map['itemImages']);
    List<RxString> itemImages = [];

    for (String image in images) {
      itemImages.add(RxString(image));
    }
    return ItemModel(
      cuisineMenu: map['cuisineMenu'] ?? '',
      cuisineName: map['cuisineName'] ?? '',
      offer: map['offer'] ?? '',
      itemImages: itemImages,
      itemMemoryImages: RxList<Uint8List>(),
    );
  }
}
