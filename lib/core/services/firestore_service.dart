import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/service_request_model.dart';
import 'dart:developer';

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
    DocumentReference ref = await _db.collection('services').add(
        service.toMap());
    return ref.id;
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

    return query.snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ServiceRequestModel.fromFirestore(doc))
            .toList());
  }

  Stream<ServiceRequestModel> getServiceRequest(String requestId) {
    return _db.collection('serviceRequests')
        .doc(requestId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        log('Service request fetched successfully: ${snapshot.data()}');
      } else {
        log('Service request not found: $requestId');
      }
      return ServiceRequestModel.fromFirestore(snapshot);
    });
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
          ((currentRating * currentReviewCount) + rating) /
              (currentReviewCount + 1);

      transaction.update(serviceRef, {
        'rating': newRating,
        'reviewCount': currentReviewCount + 1,
      });
    });
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

      Map<String, dynamic> mainCategory = {};
      if (mainCategorySnapshot.docs.isNotEmpty) {
        final doc = mainCategorySnapshot.docs.first;
        final availableCount = await _getAvailableServicesCount(doc.id);
        log('Main Category - Name: ${doc.get(
            'name')}, Available Count: $availableCount'); // Debug log
        mainCategory = {
          'name': doc.get('name'),
          'imageUrl': doc.get('imageUrl'),
          'availableCount': availableCount,
        };
      }

      final otherCategories = await Future.wait(
        otherCategoriesSnapshot.docs.map((doc) async {
          final availableCount = await _getAvailableServicesCount(doc.id);
          log('Other Category - Name: ${doc.get(
              'name')}, Available Count: $availableCount'); // Debug log
          return {
            'name': doc.get('name'),
            'imageUrl': doc.get('imageUrl'),
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
        .where('category.id', isEqualTo: categoryId)
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
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<ServiceModel>> getTopRatedServicesStream() {
    return _db
        .collection('services')
        .where('rating', isNotEqualTo: null) // Ensure documents have a rating
        .orderBy('rating', descending: true)
        .limit(5)
        .snapshots()
        .map((querySnapshot) {
      // Debug: Print the number of documents fetched
      log('Fetched ${querySnapshot.docs.length} documents');

      // Debug: Print each document's data
      querySnapshot.docs.forEach((doc) {
        log('Document ID: ${doc.id}, Data: ${doc.data()}');
      });

      return querySnapshot.docs.map((doc) {
        return ServiceModel.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<ServiceModel>> getServices({String? providerId}) {
    Query query = _db.collection('services');

    if (providerId != null) {
      query = query.where('providerId', isEqualTo: providerId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ServiceModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateService(ServiceModel updatedService) async {
    await _db.collection('services').doc(updatedService.id).update(
        updatedService.toMap());
  }

  Future<UserModel?> getServiceProviderById(String providerId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(providerId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    } else {
      return null;
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    DocumentSnapshot doc = await _db.collection('services')
        .doc(serviceId)
        .get();
    if (doc.exists) {
      return ServiceModel.fromFirestore(doc);
    } else {
      return null;
    }
  }

  static Future<String?> getUserName(String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users')
        .doc(userId)
        .get();
    if (doc.exists) {
      return doc['name'] as String?;
    } else {
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String photoUrl,
  }) async {
    await _db.collection('users').doc(userId).update({
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    });
  }

  Future<void> updateRequestStatus(String id, RequestStatus status, {required bool isPaid, required DateTime? completedAt}) async {
  await _db.collection('serviceRequests').doc(id).update({
    'status': status.toString(),
    'isPaid': isPaid,
    'completedAt': completedAt,
  });
}

  Future<String?> getServiceName(String serviceId) async {
  try {
    DocumentSnapshot doc = await _db.collection('services').doc(serviceId).get();
    if (doc.exists) {
      return doc['name'] as String?;
    } else {
      return null;
    }
  } catch (e) {
    log('Error getting service name: $e');
    return null;
  }
}

  Future<String?> getClientNamebyID(String clientId) async {
  try {
    DocumentSnapshot doc = await _db.collection('users').doc(clientId).get();
    if (doc.exists) {
      return doc['name'] as String?;
    } else {
      return null;
    }
  } catch (e) {
    log('Error getting client name: $e');
    return null;
  }
}

}
