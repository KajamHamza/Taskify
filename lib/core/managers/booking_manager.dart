import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/service_request_model.dart';
import '../services/booking_service.dart';
import '../services/payment_service.dart';
import '../services/notification_service.dart';

class BookingManager {
  final BookingService _bookingService;
  final PaymentService _paymentService;
  final NotificationService _notificationService;

  BookingManager({
    BookingService? bookingService,
    PaymentService? paymentService,
    NotificationService? notificationService,
  }) : _bookingService = bookingService ?? BookingService(),
        _paymentService = paymentService ?? PaymentService(),
        _notificationService = notificationService ?? NotificationService();

  Future<String> createBooking({
    required String serviceId,
    required String clientId,
    required String providerId,
    required double proposedPrice,
    required DateTime bookingDateTime,
    required GeoPoint location,
    required String paymentMethod,
  }) async {
    // Validate booking date
    if (bookingDateTime.isBefore(DateTime.now())) {
      throw Exception('Cannot book for past dates');
    }

    String? paymentIntentId;

    // Create payment intent if payment method is online
    if (paymentMethod == 'online') {
      log('Creating payment intent for online payment...');
      final paymentIntent = await _paymentService.createPaymentIntent(
        amount: (proposedPrice * 100).round().toString(), // Convert to cents
        currency: 'usd',
        customerId: clientId,
      );
      paymentIntentId = paymentIntent['id'];
      log('Payment Intent ID: $paymentIntentId');
    } else {
      log('Payment method is cash. No payment intent created.');
    }

    // Generate a unique booking ID
    final bookingId = const Uuid().v4(); // Generate a unique ID
    log('Generated Booking ID: $bookingId');

    // Create booking
    log('Creating booking...');
    await _bookingService.createBooking(
      id: bookingId, // Pass the bookingId to the BookingService
      serviceId: serviceId,
      clientId: clientId,
      providerId: providerId,
      proposedPrice: proposedPrice,
      bookingDateTime: bookingDateTime,
      location: location,
      paymentIntentId: paymentIntentId, // Pass null for cash payments
    );
    log('Booking created with ID: $bookingId');

    // Notify provider
    log('Notifying provider...');
    // await _notificationService.sendNotification(
//   userId: providerId,
//   title: 'New Booking Request',
//   body: 'You have a new booking request',
//   data: {'bookingId': bookingId},
// );

    return bookingId; // Return the bookingId
  }

  Future<void> confirmPayment(String paymentIntentId) async {
    await _paymentService.confirmPayment(paymentIntentId);
  }
}