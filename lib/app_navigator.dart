import 'package:flutter/material.dart';
import 'package:stonk_sim_client/Screens/dashboard_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: const [
        MaterialPage(child: DashboardScreen()),
        // MaterialPage(child: DashboardScreen()),
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}
