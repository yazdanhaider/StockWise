import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final String apiKey = 'Your_TwelveData_API_Key';
  final String baseUrl = 'https://api.twelvedata.com';

  Future<Stock> getStockQuote(String symbol) async {
    try {
      final url = '$baseUrl/quote?symbol=$symbol&apikey=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('symbol')) {
          return Stock(
            symbol: data['symbol'],
            name: data['name'],
            price: double.tryParse(data['close'] ?? '0') ?? 0.0,
            change: double.tryParse(data['change'] ?? '0') ?? 0.0,
            changePercent: double.tryParse(data['percent_change'] ?? '0') ?? 0.0,
            marketCap: double.tryParse(data['market_cap'] ?? '0') ?? 0.0,
            peRatio: double.tryParse(data['pe'] ?? '0') ?? 0.0,
          );
        } else {
          throw Exception('No data available for the given symbol');
        }
      } else {
        throw Exception('Failed to load stock data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getStockQuote: $e');
      rethrow;
    }
  }

  Future<List<StockHistory>> getStockHistory(String symbol, {String interval = '1day'}) async {
    try {
      final url = '$baseUrl/time_series?symbol=$symbol&interval=$interval&apikey=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<StockHistory> history = [];

        if (data['values'] != null) {
          for (var point in data['values']) {
            history.add(StockHistory(
              date: DateTime.tryParse(point['datetime'] ?? '') ?? DateTime.now(),
              close: double.tryParse(point['close'] ?? '0') ?? 0.0,
            ));
          }
        }
        return history;
      } else {
        throw Exception('Failed to fetch stock history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getStockHistory: $e');
      rethrow;
    }
  }

  Future<List<Stock>> searchStocks(String query) async {
    try {
      final url = '$baseUrl/symbol_search?symbol=$query&apikey=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Stock> stocks = [];

        if (data['data'] != null) {
          for (var item in data['data']) {
            stocks.add(Stock(
              symbol: item['symbol'] ?? '',
              name: item['instrument_name'] ?? '',
              price: 0, // We'll update this later
              change: 0,
              changePercent: 0,
              marketCap: 0,
              peRatio: 0,
            ));
          }
          stocks = await _updateStockPrices(stocks);
        }
        return stocks;
      } else {
        throw Exception('Failed to search stocks: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in searchStocks: $e');
      rethrow;
    }
  }

  Future<List<Stock>> _updateStockPrices(List<Stock> stocks) async {
    const batchSize = 5;
    List<Stock> updatedStocks = [];
    for (var i = 0; i < stocks.length; i += batchSize) {
      final batch = stocks.skip(i).take(batchSize);
      final updatedBatch = await Future.wait(batch.map((stock) async {
        try {
          final updatedStock = await getStockQuote(stock.symbol);
          return updatedStock;
        } catch (e) {
          debugPrint('Error updating stock data for ${stock.symbol}: $e');
          return stock;
        }
      }));
      updatedStocks.addAll(updatedBatch);
      await Future.delayed(Duration(seconds: 1));
    }
    return updatedStocks;
  }

  Future<double> getStockPrice(String symbol) async {
    try {
      final url = '$baseUrl/price?symbol=$symbol&apikey=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return double.tryParse(data['price'] ?? '0') ?? 0.0;
      } else {
        throw Exception('Failed to fetch stock price: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getStockPrice: $e');
      return 0.0; // Return 0 if there's an error
    }
  }
}

class StockHistory {
  final DateTime date;
  final double close;

  StockHistory({required this.date, required this.close});
}