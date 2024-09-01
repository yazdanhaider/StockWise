import 'package:flutter/foundation.dart';

class Stock {
  final String symbol;
  final String? name;
  final double price;
  final double change;
  final double changePercent;
  final double marketCap;
  final double peRatio;

  Stock({
    required this.symbol,
    this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.marketCap,
    required this.peRatio,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      name: json['name'],
      price: double.tryParse(json['close'] ?? '0') ?? 0.0,
      change: double.tryParse(json['change'] ?? '0') ?? 0.0,
      changePercent: double.tryParse(json['percent_change'] ?? '0') ?? 0.0,
      marketCap: double.tryParse(json['market_cap'] ?? '0') ?? 0.0,
      peRatio: double.tryParse(json['pe_ratio'] ?? '0') ?? 0.0,
    );
  }

  Stock copyWith({
    String? symbol,
    String? name,
    double? price,
    double? change,
    double? changePercent,
    double? marketCap,
    double? peRatio,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      marketCap: marketCap ?? this.marketCap,
      peRatio: peRatio ?? this.peRatio,
    );
  }
}

class StockModel extends ChangeNotifier {
  List<Stock> _watchlist = [];

  List<Stock> get watchlist => _watchlist;

  void addToWatchlist(Stock stock) {
    if (!_watchlist.any((s) => s.symbol == stock.symbol)) {
      _watchlist.add(stock);
      notifyListeners();
    }
  }

  void removeFromWatchlist(Stock stock) {
    _watchlist.removeWhere((s) => s.symbol == stock.symbol);
    notifyListeners();
  }

  void updateStock(Stock updatedStock) {
    final index = _watchlist.indexWhere((s) => s.symbol == updatedStock.symbol);
    if (index != -1) {
      _watchlist[index] = updatedStock;
      notifyListeners();
    }
  }
}