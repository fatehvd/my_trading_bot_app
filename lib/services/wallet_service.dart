import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/credentials.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_trading_bot_app/config.dart';

class WalletService {
  static String generateMnemonic() => bip39.generateMnemonic();

  static String getPrivateKeyFromMnemonic(String mnemonic) {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic');
    }
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    return seed.substring(0, 64);
  }

  static String getAddressFromPrivateKey(String privateKey) {
    final ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    return ethPrivateKey.address.hexEip55;
  }

  static Map<String, String> generateWallet() {
    final mnemonic = generateMnemonic();
    final privateKey = getPrivateKeyFromMnemonic(mnemonic);
    final address = getAddressFromPrivateKey(privateKey);

    return {
      'mnemonic': mnemonic,
      'privateKey': privateKey,
      'address': address,
    };
  }

  static Future<void> deposit(double amount) async {
    if (amount <= 0) throw Exception('Amount must be greater than zero.');
    final url = Uri.parse('$baseUrl/wallet/deposit');
    final body = json.encode({"amount": amount});

    try {
      final response = await http.post(
        url,
        headers: {
          "X-API-Key": apiKey,
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to deposit: $error');
      }
    } catch (e) {
      throw Exception('Error in deposit: $e');
    }
  }

  static Future<void> withdraw(double amount) async {
    if (amount <= 0) throw Exception('Amount must be greater than zero.');
    final url = Uri.parse('$baseUrl/wallet/withdraw');
    final body = json.encode({"amount": amount});

    try {
      final response = await http.post(
        url,
        headers: {
          "X-API-Key": apiKey,
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to withdraw: $error');
      }
    } catch (e) {
      throw Exception('Error in withdraw: $e');
    }
  }
}
