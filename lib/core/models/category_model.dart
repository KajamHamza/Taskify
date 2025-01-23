import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id, // Always use the document ID
      name: data['name'] as String ?? '', // Handle null
      imageUrl: data['imageUrl'], // Handle null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in the map
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String? ?? '', // Handle null
      name: map['name'] as String? ?? '', // Handle null
      imageUrl: map['imageUrl'], // Handle null
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, imageUrl: $imageUrl)';
  }
}