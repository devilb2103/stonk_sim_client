import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonk_sim_client/Cubits/cubit/wishlist_cubit.dart';
import 'package:stonk_sim_client/Screens/dashboard_screen.dart';
import 'package:stonk_sim_client/account_vars.dart';
import 'package:stonk_sim_client/network_vars.dart';

void loadBalance(BuildContext context) {
  dynamic loadedbalance = prefs.getDouble('balance');
  if (loadedbalance != null) {
    balance = loadedbalance;
  }
}

void loadSavedStocks(BuildContext context) {
  dynamic loadedTickers = prefs.getString('tickers');
  if (loadedTickers != null) {
    tickerNames = json.decode(loadedTickers);
  }
  tickerNames.forEach((key, value) {
    context.read<WishlistCubit>().addTicker(key);
    // print(key);
  });
}

void loadPurchases(BuildContext context) {
  dynamic loadedPurchases = prefs.getString('purchases');
  if (loadedPurchases != null) {
    Map<String, dynamic> nonTypeCasted = json.decode(loadedPurchases);

    Map<String, Map<String, double>> typeCasted = {};

    nonTypeCasted.forEach((key, value) {
      Map<String, double> nestedMap = {};
      value.forEach((nestedKey, nestedValue) {
        nestedMap[nestedKey] = nestedValue.toDouble();
      });
      typeCasted[key] = nestedMap;
    });

    purchases = typeCasted;
  }
}

void loadAppData(BuildContext context) {
  loadBalance(context);
  loadSavedStocks(context);
  loadPurchases(context);
  if (appstart) {
    context.read<WishlistCubit>().updateWishlist();
    appstart = false;
  }
}

void saveAppData() {
  prefs.setDouble('balance', balance);
  prefs.setString('purchases', json.encode(purchases));
  prefs.setString('tickers', json.encode(tickerNames));
}
