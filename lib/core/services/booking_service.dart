import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request_model.dart';
import '../utils/constants.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createBooking({
    required String serviceId,
    required String clientId,
    required String providerId,
    required double proposedPrice,
    required DateTime bookingDateTime,
    required GeoPoint location, required paymentIntentId,
  }) async {
    try {
      final request = ServiceRequestModel(
        id: '',
        serviceId: serviceId,
        clientId: clientId,
        providerId: providerId,
        proposedPrice: proposedPrice,
        status: RequestStatus.pending,
        createdAt: DateTime.now(),
      );

      final docRef = await _db
          .collection(AppConstants.requestsCollection)
          .add(request.toMap());

      return docRef.id;
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