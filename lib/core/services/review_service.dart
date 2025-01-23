import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../utils/constants.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> submitReview({
    required String serviceId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
    String? userPhotoUrl,
    List<String>? images,
  }) async {
    try {
      final review = ReviewModel(
        id: '',
        serviceId: serviceId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        images: images,
      );

      // Add review
      await _db.collection(AppConstants.reviewsCollection).add(review.toMap());

      // Update service rating
      final serviceRef = _db.collection(AppConstants.servicesCollection).doc(serviceId);

      await _db.runTransaction((transaction) async {
        final serviceDoc = await transaction.get(serviceRef);
        final data = serviceDoc.data() as Map<String, dynamic>;

        final currentRating = data['rating'] ?? 0.0;
        final currentReviewCount = data['reviewCount'] ?? 0;

        final newRating = ((currentRating * currentReviewCount) + rating) / (currentReviewCount + 1);

        transaction.update(serviceRef, {
          'rating': newRating,
          'reviewCount': currentReviewCount + 1,
        });
      });
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }

  Stream<List<ReviewModel>> getServiceReviews(String serviceId) {
    return _db
        .collection(AppConstants.reviewsCollection)
        .where('serviceId', isEqualTo: serviceId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
  }

  Stream<List<ReviewModel>> getClientServiceReviews(String clientId, String serviceId) {
    return _db
        .collection(AppConstants.reviewsCollection)
        .where('userId', isEqualTo: clientId)
        .where('serviceId', isEqualTo: serviceId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
    }
}