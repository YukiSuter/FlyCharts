import 'package:flutter/material.dart';
import 'package:flycharts/pages/home.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/sideBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                        ),
                        Expanded(
                          child: MaterialApp(
                            navigatorKey: navigatorKey,
                            home: HomePage(),
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
