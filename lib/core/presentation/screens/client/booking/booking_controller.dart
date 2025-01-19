import 'dart:developer';

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
    required String paymentMethod,
  }) async {
    try {
      // Validate parameters
      if (service == null || clientId.isEmpty || bookingDateTime == null || location == null || paymentMethod.isEmpty) {
        throw Exception('Invalid parameters: One or more required parameters are null or empty.');
      }

      // Log parameters
      log('Creating booking with parameters:');
      log('Service: ${service.toString()}');
      log('Client ID: $clientId');
      log('Booking DateTime: $bookingDateTime');
      log('Location: $location');
      log('Payment Method: $paymentMethod');

      // Create booking
      final bookingId = await _bookingManager.createBooking(
        serviceId: service.id,
        clientId: clientId,
        providerId: service.providerId,
        proposedPrice: service.price,
        bookingDateTime: bookingDateTime,
        location: location,
        paymentMethod: paymentMethod, // Pass paymentMethod here
      );

      if (bookingId == null) {
        throw Exception('Failed to create booking: Booking ID is null.');
      }

      // Process payment if online
      if (paymentMethod == 'online') {
        if (service.price == null) {
          throw Exception('Invalid price for online payment: Price is null.');
        }
        await _paymentManager.processPayment(
          paymentIntentId: bookingId,
          amount: service.price,
        );
      }

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