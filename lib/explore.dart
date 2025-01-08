import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // Mock data
  final List<String> _allSymbols = ['BTC', 'ETH', 'SOL', 'ADA', 'XRP', 'DOT', 'MATIC'];
  List<String> _filteredSymbols = [];

  @override
  void initState() {
    super.initState();
    _filteredSymbols = _allSymbols; // Initialize with all symbols
  }

  void _filterSymbols(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSymbols = _allSymbols;
      } else {
        _filteredSymbols = _allSymbols
            .where((symbol) => symbol.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search symbols...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _filterSymbols(value),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredSymbols.isEmpty
                  ? Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredSymbols.length,
                      itemBuilder: (context, index) {
                        final symbol = _filteredSymbols[index];
                        return ListTile(
                          title: Text(
                            symbol,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(Icons.arrow_forward, color: Colors.cyan),
                          onTap: () {
                            print('Selected symbol: $symbol'); // Log for testing
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
