import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class StockChart extends StatefulWidget {
  final String symbol;

  const StockChart({Key? key, required this.symbol}) : super(key: key);

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  List<FlSpot> _chartData = [];
  bool _isLoading = true;
  String _errorMessage = '';
  double _minY = double.infinity;
  double _maxY = double.negativeInfinity;

  @override
  void initState() {
    super.initState();
    _fetchHistoricalData();
  }

  Future<void> _fetchHistoricalData() async {
    try {
      final data = await Provider.of<ApiService>(context, listen: false)
          .getStockHistory(widget.symbol);
      setState(() {
        _chartData = data.asMap().entries.map((entry) {
          final y = entry.value.close;
          if (y < _minY) _minY = y;
          if (y > _maxY) _maxY = y;
          return FlSpot(entry.key.toDouble(), y);
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching historical data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.symbol} Historical Data'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: _chartData.length.toDouble() - 1,
            minY: _minY,
            maxY: _maxY,
            lineBarsData: [
              LineChartBarData(
                spots: _chartData,
                isCurved: true,
                color: Colors.black87,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}