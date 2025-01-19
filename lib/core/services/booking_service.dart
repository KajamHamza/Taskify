import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/service_request_model.dart';
import '../utils/constants.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createBooking({
    required String id, // Accept the bookingId
    required String serviceId,
    required String clientId,
    required String providerId,
    required double proposedPrice,
    required DateTime bookingDateTime,
    required GeoPoint location,
    String? paymentIntentId, // Make it optional
  }) async {
    try {
      final request = ServiceRequestModel(
        id: id, // Use the passed bookingId
        serviceId: serviceId,
        clientId: clientId,
        providerId: providerId,
        proposedPrice: proposedPrice,
        status: RequestStatus.pending,
        createdAt: DateTime.now(),
        paymentIntentId: paymentIntentId, // Pass null for cash payments
      );

       await _db
          .collection(AppConstants.requestsCollection)
          .doc(id) // Use the bookingId as the document ID
          .set(request.toMap());

      log('Booking saved with ID: $id');
      return id; // Return the bookingId
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<void> updateBookingStatus(String bookingId, RequestStatus status) async {
    try {
      await _db
          .collection(AppConstants.requestsCollection)
          .doc(bookingId)
          .update({
        'status': status.toString(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  Stream<ServiceRequestModel> getBooking(String bookingId) {
    return _db
        .collection(AppConstants.requestsCollection)
        .doc(bookingId)
        .snapshots()
        .map((doc) => ServiceRequestModel.fromFirestore(doc));
  }

  Stream<List<ServiceRequestModel>> getClientBookings(
      String clientId,
      RequestStatus? status,
      ) {
    Query query = _db
        .collection(AppConstants.requestsCollection)
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status.toString());
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ServiceRequestModel.fromFirestore(doc)).toList());
  }

  Stream<List<ServiceRequestModel>> getProviderBookings(
      String providerId,
      RequestStatus? status,
      ) {
    Query query = _db
        .collection(AppConstants.requestsCollection)
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status.toString());
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ServiceRequestModel.fromFirestore(doc)).toList());
  }
}