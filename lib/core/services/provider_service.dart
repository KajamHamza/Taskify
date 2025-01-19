import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../utils/constants.dart';

class ProviderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createService({
    required String providerId,
    required String title,
    required String description,
    required List<String> images,
    required double price,
    required CategoryModel category,
    required GeoPoint location,
  }) async {
    try {
      final service = ServiceModel(
        id: '',
        providerId: providerId,
        title: title,
        description: description,
        images: images,
        price: price,
        category: category,
        location: location,
        rating: 0,
        reviewCount: 0,
        isActive: true,
        createdAt: DateTime.now(),
      );

      final docRef = await _db
          .collection(AppConstants.servicesCollection)
          .add(service.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  Future<String> updateService({
    required String serviceId,
    String? title,
    String? description,
    List<String>? images,
    double? price,
    required CategoryModel category,
    GeoPoint? location,
    bool? isActive,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (images != null) updates['images'] = images;
      if (price != null) updates['price'] = price;
      if (category != null) updates['category'] = category;
      if (location != null) updates['location'] = location;
      if (isActive != null) updates['isActive'] = isActive;

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _db
          .collection(AppConstants.servicesCollection)
          .doc(serviceId)
          .update(updates);

      return serviceId;
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

  Future<void> toggleServiceStatus(String serviceId, bool isActive) async {
    try {
      await _db
          .collection(AppConstants.servicesCollection)
          .doc(serviceId)
          .update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to toggle service status: $e');
    }
  }

  Stream<List<ServiceModel>> getProviderServices(String providerId) {
    return _db
        .collection(AppConstants.servicesCollection)
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ServiceModel.fromFirestore(doc)).toList());
  }

Future<void> createProvider({
    required String providerId,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final providerData = {
        'providerId': providerId,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _db.collection(AppConstants.providersCollection).doc(providerId).set(providerData);
    } catch (e) {
      throw Exception('Failed to create provider: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();
  }

}