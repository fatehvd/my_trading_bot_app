import 'package:flutter/material.dart';

class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<String> _symbols = [];

  void _addSymbol(String symbol) {
    setState(() {
      if (!_symbols.contains(symbol)) {
        _symbols.add(symbol);
        print('Symbol added: $symbol'); // لاگ برای تست
      } else {
        print('Symbol already exists: $symbol'); // لاگ برای تست
      }
    });
  }

  void _removeSymbol(String symbol) {
    setState(() {
      _symbols.remove(symbol);
      print('Symbol removed: $symbol'); // لاگ برای تست
    });
  }

  void _showAddSymbolDialog() {
    final TextEditingController _symbolController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Symbol'),
          content: TextField(
            controller: _symbolController,
            decoration: InputDecoration(hintText: 'Enter symbol (e.g., BTC)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newSymbol = _symbolController.text.trim();
                if (newSymbol.isNotEmpty) {
                  _addSymbol(newSymbol);
                }
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
                        return ListTile(
                          title: Text(
                            symbol,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _removeSymbol(symbol);
                            },
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showAddSymbolDialog();
              },
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
