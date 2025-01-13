import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceModel {
  final String id;
  final String providerId;
  final String title;
  final String description;
  final List<String> images;
  final double price;
  final CategoryModel category;
  final GeoPoint location;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    required this.category,
    required this.location,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      providerId: data['providerId'],
      title: data['title'],
      description: data['description'],
      images: List<String>.from(data['images']),
      price: data['price'].toDouble(),
      category: CategoryModel.fromFirestore(doc.reference.parent.parent!.get() as DocumentSnapshot<Object?>),
      location: data['location'],
      rating: data['rating']?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'title': title,
      'description': description,
      'images': images,
      'price': price,
      'category': category.toMap(),
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      providerId: map['providerId'],
      title: map['title'],
      description: map['description'],
      images: List<String>.from(map['images']),
      price: map['price'],
      location: GeoPoint(map['location']['latitude'], map['location']['longitude']),
      category: map['category'],
      rating: map['rating'],
      reviewCount: map['reviewCount'],
      isActive: map['isActive'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}