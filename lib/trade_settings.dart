import 'package:flutter/material.dart';

class TradeSettingsPage extends StatefulWidget {
  @override
  _TradeSettingsPageState createState() => _TradeSettingsPageState();
}

class _TradeSettingsPageState extends State<TradeSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfTrades = 1;
  String _timeFrame = '1h';
  double _investmentAmount = 100.0;
  double _profitTarget = 10.0;
  double _stopLoss = 5.0;

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trade settings saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Settings'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Number of Trades
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Number of Trades',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _numberOfTrades.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _numberOfTrades = int.parse(value!);
                },
              ),
              const SizedBox(height: 16),

              // Time Frame
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Time Frame (e.g., 1h, 4h, 1d)',
                  border: OutlineInputBorder(),
                ),
                initialValue: _timeFrame,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid time frame';
                  }
                  return null;
                },
                onSaved: (value) {
                  _timeFrame = value!;
                },
              ),
              const SizedBox(height: 16),

              // Investment Amount
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Investment Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _investmentAmount.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _investmentAmount = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),

              // Profit Target
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Profit Target (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _profitTarget.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid percentage';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profitTarget = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),

              // Stop Loss
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Stop Loss (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _stopLoss.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid percentage';
                  }
                  return null;
                },
                onSaved: (value) {
                  _stopLoss = double.parse(value!);
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
