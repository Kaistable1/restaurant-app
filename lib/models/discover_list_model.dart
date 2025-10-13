import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverListModel {

  String name;
  String by;
  String description;
  String image;
  List<String> restaurantIdsList;

  DiscoverListModel({
    required this.name,
    required this.by,
    required this.description,
    required this.image,
    required this.restaurantIdsList,
  });

  static DiscoverListModel fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data()!;

    return DiscoverListModel(
        name: data['name'],
        by: data['by'],
        description: data['description'],
        image: data['image'],
        restaurantIdsList: data['restaurantIdsList']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'by': by,
      'description': description,
      'image': image,
      'restaurantIdsList': restaurantIdsList,
    };
  }
}