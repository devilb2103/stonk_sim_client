import 'package:flutter/material.dart';
import 'package:stonk_sim_client/colors.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Container(
                      decoration: BoxDecoration(
                          color: textColorDarkGrey,
                          borderRadius: BorderRadius.circular(27)),
                      child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 21, vertical: 15),
                          child: Text(
                            "StonkSim",
                            style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 33),
                          )),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Trade Simulation\nMade Easy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textColorDarkGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 24),
                    ),
                    const Expanded(flex: 7, child: SizedBox()),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      "Connecting to server",
                      style: TextStyle(
                          color: textColorDarkGrey,
                          fontWeight: FontWeight.w200,
                          fontSize: 18),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
