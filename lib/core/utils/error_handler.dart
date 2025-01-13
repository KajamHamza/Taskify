class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppError(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

class ErrorHandler {
  static AppError handleError(dynamic error) {
    if (error is AppError) {
      return error;
    }

    // Firebase Auth Errors
    if (error.toString().contains('user-not-found')) {
      return AppError('No user found with this email', code: 'user-not-found');
    }
    if (error.toString().contains('wrong-password')) {
      return AppError('Incorrect password', code: 'wrong-password');
    }
    if (error.toString().contains('email-already-in-use')) {
      return AppError('Email is already registered', code: 'email-already-in-use');
    }

    // Network Errors
    if (error.toString().contains('SocketException')) {
      return AppError('No internet connection', code: 'no-internet');
    }

    // Payment Errors
    if (error.toString().contains('payment_intent_failed')) {
      return AppError('Payment failed. Please try again.', code: 'payment-failed');
    }

    // Default Error
    return AppError('Something went wrong. Please try again.',
        originalError: error);
  }
}