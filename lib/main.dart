import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flycharts/pages/home.dart';
import 'package:flycharts/themes.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/sideBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(FlyCharts());
}

class FlyCharts extends StatelessWidget {
  FlyCharts({super.key, StatefulWidget? this.loadpage});
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  StatefulWidget? loadpage;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> outsideNavigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: outsideNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.teal,
          onPrimary: Colors.black,
          secondary: Colors.blueGrey,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.black,
          surface: Colors.grey,
          onSurface: Colors.black,
        ),
      ),
      home: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          print("prefs: " + _prefs.toString());
          if (_prefs == null) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        sideBar(
                          navKey: navigatorKey,
                          oNavKey: outsideNavigatorKey,
                        ),
                        Expanded(
                          child: MaterialApp(
                            theme: activeTheme(_prefs!, "is_dark")
                                ? ThemeData(
                                    colorScheme: ColorScheme.fromSeed(
                                    seedColor: Colors.white,
                                    // ···
                                    brightness: Brightness.dark,
                                  ))
                                : ThemeData(
                                    colorScheme: ColorScheme.fromSeed(
                                    seedColor: Colors.black,
                                    // ···
                                    brightness: Brightness.light,
                                  )),
                            navigatorKey: navigatorKey,
                            home: loadpage ?? HomePage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomBar()
                ],
              ),
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
