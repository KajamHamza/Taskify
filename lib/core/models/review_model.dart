import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String serviceId; // Make nullable
  final String userId; // Make nullable
  final String? userName; // Already nullable
  final String? userPhotoUrl; // Already nullable
  final double rating; // Make nullable
  final String comment; // Make nullable
  final DateTime createdAt; // Make nullable
  final List<String>? images; // Already nullable

  ReviewModel({
    required this.id,
    required this.serviceId,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ReviewModel(
      id: doc.id,
      serviceId: data['serviceId'] as String,
      userId: data['userId'] as String,
      userName: data['userName'] as String?,
      userPhotoUrl: data['userPhotoUrl'] as String?,
      rating: data['rating'],
      comment: data['comment'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'images': images,
    };
  }
}