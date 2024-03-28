import 'package:flutter/material.dart';

class bottomBar extends StatefulWidget {
  const bottomBar({super.key});

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xffE7E7E7),
        height: 25,
        width: MediaQuery.of(context).size.width,
        child: Text(
          "NO FLIGHT PLAN LOADED",
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(0.2),
        ));
  }
}
