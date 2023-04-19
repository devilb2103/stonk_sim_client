import 'dart:convert';

import 'package:stonk_sim_client/Models/stock_details_model.dart';
import 'package:stonk_sim_client/network_vars.dart';

StockDetails getStockDetails(int index) {
  final String companyName =
      tickerNames[wishList.keys.toList()[index].toString()].toString();
  final String ticker = wishList.keys.toList()[index].toString();
  final String currentPrice = "${wishList.values.toList()[index][0]}";
  final String priceChange = "${wishList.values.toList()[index][1]}";
  final String priceChangeP = wishList.values.toList()[index][2] + "%";
  final String openingPrice = "${wishList.values.toList()[index][3]}";
  final String previousClosingPrice = "${wishList.values.toList()[index][4]}";
  final String volume = "${wishList.values.toList()[index][5]}";
  final String dailyRange = "${wishList.values.toList()[index][6]}";
  return StockDetails(
      companyName: companyName,
      ticker: ticker,
      currentPrice: currentPrice,
      priceChange: priceChange,
      priceChangeP: priceChangeP,
      openingPrice: openingPrice,
      previousClosingPrice: previousClosingPrice,
      volume: volume,
      dailyRange: dailyRange);
}

List<dynamic> getGraphData(int index) {
  String data = wishList.values.toList()[index][7].toString();
  List<dynamic> parsedData = jsonDecode(data);

  List<List<dynamic>> convertedData = [
    parsedData[0].cast<int>(),
    parsedData[1].cast<double>(),
  ];
  return convertedData;
}
