import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<Map<String, dynamic>> _symbols = [];
  final TextEditingController _symbolController = TextEditingController();

  Future<void> fetchSymbolData(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.binance.com/api/v3/ticker/24hr?symbol=${symbol.toUpperCase()}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _symbols.add({
            'symbol': symbol.toUpperCase(),
            'price': data['lastPrice'],
            'change': data['priceChangePercent'],
          });
        });
      } else {
        showErrorDialog('Symbol not found or API error.');
      }
    } catch (e) {
      showErrorDialog('Error fetching data. Check your internet connection.');
    }
  }

  void _addSymbol(String symbol) {
    if (symbol.isNotEmpty && !_symbols.any((item) => item['symbol'] == symbol.toUpperCase())) {
      fetchSymbolData(symbol);
    } else {
      showErrorDialog('Symbol already exists or is invalid.');
    }
  }

  void _removeSymbol(String symbol) {
    setState(() {
      _symbols.removeWhere((item) => item['symbol'] == symbol.toUpperCase());
    });
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSymbolDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Symbol'),
          content: TextField(
            controller: _symbolController,
            decoration: InputDecoration(hintText: 'Enter symbol (e.g., BTCUSDT)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final symbol = _symbolController.text.trim();
                if (symbol.isNotEmpty) {
                  _addSymbol(symbol);
                }
                _symbolController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
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
        title: Text('Watchlist'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _symbols.isEmpty
                  ? Center(
                      child: Text(
                        'No symbols added to the watchlist.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _symbols.length,
                      itemBuilder: (context, index) {
                        final symbol = _symbols[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              symbol['symbol'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Price: \$${symbol['price']}\nChange: ${symbol['change']}%',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeSymbol(symbol['symbol']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showAddSymbolDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              child: Text('Add Symbol'),
            ),
          ],
        ),
      ),
    );
  }
}
