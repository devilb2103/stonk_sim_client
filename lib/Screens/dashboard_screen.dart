import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stonk_sim_client/Cubits/cubit/wishlist_cubit.dart';
import 'package:stonk_sim_client/Models/stock_details_model.dart';
import 'package:stonk_sim_client/Screens/search_screen.dart';
import 'package:stonk_sim_client/Screens/stock_details_screen.dart';
import 'package:stonk_sim_client/Utils/stockUtils.dart';
import 'package:stonk_sim_client/colors.dart';
import 'package:stonk_sim_client/network_vars.dart';
import 'package:dio/dio.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket.connect();
    socket.onConnect((data) {
      debugPrint("connected");
      socket.on(
          "tickerStream",
          (data) => {
                wishList = data,
                context.read<WishlistCubit>().updateWishlist(),
                debugPrint(wishList.toString())
              });
    });
    socket.onDisconnect((data) => {debugPrint("disconnected"), disconnect()});
  }

  void disconnect() {
    socket.disconnect();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: false,
          body: Container(
            color: backgroundColor,
            width: double.maxFinite,
            height: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
              child: Column(children: const [
                SearchBar(),
                SizedBox(height: 15),
                AccountDetails(),
                SizedBox(height: 15),
                AllShareListView()
              ]),
            ),
          )),
    );
  }
}

class AllShareListView extends StatefulWidget {
  const AllShareListView({super.key});

  @override
  State<AllShareListView> createState() => AllShareListViewState();
}

class AllShareListViewState extends State<AllShareListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My shares",
              style: TextStyle(
                  color: textColorLightGrey,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Expanded(child: UserWishList())
          ],
        ),
      ),
    );
  }
}

class UserWishList extends StatefulWidget {
  const UserWishList({super.key});

  @override
  State<UserWishList> createState() => UserWishListState();
}

class UserWishListState extends State<UserWishList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        if (state is WishlistInitialState) {
          return (wishList.isEmpty)
              ? const emptyWishlistMessage()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: wishList.keys.toList().length,
                  itemBuilder: (context, index) {
                    return wishListItem(index: index);
                  },
                );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class emptyWishlistMessage extends StatelessWidget {
  const emptyWishlistMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      "You have\nno wishlisted stocks\n:c",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textColorLightGrey, fontSize: 21, fontWeight: FontWeight.w100),
    ));
  }
}

class wishListItem extends StatelessWidget {
  wishListItem({super.key, required this.index});

  int index;

  TextStyle style1 = const TextStyle(
      color: textColorLightGrey,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis);

  void showStockDetailsPage(BuildContext context, StockDetails details) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockDetailsScreen(index: index),
        ));
  }

  @override
  Widget build(BuildContext context) {
    //
    StockDetails details = getStockDetails(index);
    //
    return SizedBox(
      height: 90,
      child: Card(
        elevation: 1,
        color: searchBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: InkWell(
            borderRadius: BorderRadius.circular(18),
            highlightColor: searchBarColor,
            onTap: () {
              showStockDetailsPage(
                  context,
                  StockDetails(
                      companyName: details.companyName,
                      ticker: details.ticker,
                      currentPrice: details.currentPrice,
                      priceChange: details.priceChange,
                      priceChangeP: details.priceChangeP,
                      openingPrice: details.openingPrice,
                      previousClosingPrice: details.previousClosingPrice,
                      volume: details.volume,
                      dailyRange: details.dailyRange));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.companyName,
                          style: style1,
                        ),
                        Text(details.ticker,
                            style: TextStyle(
                                color: textColorDarkGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12))
                      ],
                    )),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("\$${details.currentPrice}", style: style1),
                        Text(details.priceChangeP,
                            style: TextStyle(
                                color: (wishList.values
                                            .toList()[index][2]
                                            .toString() !=
                                        "NA")
                                    ? (double.parse(wishList.values
                                                .toList()[index][2]
                                                .toString()) <=
                                            0
                                        ? lossColor
                                        : profitColor)
                                    : textColorDarkGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12))
                      ],
                    )),
                  ),
                ],
              ),
            )),
      ),
    );
    ;
  }
}

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: 180,
        width: double.maxFinite,
        child: Card(
          elevation: 2,
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            highlightColor: searchBarColor,
            onTap: () {},
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text(
                  '\$12,345.03',
                  style: TextStyle(
                      color: textColorLightGrey,
                      fontSize: 45,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 30,
                  child: Card(
                    color: profitColor,
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
                            children: const [
                              Text(
                                "+5.25%",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.5),
                                child: VerticalDivider(width: 12),
                              ),
                              Text(
                                "+\$642.26",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ));
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 54,
        width: double.maxFinite,
        child: Card(
          elevation: 1,
          color: searchBarColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: InkWell(
              borderRadius: BorderRadius.circular(80),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, color: textColorDarkGrey),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Search for companies or symbols",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: textColorDarkGrey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }
}
