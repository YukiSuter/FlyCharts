import 'package:flutter/material.dart';
import 'package:flycharts/pages/home.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/sideBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  sideBar(
                    navKey: navigatorKey,
                  ),
                  Expanded(
                    child: MaterialApp(
                        navigatorKey: navigatorKey, home: HomePage()),
                  ),
                ],
              ),
            ),
            bottomBar()
          ],
        ),
      ),
    );
  }
}
