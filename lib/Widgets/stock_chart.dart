import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChart extends StatefulWidget {
  final List<double> prices;
  final List<int> timestamps;

  StockChart({required this.prices, required this.timestamps});

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  late List<ChartData> _chartData;

  @override
  void initState() {
    super.initState();

    // Convert timestamps to DateTime objects
    final dateTimeList = widget.timestamps
        .map((timestamp) =>
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000))
        .toList();

    // Map DateTime objects to ChartData objects
    _chartData = List.generate(
      widget.prices.length,
      (index) => ChartData(dateTimeList[index], widget.prices[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255.0,
      child: SfCartesianChart(
        margin: EdgeInsets.only(left: 0),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enableDoubleTapZooming: true,
          enablePanning: true,
          enableSelectionZooming: true,
          enableMouseWheelZooming: true,
        ),
        primaryXAxis: DateTimeAxis(),
        series: <ChartSeries>[
          LineSeries<ChartData, DateTime>(
            dataSource: _chartData,
            xValueMapper: (ChartData data, _) => data.time,
            yValueMapper: (ChartData data, _) => data.price,
            color: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}

class ChartData {
  final DateTime time;
  final double price;

  ChartData(this.time, this.price);
}
