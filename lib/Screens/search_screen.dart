import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonk_sim_client/Cubits/SuggestionRefresh/suggestion_refresh_cubit.dart';
import 'package:stonk_sim_client/colors.dart';
import 'package:stonk_sim_client/network_vars.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final IO.Socket socket = IO.io(
  //     address,
  //     IO.OptionBuilder()
  //         .setTransports(['websocket'])
  //         .disableAutoConnect()
  //         .build());
  @override
  void initState() {
    super.initState();
    // connect();
  }

  // void connect() {
  //   socket.connect();
  //   socket.onConnect((data) {
  //     debugPrint("connected");
  //     addTicker("msft");
  //     addTicker("adanient.ns");
  //     socket.on("tickerStream",
  //         (data) => {tickerData = data, debugPrint(tickerData.toString())});
  //   });
  // }

  // void addTicker(String ticker) {
  //   socket.emit("addTicker", {
  //     "tickers": [ticker.toString()]
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            shape: Border(
                bottom: BorderSide(color: Colors.grey.shade600, width: 1)),
            centerTitle: true,
            toolbarHeight: 48,
            backgroundColor: backgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SizedBox(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: textColorDarkGrey,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                            width: MediaQuery.of(context).size.width - 84,
                            child: TextField(
                              onChanged: (value) async {
                                context
                                    .read<SuggestionRefreshCubit>()
                                    .refreshSuggestionUI(value.toString());
                              },
                              style: TextStyle(color: textColorLightGrey),
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ])),
          ),
          body: Container(
            color: backgroundColor,
            width: double.maxFinite,
            height: double.maxFinite,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
                child: Container(
                    child: BlocConsumer<SuggestionRefreshCubit,
                        SuggestionRefreshState>(
                  listener: (context, state) {
                    if (state is SuggestionRefreshInitialState) {}
                  },
                  builder: (context, state) {
                    if (state is SuggestionRefreshInitialState) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          if (suggestions.isNotEmpty) {
                            return ListTile(
                              onTap: () {},
                              title: Text(
                                "${suggestions[index]['symbol'].toString()}, ${suggestions[index]['name'].toString()}",
                                style: TextStyle(color: textColorLightGrey),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ))),
          )),
    );
  }
}

class customAppBar extends StatelessWidget {
  const customAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }
}
