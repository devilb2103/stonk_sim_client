import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonk_sim_client/Cubits/cubit/wishlist_cubit.dart';
import 'package:stonk_sim_client/Models/stock_details_model.dart';
import 'package:stonk_sim_client/Utils/stock_data_utils.dart';
import 'package:stonk_sim_client/Utils/transaction_utils.dart';
import 'package:stonk_sim_client/Widgets/custom_textfield.dart';
import 'package:stonk_sim_client/Widgets/stock_chart.dart';
import 'package:stonk_sim_client/account_vars.dart';
import 'package:stonk_sim_client/colors.dart';

late BuildContext _localContext;

class StockDetailsScreen extends StatefulWidget {
  const StockDetailsScreen({super.key, required this.index});
  final int index;

  @override
  State<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    StockDetails details = getStockDetailsByIndex(widget.index);
    _localContext = context;
    return SafeArea(
      child: Scaffold(
          backgroundColor: backgroundColor,
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            // toolbarHeight: 48,
            backgroundColor: backgroundColor,
            elevation: 0,
            // automaticallyImplyLeading: false,
            title: Text(
              details.companyName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          body: Container(
              color: backgroundColor,
              width: double.maxFinite,
              height: double.maxFinite,
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistInitialState) {
                    return StockDetailsList(
                        details: details, index: widget.index);
                  } else {
                    return StockDetailsList(
                        details: details, index: widget.index);
                  }
                },
              ))),
    );
  }
}

class StockDetailsList extends StatefulWidget {
  const StockDetailsList(
      {super.key, required this.details, required this.index});
  final StockDetails details;
  final int index;

  @override
  State<StockDetailsList> createState() => _StockDetailsListState();
}

class _StockDetailsListState extends State<StockDetailsList> {
  TextStyle subTitleStyle = TextStyle(
      color: textColorDarkGrey, fontSize: 16, fontWeight: FontWeight.w300);
  TextStyle priceStyle = const TextStyle(
      color: textColorLightGrey, fontSize: 42, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    //
    // final Map<dynamic, dynamic> graphData = getGraphData(widget.index);
    // final List<int> timestamps = graphData[0];
    // final List<double> prices = graphData[1];
    //
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Price", style: subTitleStyle),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("\$${widget.details.currentPrice}", style: priceStyle),
              const SizedBox(width: 6),
              ProfitPIndicator(profitP: widget.details.priceChangeP)
            ],
          ),

          // graph placeholder
          const SizedBox(height: 12),
          StockChart(
              prices: getGraphData(widget.index)[1],
              timestamps: getGraphData(widget.index)[0]),
          // Placeholder(
          //   child: Container(
          //       height: 180,
          //       child: Center(
          //           child: Text(
          //               "Graph that may or may not exist/update \n(needs server to be a hybrid of REST and SocketIO)",
          //               textAlign: TextAlign.center,
          //               style: subTitleStyle))),
          // ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                // Current Price Indicator

                const SizedBox(height: 20),
                const SizedBox(height: 10),
                DetailsItem(details: [
                  "Opening Price",
                  "\$ ${widget.details.openingPrice}"
                ]),

                Divider(color: textColorDarkGrey),

                DetailsItem(details: [
                  "Previous Closing Price",
                  "\$ ${widget.details.previousClosingPrice}"
                ]),

                Divider(color: textColorDarkGrey),

                DetailsItem(details: [
                  "Daily Range",
                  "\$ ${widget.details.dailyRange}"
                ]),

                Divider(color: textColorDarkGrey),

                DetailsItem(details: ["Volume", (widget.details.volume)]),
                Divider(color: textColorDarkGrey),
              ],
            ),
          ),
          PurchaseButtons(
            currentPrice: double.parse(widget.details.currentPrice),
            ticker: widget.details.ticker,
          )
        ],
      ),
    );
  }
}

class PurchaseButtons extends StatefulWidget {
  const PurchaseButtons(
      {super.key, required this.currentPrice, required this.ticker});
  final double currentPrice;
  final String ticker;

  @override
  State<PurchaseButtons> createState() => _PurchaseButtonsState();
}

class _PurchaseButtonsState extends State<PurchaseButtons> {
  @override
  Widget build(BuildContext context) {
    //
    const TextStyle style =
        TextStyle(fontWeight: FontWeight.w400, fontSize: 18);
    //
    return Container(
      color: Colors.transparent,
      height: 63,
      width: double.maxFinite,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Material(
              color: lossColor,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: () {
                  sellPopup(context, widget.ticker);
                },
                borderRadius: BorderRadius.circular(50),
                child: const SizedBox(
                  height: double.maxFinite,
                  child: Center(
                    child: Text("Sell", style: style),
                  ),
                ),
              ),
            )),
            const SizedBox(width: 9),
            Expanded(
                child: Material(
              color: profitColor,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: () {
                  buyPopup(context, widget.currentPrice, widget.ticker);
                },
                borderRadius: BorderRadius.circular(50),
                child: const SizedBox(
                  height: double.maxFinite,
                  child: Center(
                    child: Text("Buy", style: style),
                  ),
                ),
              ),
            ))
          ]),
    );
  }
}

class DetailsItem extends StatelessWidget {
  const DetailsItem({super.key, required this.details});
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    //
    TextStyle subTitleStyle = TextStyle(
        color: textColorDarkGrey, fontSize: 16, fontWeight: FontWeight.w300);
    TextStyle valueStyle = const TextStyle(
        color: textColorLightGrey, fontSize: 16, fontWeight: FontWeight.w500);
    //
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              details[0],
              style: subTitleStyle,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              details[1],
              textAlign: TextAlign.right,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfitPIndicator extends StatelessWidget {
  const ProfitPIndicator({super.key, required this.profitP});
  final String profitP;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      child: Card(
        color: (double.parse(profitP) >= 0) ? profitColor : lossColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$profitP%",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

void buyPopup(BuildContext context, double currentPrice, String ticker) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return buyStockWidget(
        currentPrice: currentPrice,
        ticker: ticker,
      );
    },
  );
}

void sellPopup(BuildContext context, String ticker) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return sellStockWidget(
        ticker: ticker,
      );
    },
  );
}

class buyStockWidget extends StatefulWidget {
  buyStockWidget({super.key, required this.currentPrice, required this.ticker});

  final double currentPrice;
  final String ticker;

  @override
  State<buyStockWidget> createState() => _buyStockWidgetState();
  TextEditingController quantity = TextEditingController();
}

class _buyStockWidgetState extends State<buyStockWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // alignment: Alignment.centerRight,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      // title: Text(
      //   "Buy Shares",
      //   style: TextStyle(color: textColorLightGrey),
      // ),
      content: SizedBox(
        height: 180,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your balance: \$ ${double.parse(balance.toStringAsFixed(2))}",
                style: const TextStyle(
                    color: textColorLightGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 21),
              CustomTextField(
                controller: widget.quantity,
                hintText: "Share Quantity",
                maxLines: 1,
                formatter:
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                onChanged: (String text) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              Text(
                widget.quantity.text.isNotEmpty
                    ? "Cost: \$ ${(double.parse(widget.quantity.text.toString()) * widget.currentPrice).toStringAsFixed(2)}"
                    : "Cost: \$ 0",
                style: const TextStyle(
                    color: textColorLightGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ]),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Buy"),
          onPressed: () {
            dynamic transactionStatus = buyShares(
                widget.ticker,
                widget.currentPrice,
                double.parse(widget.quantity.text.toString()));
            if (transactionStatus == true) {
              _localContext.read<WishlistCubit>().updateWishlist();
              Navigator.of(context).pop();
            } else {
              showSnackbar(context, transactionStatus);
            }
          },
        ),
      ],
      actionsPadding: const EdgeInsets.only(bottom: 8, right: 18),
    );
  }
}

class sellStockWidget extends StatefulWidget {
  const sellStockWidget({super.key, required this.ticker});

  final String ticker;

  @override
  State<sellStockWidget> createState() => _sellStockWidgetState();
}

class _sellStockWidgetState extends State<sellStockWidget> {
  @override
  Widget build(BuildContext context) {
    //
    dynamic data = getTickerPurchases(widget.ticker);
    //
    return AlertDialog(
      // alignment: Alignment.centerRight,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: SizedBox(
        height: 450,
        width: MediaQuery.of(context).size.width - 30,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Purchased Shares",
                style: TextStyle(
                    color: textColorLightGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 12),
              data == null
                  ? const Expanded(flex: 1, child: SizedBox())
                  : Container(),
              data != null
                  ? Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return item(data, index);
                        },
                      ),
                    )
                  : Text(
                      "You haven't purchased any shares of this company yet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColorDarkGrey),
                    ),
              data == null
                  ? const Expanded(flex: 1, child: SizedBox())
                  : Container(),
            ]),
      ),
    );
  }

  Widget item(Map data, int index) {
    String price = data.keys.toList()[index];
    double quantity = data.values.toList()[index];
    return SizedBox(
      height: 45,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "\$$price x ${quantity.toStringAsFixed(0)} Shares",
              style: TextStyle(
                  color: textColorDarkGrey, overflow: TextOverflow.ellipsis),
            ),
            Material(
              color: lossColor,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () {
                  sellShare(widget.ticker, price.toString(),
                      getStockDetailsByTicker(widget.ticker).currentPrice);
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(18),
                child: const SizedBox(
                  width: 66,
                  height: 30,
                  child: Center(
                    child: Text("Sell",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
