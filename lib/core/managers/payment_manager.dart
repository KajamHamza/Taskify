import 'package:flutter_stripe/flutter_stripe.dart';
import '../services/payment_service.dart';

class PaymentManager {
  final PaymentService _paymentService;

  PaymentManager({PaymentService? paymentService})
      : _paymentService = paymentService ?? PaymentService();

  Future<void> processPayment({
    required String paymentIntentId,
    required double amount,
  }) async {
    try {
      // Get client secret
      final clientSecret = await _paymentService.getClientSecret(paymentIntentId);

      // Confirm payment with Stripe
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }
}