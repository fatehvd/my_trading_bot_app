import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  final Map<String, double> balances;

  const BalanceWidget({required this.balances, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (balances.isEmpty) {
      return Center(
        child: Text(
          'No balances available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    double totalBalance = balances.values.reduce((a, b) => a + b);

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balances',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Balance: \$${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            ...balances.entries.map(
                  (entry) => ListTile(
                leading: Icon(_getIconForCurrency(entry.key)),
                title: Text(entry.key),
                trailing: Text(
                  entry.value.toStringAsFixed(4),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // برای نمایش جزئیات ارز، اینجا می‌توانید ناوبری اضافه کنید
                  print('Tapped on ${entry.key}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCurrency(String currency) {
    switch (currency.toLowerCase()) {
      case 'bitcoin':
        return Icons.currency_bitcoin;
      case 'ethereum':
        return Icons.show_chart;
      default:
        return Icons.monetization_on;
    }
  }
}
