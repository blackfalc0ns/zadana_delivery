import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _formatterWithDecimals = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _formatterNoDecimals = NumberFormat('#,##0', 'en_US');

  /// Format price with thousands separators
  /// Shows decimals only if the price has fractional part
  /// Example: 5000000 -> "5,000,000"
  /// Example: 1500.6 -> "1,500.60"
  /// Example: 5600.29 -> "5,600.29"
  static String formatPrice(dynamic price) {
    if (price == null) return '0';

    double priceValue;
    if (price is String) {
      // Remove existing commas and parse
      priceValue = double.tryParse(price.replaceAll(',', '')) ?? 0.0;
    } else if (price is num) {
      priceValue = price.toDouble();
    } else {
      return '0';
    }

    // Check if the price is a whole number (no fractional part)
    if (priceValue == priceValue.truncateToDouble()) {
      return _formatterNoDecimals.format(priceValue);
    }
    
    return _formatterWithDecimals.format(priceValue);
  }

  /// Format price with currency symbol
  /// Example: formatPriceWithCurrency(1500.6, "EGP") -> "1,500.60 EGP"
  /// Example: formatPriceWithCurrency(5000000, "EGP") -> "5,000,000 EGP"
  static String formatPriceWithCurrency(dynamic price, String currency) {
    return '${formatPrice(price)} $currency';
  }

  /// Format price for Arabic display with currency
  /// Example: formatPriceArabic(1500.6, "جنيه") -> "1,500.60 جنيه"
  /// Example: formatPriceArabic(5000000, "جنيه") -> "5,000,000 جنيه"
  static String formatPriceArabic(dynamic price, String currency) {
    return '${formatPrice(price)} $currency';
  }

  /// Parse formatted price back to double
  /// Example: "1,500.60" -> 1500.6
  /// Example: "5,000,000" -> 5000000.0
  static double parseFormattedPrice(String formattedPrice) {
    return double.tryParse(formattedPrice.replaceAll(',', '')) ?? 0.0;
  }
}
