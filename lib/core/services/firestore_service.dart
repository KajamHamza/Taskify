import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/service_request_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Operations
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel> getUser(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    return UserModel.fromFirestore(doc);
  }

  // Service Operations
  Future<String> createService(ServiceModel service) async {
    DocumentReference ref = await _db.collection('services').add(service.toMap());
    return ref.id;
  }

  Stream<List<ServiceModel>> getServices({
    String? category,
    String? providerId,
    GeoPoint? nearLocation,
    double? maxPrice,
  }) {
    Query query = _db.collection('services').where('isActive', isEqualTo: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    if (providerId != null) {
      query = query.where('providerId', isEqualTo: providerId);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ServiceModel.fromFirestore(doc)).toList());
  }

  //get service Stream
  Stream<ServiceModel> getServiceStream(String serviceId) {
    return FirebaseFirestore.instance
        .collection('services')
        .doc(serviceId)
        .snapshots()
        .map((snapshot) => ServiceModel.fromFirestore(snapshot));
  }

  // Service Request Operations
  Future<String> createServiceRequest(ServiceRequestModel request) async {
    DocumentReference ref =
        await _db.collection('serviceRequests').add(request.toMap());
    return ref.id;
  }

  Stream<List<ServiceRequestModel>> getServiceRequests({
    String? clientId,
    String? providerId,
    RequestStatus? status,
  }) {
    Query query = _db.collection('serviceRequests');

    if (clientId != null) {
      query = query.where('clientId', isEqualTo: clientId);
    }
    if (providerId != null) {
      query = query.where('providerId', isEqualTo: providerId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status.toString());
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ServiceRequestModel.fromFirestore(doc))
        .toList());
  }

  Stream<ServiceRequestModel> getServiceRequest(String requestId) {
    return _db.collection('serviceRequests')
        .doc(requestId)
        .snapshots()
        .map((snapshot) => ServiceRequestModel.fromFirestore(snapshot));
  }

  Future<void> updateRequestStatus(
    String requestId,
    RequestStatus status,
  ) async {
    await _db
        .collection('serviceRequests')
        .doc(requestId)
        .update({'status': status.toString()});
  }

  // Reviews and Ratings
  Future<void> addReview({
    required String serviceId,
    required String userId,
    required double rating,
    required String comment, required List<String> images,
  }) async {
    await _db.collection('reviews').add({
      'serviceId': serviceId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update service rating
    DocumentReference serviceRef = _db.collection('services').doc(serviceId);
    await _db.runTransaction((transaction) async {
      DocumentSnapshot serviceDoc = await transaction.get(serviceRef);
      Map<String, dynamic> data = serviceDoc.data() as Map<String, dynamic>;

      int currentReviewCount = data['reviewCount'] ?? 0;
      double currentRating = data['rating'] ?? 0.0;

      double newRating =
          ((currentRating * currentReviewCount) + rating) / (currentReviewCount + 1);

      transaction.update(serviceRef, {
        'rating': newRating,
        'reviewCount': currentReviewCount + 1,
      });
    });
  }
  Stream<List<ReviewModel>> getServiceReviews(String serviceId) {
    // Implement the logic to fetch reviews from Firestore
    // For example:
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc.data() as DocumentSnapshot<Object?>))
        .toList());
  }

Future<bool> userExists(String uid) async {
  DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
  return doc.exists;
}

  Stream<UserModel> getUserStream(String userId) {
  return _db.collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) => UserModel.fromFirestore(snapshot));
}

  Stream<List<ServiceModel>> getTopServices() {
  return _db.collection('services')
      .orderBy('rating', descending: true)
      .limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ServiceModel.fromFirestore(doc))
          .toList());
}

 Future<void> deleteUser(String userId) async {
  await _db.collection('users').doc(userId).delete();
}

  Future<Map<String, dynamic>> searchServices(String query) async {
    try {
      // Get main category that matches the query
      final mainCategorySnapshot = await _db
          .collection('categories')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(1)
          .get();

      // Get other categories
      final otherCategoriesSnapshot = await _db
          .collection('categories')
          .where('name', isNotEqualTo: mainCategorySnapshot.docs.isNotEmpty
          ? mainCategorySnapshot.docs.first.get('name')
          : null)
          .limit(4)
          .get();

      Map<String, dynamic> mainCategory= {};
      if (mainCategorySnapshot.docs.isNotEmpty) {
        final doc = mainCategorySnapshot.docs.first;
        final availableCount = await _getAvailableServicesCount(doc.id);
        mainCategory = {
          'name': doc.get('name'),
          'image': doc.get('image'),
          'availableCount': availableCount,
        };
      }

      final otherCategories = await Future.wait(
        otherCategoriesSnapshot.docs.map((doc) async {
          final availableCount = await _getAvailableServicesCount(doc.id);
          return {
            'name': doc.get('name'),
            'image': doc.get('image'),
            'availableCount': availableCount,
          };
        }),
      );

      return {
        'mainCategory': mainCategory,
        'otherCategories': otherCategories,
      };
    } catch (e) {
      throw Exception('Failed to search services: $e');
    }
  }

  Future<int?> _getAvailableServicesCount(String categoryId) async {
    final snapshot = await _db
        .collection('services')
        .where('categoryId', isEqualTo: categoryId)
        .where('isActive', isEqualTo: true)
        .count()
        .get();

    return snapshot.count;
  }

  Stream<List<ServiceModel>> searchServiceStream(String query) {
    return _db
        .collection('services')
        .where('isActive', isEqualTo: true)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ServiceModel.fromFirestore(doc))
        .toList());
  }
}