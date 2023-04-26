import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonk_sim_client/Cubits/SuggestionRefreshCubit/suggestion_refresh_cubit.dart';
import 'package:stonk_sim_client/Cubits/cubit/wishlist_cubit.dart';
import 'package:stonk_sim_client/Utils/stock_data_utils.dart';
import 'package:stonk_sim_client/colors.dart';
import 'package:stonk_sim_client/network_vars.dart';

String searchText = "";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: backgroundColor,
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            shape: Border(
                bottom: BorderSide(color: Colors.grey.shade600, width: 1)),
            centerTitle: true,
            // toolbarHeight: 48,
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
                        const Expanded(child: SizedBox()),
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 84,
                            child: const CustomSearchbar()),
                        const Expanded(child: SizedBox()),
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
                child: BlocConsumer<SuggestionRefreshCubit,
                    SuggestionRefreshState>(
                  listener: (context, state) {
                    if (state is SuggestionRefreshInitialState) {}
                  },
                  builder: (context, state) {
                    if (state is SuggestionRefreshInitialState) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: searchText.isEmpty
                            ? 0
                            : suggestions.isEmpty
                                ? 1
                                : suggestions.length,
                        itemBuilder: (context, index) {
                          if (suggestions.isNotEmpty) {
                            return searchResultElement(
                                index: index, emptySuggestions: false);
                          } else {
                            return searchResultElement(
                                index: index, emptySuggestions: true);
                          }
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )),
          )),
    );
  }
}

class searchResultElement extends StatelessWidget {
  searchResultElement(
      {super.key, required this.index, required this.emptySuggestions});
  int index;
  bool emptySuggestions;
  @override
  Widget build(BuildContext context) {
    if (!emptySuggestions) {
      return ListTile(
        onTap: () {
          context.read<WishlistCubit>().addTicker(suggestions[index]['symbol']);
          // tickerNames[suggestions[index]['symbol']] =
          //     suggestions[index]['name'];
          try {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          } catch (e) {}
          showSnackbar(context,
              "${suggestions[index]['symbol']} has been added to your watch list");
        },
        trailing: const Icon(
          Icons.bookmark_rounded,
          color: textColorLightGrey,
        ),
        title: Text(
          "${suggestions[index]['symbol'].toString()}, ${suggestions[index]['name'].toString()}",
          style: const TextStyle(color: textColorLightGrey),
        ),
      );
    } else {
      return ListTile(
        onTap: () {
          // try searching for text search string
          context.read<WishlistCubit>().addTicker(searchText.toString().trim());
          // set textsearch string as an ticker with no name
          // tickerNames[searchText.toString().trim().toUpperCase()] = "";
          try {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          } catch (e) {}
          showSnackbar(
              context, "Successfully added $searchText to your watch list");
        },
        trailing: const Icon(
          Icons.search_off_rounded,
          color: textColorLightGrey,
        ),
        title: Text(
          "Try searching for the ticker '$searchText'",
          style: const TextStyle(color: textColorLightGrey),
        ),
      );
    }
  }
}

class CustomSearchbar extends StatelessWidget {
  const CustomSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: 24,
      onChanged: (value) async {
        searchText = value.toString().trim();
        context
            .read<SuggestionRefreshCubit>()
            .refreshSuggestionUI(value.toString());
      },
      style: const TextStyle(color: textColorLightGrey),
      cursorColor: Colors.grey,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
