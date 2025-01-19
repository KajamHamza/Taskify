import 'dart:developer';

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
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    final categoryData = data['category'] as Map<String, dynamic>? ?? {};
    final category = CategoryModel.fromMap(categoryData);

    return ServiceModel(
      id: doc.id,
      providerId: data['providerId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      images: List<String>.from(data['images'] ?? []),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: category,
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as int?) ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
      location: map['location'] as GeoPoint,
      category: CategoryModel.fromMap(map['category']),
      rating: map['rating'],
      reviewCount: map['reviewCount'],
      isActive: map['isActive'],
      createdAt: map['createdAt'].toDate(),
    );
  }

 ServiceModel copyWith({
    String? id,
    String? providerId,
    String? title,
    String? description,
    List<String>? images,
    double? price,
    CategoryModel? category,
    GeoPoint? location,
    double? rating,
    int? reviewCount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      price: price ?? this.price,
      category: category ?? this.category,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}