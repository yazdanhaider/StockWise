import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stock_model.dart';
import '../services/api_service.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 0,
      ),
      body: Consumer<StockModel>(
        builder: (context, stockModel, child) {
          if (stockModel.watchlist.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stockModel.watchlist.length,
            itemBuilder: (context, index) {
              final stock = stockModel.watchlist[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _refreshStockDetails(context, stock),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock.symbol,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                stock.name ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${stock.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            stockModel.removeFromWatchlist(stock);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from Wishlist'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _refreshStockDetails(BuildContext context, Stock stock) async {
    try {
      final updatedStock = await context.read<ApiService>().getStockQuote(stock.symbol);
      context.read<StockModel>().removeFromWatchlist(stock);
      context.read<StockModel>().addToWatchlist(updatedStock);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock details updated'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating stock details: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}