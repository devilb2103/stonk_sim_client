import 'dart:convert';

import 'package:stonk_sim_client/Screens/dashboard_screen.dart';
import 'package:stonk_sim_client/Utils/stock_data_utils.dart';
import 'package:stonk_sim_client/account_vars.dart';
import 'package:stonk_sim_client/network_vars.dart';

dynamic buyShares(String ticker, double price, double quantity) {
  try {
    // if no errors
    if (balance >= (quantity * price)) {
      balance -= (price * quantity); //cut paisa
      balance = double.parse(balance.toStringAsFixed(2));
      // add purchase
      if (!purchases.containsKey(ticker)) {
        purchases[ticker] = {price.toString(): quantity};
      } else if (!purchases[ticker]!.containsKey(price.toString())) {
        purchases[ticker]![price.toString()] = quantity;
      } else {
        purchases[ticker]![price.toString()] =
            purchases[ticker]![price.toString()]! + quantity;
      }
      prefs.setString('purchases', json.encode(purchases));
      prefs.setDouble('balance', balance);
      return true;
    } else {
      return "Insufficient funds";
    }
  } catch (e) {
    // if error
    return e.toString();
  }
}

List<double> calculatePortfolio() {
  double bal = balance; // unused credit balance
  double currAssetValue = bal;
  double idealAssetValue = bal;

  // initialized profit and profitP
  double profit = 0;
  double profitP = 0;

  // add all assets to balance
  purchases.forEach((symbol, shares) {
    shares.forEach((price, quantity) {
      bal += double.parse(price) * quantity;
    });
  });

  // if prices of purchased stocks are loaded
  if (wishList != {}) {
    bal = balance; // unused credit balance

    // add prices of bought shares to unused credit balance
    purchases.forEach((symbol, shares) {
      double currPrice =
          double.parse(getStockDetailsByTicker(symbol).currentPrice);
      shares.forEach((price, quantity) {
        currAssetValue += currPrice * quantity;
      });
    });

    // calculate profit and profitP now
    // profit calc
    purchases.forEach((symbol, shares) {
      shares.forEach((price, quantity) {
        idealAssetValue += (double.parse(price) * quantity);
      });
    });
  }

  profit = currAssetValue - idealAssetValue;
  profitP = (profit / idealAssetValue) * 100;

  currAssetValue = double.parse(currAssetValue.toStringAsFixed(2));
  profit = double.parse(profit.toStringAsFixed(3));
  profitP = double.parse(profitP.toStringAsFixed(2));
  return [currAssetValue, profit, profitP];
}

dynamic getTickerPurchases(String ticker) {
  if (purchases.containsKey(ticker) && purchases[ticker]!.isNotEmpty) {
    return purchases[ticker]!;
  } else {
    return null;
  }
}

void sellShare(String ticker, String price) {
  balance += double.parse(price) * purchases[ticker]![price]!;
  purchases[ticker]!.remove(price);
}
