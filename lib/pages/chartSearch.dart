import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flycharts/pages/charts.dart';
import 'package:flycharts/scaling.dart';
import 'package:flycharts/themes.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/sideBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../charts/chartMaps.dart' as cm;

class chartSearch extends StatefulWidget {
  const chartSearch({super.key});

  @override
  State<chartSearch> createState() => _chartSearchState();
}

class _chartSearchState extends State<chartSearch> {
  String _userInput = '';
  bool showError = false;
  String errorMessage = 'UNEXPECTED ERROR! PLEASE TRY AGAIN';
  bool loading = false;
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  Future<void> search() async {
    showError = false;
    loading = true;
    setState(() {});

    _userInput = _userInput.toUpperCase();

    if (_userInput != '') {
      for (var cc in cm.functionMap.entries) {
        print(_userInput.substring(0, cc.key.length));
        print(cc.key);
        if (_userInput.substring(0, cc.key.length) == cc.key) {
          print("Match found: " + cc.key);
          List<dynamic> searchResult;
          try {
            searchResult =
                await cc.value(_userInput).timeout(const Duration(seconds: 10));
            print(searchResult[1]);
            Map<String, dynamic> charts = searchResult[1];
            // String adname = searchResult[0].replaceAll('&nbsp;', '').replaceAll('\n        ', '').replaceAll('\n', '');
            String adname = searchResult[0];
            print(adname);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChartsPage(
                    adname: _userInput + " - " + adname,
                    charts: searchResult[1])));
          } on TimeoutException {
            errorMessage =
                "Timed out. Please check your connection and try again.";
            showError = true;
          }
          if (!showError) {}
        } else {
          print("Error country code not found for: " + _userInput);
          errorMessage = "Country code not found for: " +
              _userInput +
              "\nWe may not have your country available yet on FlyCharts. Please check github for more info.";
          showError = true;
        }
      }
    } else {
      errorMessage = "Please enter the ICAO code for the aerodrome of choice.";
      showError = true;
    }
    loading = false;
    setState(() {});
  }

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
                child: Row(
                  children: [
                    Container(
                      width: 500 * calcSF,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Search by ICAO",
                                  style: TextStyle(
                                      color: activeTheme(_prefs!, "text")),
                                  textScaler: TextScaler.linear(2 * calcSF),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 200.0,
                                height: 75.0,
                                child: TextField(
                                  style: TextStyle(
                                      color: activeTheme(_prefs!, "text")),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter an ICAO code',
                                      hintStyle: TextStyle(
                                          color: activeTheme(_prefs!, "text")
                                              .withOpacity(0.3))),
                                  onChanged: (value) {
                                    setState(() {
                                      _userInput = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: SizedBox(
                                width: 200.0,
                                height: 50,
                                child: SizedBox(
                                  width: 200.0,
                                  height: 50,
                                  child: FilledButton(
                                    onPressed: search,
                                    child: switch (loading) {
                                      true =>
                                        LoadingAnimationWidget.twoRotatingArc(
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      false => Text("Show Charts"),
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  errorMessage,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                  softWrap: true,
                                ),
                              ),
                              visible: showError,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: activeTheme(_prefs!, 'border')!, width: 1),
                        color: activeTheme(_prefs!, "tertiaryBackground"),
                      ),
                    ))
                  ],
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
