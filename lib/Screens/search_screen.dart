import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stonk_sim_client/Cubits/SuggestionRefresh/suggestion_refresh_cubit.dart';
import 'package:stonk_sim_client/network_vars.dart';
import 'package:dio/dio.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final IO.Socket socket = IO.io(
      address,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());
  final dio = Dio();
  @override
  void initState() {
    super.initState();
    // connect();
  }

  void connect() {
    socket.connect();
    socket.onConnect((data) {
      debugPrint("connected");
      addTicker("msft");
      addTicker("adanient.ns");
      socket.on("tickerStream",
          (data) => {tickerData = data, debugPrint(tickerData.toString())});
    });
  }

  void addTicker(String ticker) {
    socket.emit("addTicker", {
      "tickers": [ticker.toString()]
    });
  }

  Future<List<dynamic>> getTickerRecommendations(String ticker) async {
    String queryData = ticker;
    if (queryData.isNotEmpty) {
      final data = await dio.get(reccAddress + ticker);
      return data.data;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.maxFinite,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          width: 300,
          child: TextFormField(
            onChanged: (value) async {
              suggestions = await getTickerRecommendations(value.toString());
              context.read<SuggestionRefreshCubit>().refreshSuggestionUI();
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: const OutlineInputBorder(),
                hintText: "ticker",
                filled: true,
                fillColor: Colors.white),
          ),
        ),
        Expanded(
            child: BlocConsumer<SuggestionRefreshCubit, SuggestionRefreshState>(
          listener: (context, state) {
            if (state is SuggestionRefreshInitialState) {}
          },
          builder: (context, state) {
            if (state is SuggestionRefreshInitialState) {
              return ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  if (suggestions.isNotEmpty) {
                    return Text(suggestions[index].toString());
                  }
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ))
      ]),
    ));
  }
}
