import 'package:flutter/material.dart';
import 'package:flycharts/pages/chartSearch.dart';
import 'package:flycharts/scaling.dart';
import 'package:flycharts/themes.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/cardButton.dart';
import 'package:flycharts/widgets/sideBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  Widget build(BuildContext context) {
    double calcSF = scaleFactor(context);

    return Scaffold(
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          print("prefs: " + _prefs.toString());
          if (_prefs == null) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return Container(
              color: activeTheme(_prefs!, "background")!,
              child: Padding(
                padding: EdgeInsets.all(60 * calcSF),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.0 * calcSF),
                        child: Text(
                          "Welcome to FlyCharts!",
                          textScaler: TextScaler.linear(4 * calcSF),
                          style:
                              TextStyle(color: activeTheme(_prefs!, "text")!),
                        ),
                      ),
                      Container(
                        width: 800 * calcSF,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: activeTheme(_prefs!, 'border')!, width: 1),
                          color: activeTheme(_prefs!, "secondaryBackground"),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(50 * calcSF),
                          child: Column(
                            children: [
                              Text(
                                "Getting Started",
                                textScaler: TextScaler.linear(2 * calcSF),
                                style: TextStyle(
                                    color: activeTheme(_prefs!, "text")!),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(30 * calcSF),
                                    child: cardButton(
                                        backgroundColor:
                                            activeTheme(_prefs!, "background")!,
                                        borderColor:
                                            activeTheme(_prefs!, "border")!,
                                        textColor:
                                            activeTheme(_prefs!, "text")!,
                                        iconColor:
                                            activeTheme(_prefs!, "text")!,
                                        borderRadius: 5 * calcSF,
                                        text: "Create New Flightplan",
                                        height: 200 * calcSF,
                                        width: 150 * calcSF,
                                        icon: Icons.add,
                                        textScaleFactor: 1.3 * calcSF,
                                        iconSize: 60 * calcSF),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                    child: cardButton(
                                        backgroundColor:
                                            activeTheme(_prefs!, "background")!,
                                        borderColor:
                                            activeTheme(_prefs!, "border")!,
                                        textColor:
                                            activeTheme(_prefs!, "text")!,
                                        iconColor:
                                            activeTheme(_prefs!, "text")!,
                                        borderRadius: 5 * calcSF,
                                        text: "Load Simbrief Flightplan",
                                        height: 200 * calcSF,
                                        width: 150 * calcSF,
                                        icon: Icons.file_copy,
                                        textScaleFactor: 1.3 * calcSF,
                                        iconSize: 60 * calcSF),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  chartSearch()));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(30 * calcSF),
                                      child: cardButton(
                                        backgroundColor:
                                            activeTheme(_prefs!, "background")!,
                                        borderColor:
                                            activeTheme(_prefs!, "border")!,
                                        textColor:
                                            activeTheme(_prefs!, "text")!,
                                        iconColor:
                                            activeTheme(_prefs!, "text")!,
                                        borderRadius: 5 * calcSF,
                                        text: "Charts by ICAO",
                                        height: 200 * calcSF,
                                        width: 150 * calcSF,
                                        icon: Icons.map,
                                        textScaleFactor: 1.3 * calcSF,
                                        iconSize: 60 * calcSF,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
