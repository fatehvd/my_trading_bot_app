import 'dart:convert';
import 'package:crypto/crypto.dart';

class ConverterUtils {
  /// تبدیل مقدار از Wei به ETH
  static double weiToEth(String wei) {
    final double value = double.tryParse(wei) ?? 0;
    return value / 1e18;
  }

  /// تبدیل مقدار از ETH به Wei
  static String ethToWei(double eth) {
    return (eth * 1e18).toStringAsFixed(0);
  }

  /// تولید هش از داده‌ها
  static String generateHash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
