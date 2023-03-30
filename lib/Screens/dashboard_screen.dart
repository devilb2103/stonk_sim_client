import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stonk_sim_client/Cubits/SuggestionRefresh/suggestion_refresh_cubit.dart';
import 'package:stonk_sim_client/Screens/search_screen.dart';
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
    // connect();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
  final List<Map<String, dynamic>> sampleStocks = [
    {
      "ticker": "AAP",
      "name": "Advance Auto Parts Inc W/I",
      "price": 442.82,
      "change": -4.36
    },
    {"ticker": "AAPL", "name": "Apple Inc.", "price": 442.82, "change": 4.36},
    {
      "ticker": "CAAP",
      "name": "Corporacion America Airports SA",
      "price": 442.82,
      "change": 4.36
    },
    {
      "ticker": "AAP",
      "name": "Advance Auto Parts Inc W/I",
      "price": 442.82,
      "change": -4.36
    },
    {"ticker": "AAPL", "name": "Apple Inc.", "price": 442.82, "change": 4.36},
    {
      "ticker": "CAAP",
      "name": "Corporacion America Airports SA",
      "price": 442.82,
      "change": 4.36
    },
    {
      "ticker": "AMSF",
      "name": "AMERISAFE Inc.",
      "price": 442.82,
      "change": 4.36
    },
    {
      "ticker": "MSFT",
      "name": "Microsoft Corporation",
      "price": 442.82,
      "change": 4.36
    }
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle style1 = TextStyle(
        color: textColorLightGrey,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis);

    return Expanded(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My shares",
              style: TextStyle(
                  color: textColorLightGrey,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: sampleStocks.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 84,
                    child: Card(
                      elevation: 1,
                      color: searchBarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          highlightColor: searchBarColor,
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sampleStocks[index]['name'].toString(),
                                        style: style1,
                                      ),
                                      Text(
                                          sampleStocks[index]['ticker']
                                              .toString(),
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
                                      Text(
                                          "\$" +
                                              sampleStocks[index]['price']
                                                  .toString(),
                                          style: style1),
                                      Text(
                                          sampleStocks[index]['change']
                                                  .toString() +
                                              "%",
                                          style: TextStyle(
                                              color: sampleStocks[index]
                                                          ['change'] <=
                                                      0
                                                  ? lossColor
                                                  : profitColor,
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
                },
              ),
            )
          ],
        ),
      ),
    );
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
          elevation: 1,
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
                SizedBox(height: 12),
                Text(
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
                SizedBox(height: 18),
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
                      builder: (context) => SearchScreen(),
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
