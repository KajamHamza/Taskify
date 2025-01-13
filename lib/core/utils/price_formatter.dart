import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String formatPrice(double price) {
    return _currencyFormat.format(price);
  }

  static String formatPriceWithoutSymbol(double price) {
    return _currencyFormat.format(price).replaceAll('\$', '');
  }

  static double calculateCommission(double price) {
    return price * 0.20; // 20% commission
  }

  static double calculateProviderAmount(double price) {
    return price * 0.80; // 80% for provider
  }
}