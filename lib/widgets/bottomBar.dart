import 'package:flutter/material.dart';
import 'package:flycharts/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bottomBar extends StatefulWidget {
  const bottomBar({super.key});

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefsFuture,
      builder: (context, snapshot) {
        print("prefs: " + _prefs.toString());
        if (_prefs == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return Container(
              alignment: Alignment.center,
              color: activeTheme(_prefs!, "tertiaryBackground")!,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
              child: DefaultTextStyle(
                style: TextStyle(
                    color: activeTheme(_prefs!, "text"),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w200),
                child: Text(
                  "NO FLIGHT PLAN LOADED",
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(1.2),
                ),
              ));
        }

        return CircularProgressIndicator();
      },
    );
  }
}
