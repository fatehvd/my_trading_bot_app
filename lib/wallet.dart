import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_trading_bot_app/services/api_service.dart';
import 'package:my_trading_bot_app/services/wallet_service.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  double balance = 0.0;
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String walletAddress = '';

  @override
  void initState() {
    super.initState();
    initializeWallet();
  }

  Future<void> initializeWallet() async {
    setState(() {
      isLoading = true;
    });

    try {
      walletAddress = (await secureStorage.read(key: 'walletAddress')) ?? '';
      if (walletAddress.isEmpty) {
        final wallet = WalletService.generateWallet();
        walletAddress = wallet['address']!;
        await secureStorage.write(key: 'walletAddress', value: walletAddress);
      }

      balance = await ApiService.getWalletBalance(walletAddress);
      transactions = await ApiService.getWalletTransactions(walletAddress);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Failed to load wallet data: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Wallet Address:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(walletAddress),
                  SizedBox(height: 20),
                  Text(
                    'Balance: \$${balance.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Expanded(
                    child: transactions.isEmpty
                        ? Center(child: Text('No transactions available.'))
                        : ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return ListTile(
                                title: Text('Hash: ${transaction['hash']}'),
                                subtitle: Text(
                                    'Value: ${transaction['value']} ETH'),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
