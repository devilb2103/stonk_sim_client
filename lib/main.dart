import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonk_sim_client/Cubits/SuggestionRefreshCubit/suggestion_refresh_cubit.dart';
import 'package:stonk_sim_client/Cubits/cubit/wishlist_cubit.dart';
import 'package:stonk_sim_client/app_navigator.dart';
import 'package:stonk_sim_client/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: backgroundColor,
        title: 'StonkSim',
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SuggestionRefreshCubit(),
              ),
              BlocProvider(
                create: (context) => WishlistCubit(),
              ),
            ],
            child: const Center(
              // child:
              // AspectRatio(aspectRatio: 1080 / 2340, child: AppNavigator())),
              child: AppNavigator(),
            )));
  }
}
