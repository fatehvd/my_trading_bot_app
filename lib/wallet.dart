import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double balance = 0.0;
  List<Map<String, dynamic>> transactions = [];
  final String apiKey = "YOUR_API_KEY_HERE";

  @override
  void initState() {
    super.initState();
    fetchBalance();
    fetchTransactions();
  }

  Future<void> fetchBalance() async {
    final url = Uri.parse("https://api.example.com/balance");
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $apiKey"},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          balance = data['balance'];
        });
      } else {
        showErrorDialog("Failed to fetch balance.");
      }
    } catch (e) {
      showErrorDialog("Error: $e");
    }
  }

  Future<void> fetchTransactions() async {
    final url = Uri.parse("https://api.example.com/transactions");
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $apiKey"},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          transactions = List<Map<String, dynamic>>.from(data['transactions']);
        });
      } else {
        showErrorDialog("Failed to fetch transactions.");
      }
    } catch (e) {
      showErrorDialog("Error: $e");
    }
  }

  Future<void> updateBalanceAPI(double amount, bool isDeposit) async {
    final url = Uri.parse("https://api.example.com/update-balance");
    final body = json.encode({
      "amount": amount,
      "type": isDeposit ? "deposit" : "withdraw",
    });

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        fetchBalance();
        fetchTransactions();
      } else {
        showErrorDialog("Failed to update balance.");
      }
    } catch (e) {
      showErrorDialog("Error: $e");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showDepositDialog() {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Deposit Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Amount'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  updateBalanceAPI(amount, true);
                  Navigator.of(context).pop();
                } else {
                  showErrorDialog('Invalid amount');
                }
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showWithdrawDialog() {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Withdraw Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Amount'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  updateBalanceAPI(amount, false);
                  Navigator.of(context).pop();
                } else {
                  showErrorDialog('Invalid amount');
                }
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Wallet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Balance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyan),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: showDepositDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          'Deposit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: showWithdrawDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          'Withdraw',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Transaction History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          title: Text(
                            '${transaction['type']}: \$${transaction['amount'].toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            transaction['date'].toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
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
