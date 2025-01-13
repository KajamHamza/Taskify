import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String serviceId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? images;

  ReviewModel({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.userName,
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
      serviceId: data['serviceId'],
      userId: data['userId'],
      userName: data['userName'],
      userPhotoUrl: data['userPhotoUrl'],
      rating: data['rating'].toDouble(),
      comment: data['comment'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      images: data['images'] != null ? List<String>.from(data['images']) : null,
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
      'createdAt': Timestamp.fromDate(createdAt),
      'images': images,
    };
  }
}