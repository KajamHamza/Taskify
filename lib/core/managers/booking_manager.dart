import 'package:cloud_firestore/cloud_firestore.dart';
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
  }) async {
    // Validate booking date
    if (bookingDateTime.isBefore(DateTime.now())) {
      throw Exception('Cannot book for past dates');
    }

    // Create payment intent
    final paymentIntent = await _paymentService.createPaymentIntent(
      amount: (proposedPrice * 100).round().toString(), // Convert to cents
      currency: 'usd',
      customerId: clientId,
    );

    // Create booking
    final bookingId = await _bookingService.createBooking(
      serviceId: serviceId,
      clientId: clientId,
      providerId: providerId,
      proposedPrice: proposedPrice,
      bookingDateTime: bookingDateTime,
      location: location,
      paymentIntentId: paymentIntent['id'],
    );

    // Notify provider
    await _notificationService.sendNotification(
      userId: providerId,
      title: 'New Booking Request',
      body: 'You have a new booking request',
      data: {'bookingId': bookingId},
    );

    return bookingId;
  }

  Future<void> confirmPayment(String paymentIntentId) async {
    await _paymentService.confirmPayment(paymentIntentId);
  }
}