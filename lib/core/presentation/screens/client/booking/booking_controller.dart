import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../managers/booking_manager.dart';
import '../../../../managers/payment_manager.dart';
import '../../../../models/service_model.dart';


class BookingController {
  final BookingManager _bookingManager;
  final PaymentManager _paymentManager;

  BookingController({
    BookingManager? bookingManager,
    PaymentManager? paymentManager,
  }) : _bookingManager = bookingManager ?? BookingManager(),
        _paymentManager = paymentManager ?? PaymentManager();

  Future<String> createBooking({
    required ServiceModel service,
    required String clientId,
    required DateTime bookingDateTime,
    required GeoPoint location,
  }) async {
    try {
      // Create booking and payment intent
      final bookingId = await _bookingManager.createBooking(
        serviceId: service.id,
        clientId: clientId,
        providerId: service.providerId,
        proposedPrice: service.price,
        bookingDateTime: bookingDateTime,
        location: location,
      );

      return bookingId;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<void> processPayment(String paymentIntentId, double amount) async {
    try {
      await _paymentManager.processPayment(
        paymentIntentId: paymentIntentId,
        amount: amount,
      );
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }
}