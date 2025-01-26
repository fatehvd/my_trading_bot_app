import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_trading_bot_app/config.dart';

class ApiService {
  /// دریافت موجودی کیف پول
  static Future<double> getWalletBalance(String walletAddress) async {
    final url = Uri.parse('${ApiEndpoints.getAddressBalance(walletAddress)}');

    try {
      final response = await http.get(
        url,
        headers: {
          "X-API-Key": apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // بررسی و تبدیل مقدار به double
        if (data['balance'] is String) {
          return double.tryParse(data['balance']) ?? 0.0;
        } else if (data['balance'] is num) {
          return (data['balance'] as num).toDouble();
        } else {
          throw Exception('Unexpected balance type');
        }
      } else {
        final error = json.decode(response.body)['error'] ?? 'Unknown error';
        throw Exception('Failed to fetch wallet balance: $error');
      }
    } catch (e) {
      throw Exception('Error in getWalletBalance: $e');
    }
  }

  /// دریافت تراکنش‌های کیف پول
  static Future<List<Map<String, dynamic>>> getWalletTransactions(
      String walletAddress) async {
    final url = Uri.parse('${ApiEndpoints.getTransactions(walletAddress)}');

    try {
      final response = await http.get(
        url,
        headers: {
          "X-API-Key": apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // تبدیل داده‌ها به لیست نقشه‌ها
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        } else {
          throw Exception('Unexpected transactions data type');
        }
      } else {
        final error = json.decode(response.body)['error'] ?? 'Unknown error';
        throw Exception('Failed to fetch wallet transactions: $error');
      }
    } catch (e) {
      throw Exception('Error in getWalletTransactions: $e');
    }
  }
}
