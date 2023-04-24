import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
                                fontWeight: FontWeight.w200,
                                fontSize: 33),
                          )),
                    ),
                    SizedBox(height: 15),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
