import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionWidget({required this.transactions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (transactions.isEmpty)
              Center(
                child: Text(
                  'No transactions available.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final value = transaction['value'] ?? 0.0;
                    final dateStr = transaction['date'] ?? '';
                    DateTime? date;

                    // تلاش برای تبدیل تاریخ
                    try {
                      date = DateTime.parse(dateStr);
                    } catch (e) {
                      print('Invalid date format: $dateStr');
                    }

                    return ListTile(
                      leading: Icon(
                        value > 0 ? Icons.arrow_downward : Icons.arrow_upward,
                        color: value > 0 ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        'Hash: ${transaction['hash'] ?? 'Unknown'}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Value: $value\nDate: ${date != null ? DateFormat.yMMMd().format(date) : 'Invalid date'}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        // عملکرد در هنگام کلیک بر روی تراکنش
                        print('Tapped on transaction: ${transaction['hash']}');
                      },
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
