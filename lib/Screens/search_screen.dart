import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonk_sim_client/Cubits/SuggestionRefreshCubit/suggestion_refresh_cubit.dart';
import 'package:stonk_sim_client/Cubits/cubit/wishlist_cubit.dart';
import 'package:stonk_sim_client/colors.dart';
import 'package:stonk_sim_client/network_vars.dart';

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
                        Expanded(child: SizedBox()),
                        Container(
                            width: MediaQuery.of(context).size.width - 84,
                            child: customSearchbar()),
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
                            return searchResultElement(index: index);
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

class searchResultElement extends StatelessWidget {
  searchResultElement({super.key, required this.index});
  int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<WishlistCubit>().addTicker(suggestions[index]['symbol']);
        tickerNames[suggestions[index]['symbol']] = suggestions[index]['name'];
        try {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        } catch (e) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: searchBarColor,
            duration: Duration(seconds: 3),
            content: Text(
                "${suggestions[index]['symbol']} has been added to your watch list")));
      },
      trailing: Icon(
        Icons.bookmark,
        color: textColorLightGrey,
      ),
      title: Text(
        "${suggestions[index]['symbol'].toString()}, ${suggestions[index]['name'].toString()}",
        style: TextStyle(color: textColorLightGrey),
      ),
    );
  }
}

class customSearchbar extends StatelessWidget {
  const customSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: 24,
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
    );
  }
}
