import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/stock_model.dart';
import '../services/api_service.dart';
import '../widgets/stock_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Stock> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StockWise', style: TextStyle (fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade100],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Stocks',
                      suffixIcon: Icon(Icons.search, color: Colors.blue.shade800),
                      border: InputBorder.none,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
            ),

            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  SizedBox(height: 10),
                  Text(
                    "Searching for stocks...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              )
            else if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red.shade300, fontWeight: FontWeight.bold)),
              )
            else if (_searchResults.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No results found. Try searching for a stock symbol (e.g., AAPL, GOOGL)',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final stock = _searchResults[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(stock.symbol, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(stock.name ?? '', style: TextStyle(color: Colors.grey.shade600)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${stock.price.toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              SizedBox(width: 16),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.blue.shade800),
                                onPressed: () {
                                  context.read<StockModel>().addToWatchlist(stock);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added to Wishlist'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.show_chart, color: Colors.blue.shade800),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StockChart(symbol: stock.symbol),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () => _showStockDetails(context, stock),
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _searchStocks(context, query);
      } else {
        setState(() {
          _searchResults = [];
          _errorMessage = '';
        });
      }
    });
  }

  void _searchStocks(BuildContext context, String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final results = await context.read<ApiService>().searchStocks(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching stocks. Please try again later.';
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _showStockDetails(BuildContext context, Stock stock) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stock.symbol, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(stock.name ?? '', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
            SizedBox(height: 16),
            _buildDetailRow('Price', '\$${stock.price.toStringAsFixed(2)}'),
            _buildDetailRow('Change', '${stock.change.toStringAsFixed(2)} (${stock.changePercent.toStringAsFixed(2)}%)'),
            _buildDetailRow('Market Cap', '\$${stock.marketCap.toStringAsFixed(2)}'),
            _buildDetailRow('P/E Ratio', '${stock.peRatio.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}