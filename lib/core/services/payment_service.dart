import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static const String _backendUrl = 'YOUR_BACKEND_URL'; // Replace with your backend URL

  Future<Map<String, dynamic>> createPaymentIntent({
    required String amount,
    required String currency,
    required String customerId,
  }) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'customer': customerId,
      };

      var response = await http.post(
        Uri.parse('$_backendUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  Future<void> processPayment({
    required String paymentIntentClientSecret,
    required String amount,
  }) async {
    try {
      // Confirm the payment with Stripe
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntentClientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }

  Future<void> setupStripeCustomer({
    required String email,
    required String userId,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$_backendUrl/create-stripe-customer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'userId': userId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create Stripe customer');
      }
    } catch (e) {
      throw Exception('Failed to setup Stripe customer: $e');
    }
  }

  Future<void> confirmPayment(String paymentIntentId) async {
  try {
    var response = await http.post(
      Uri.parse('$_backendUrl/confirm-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to confirm payment');
    }
  } catch (e) {
    throw Exception('Payment confirmation failed: $e');
  }
}

  Future<String> getClientSecret(String paymentIntentId) async {
  try {
    var response = await http.post(
      Uri.parse('$_backendUrl/get-client-secret'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData['clientSecret'];
    } else {
      throw Exception('Failed to get client secret');
    }
  } catch (e) {
    throw Exception('Failed to get client secret: $e');
  }
}
}