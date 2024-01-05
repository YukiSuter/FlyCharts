import 'dart:async';

import 'package:flutter/material.dart';
import 'charts/chartMaps.dart' as cm;
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert' show utf8;

void main() {
  runApp(const MyApp());
}

String activeTheme = "Dark";

const Map<String, dynamic> Themes = {
  "Dark": {
    "chartTypeButtons_hover": Color(0xFF262626),
    "chartTypeButtons": Color(0xFF232323),
    "chartType_text": Colors.white,
    "chartTypeUnderlineColors": [Colors.teal, Colors.deepOrangeAccent, Colors.blue, Colors.purple, Colors.amber],
    "appBar": Color(0xFF131313),
    "appBar_text": Colors.white,
    "background": Color(0xFF282828),
    "brightness": Brightness.dark,
  }
};

_launchURL(link) async {
  final Uri url = Uri.parse(link);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch' + link);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlyCharts',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          // ···
          brightness: Themes[activeTheme]!["brightness"],
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Themes[activeTheme]!["appBar_text"], // Change the color of the back arrow here
          ),
        ),
      ),
      home: const LaunchPage(title: 'FlyCharts Launch Page'),
    );
  }
}

class ChartsPage extends StatefulWidget {
  final String adname;
  final Map<String, dynamic> charts;


  const ChartsPage ({ Key? key, required this.adname, required this.charts }): super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  Map<String, bool> buttonColors = {};

  Future<void> _loadCharts(chartType) async {
    print("Showing: " + chartType);
    print(buttonColors);
  }


  @override
  Widget build(BuildContext context) {
    if (buttonColors.isEmpty) {
      for (String chart in widget.charts.keys) {
        setState(() {
          buttonColors[chart] = false;
        });
      }
    }
    print("Map filled");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Themes[activeTheme]!["appBar"],
          title: Text(
            widget.adname,
            style: TextStyle(color: Themes[activeTheme]!["appBar_text"]),
          ),
        ),
        body: Container(
            color: Themes[activeTheme]!["background"],
            child: Column(
              children: [
                Container( // Selector Column
                  // height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        children: List.generate(widget.charts.keys.length, (index) {
                          return Expanded(
                              child: MouseRegion(
                                child:GestureDetector(
                                  child: Container(
                                    color: buttonColors[widget.charts.keys.indexed.elementAt(index).$2]! ? (Themes[activeTheme]!["chartTypeButtons_hover"]) : (Themes[activeTheme]!["chartTypeButtons"]),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(2),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                widget.charts.keys.indexed.elementAt(index).$2,
                                                textScaleFactor: 1.3,
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Themes[activeTheme]!["chartType_text"]),
                                              ),
                                            )
                                        ),
                                        Container(
                                            color: Themes[activeTheme]!["chartTypeUnderlineColors"]?.elementAt(index),
                                            height: 5
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => _loadCharts(widget.charts.keys.indexed.elementAt(index).$2),
                                ),
                                onEnter: (s) => setState(() {buttonColors[widget.charts.keys.indexed.elementAt(index).$2] = true;}),
                                onExit: (s) => setState(() {buttonColors[widget.charts.keys.indexed.elementAt(index).$2] = false;}),
                              )
                          );
                        })
                    )
                ),
                Expanded(
                  child: Container(
                    color: Themes[activeTheme]!["background"],
                  ),
                )
              ],
            )


        )
    );
  }
}

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key, required this.title});
  final String title;

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  String _userInput = '';
  bool showError = false;
  String errorMessage = 'UNEXPECTED ERROR! PLEASE TRY AGAIN';
  bool loading = false;



  Future<void> search() async {
    showError = false;
    loading = true;
    setState(() {});
    if (_userInput != '') {
      for (var cc in cm.functionMap.entries) {
        print(_userInput.substring(0, cc.key.length));
        print(cc.key);
        if (_userInput.substring(0, cc.key.length) == cc.key) {
          print("Match found: " + cc.key);
          List<dynamic> searchResult;
          try {
            searchResult = await cc.value(_userInput).timeout(const Duration(seconds: 10));
            print(searchResult[1]);
            Map<String, dynamic> charts = searchResult[1];
            // String adname = searchResult[0].replaceAll('&nbsp;', '').replaceAll('\n        ', '').replaceAll('\n', '');
            String adname = searchResult[0];
            print(adname);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChartsPage(adname: _userInput + " - " + adname, charts: searchResult[1])));
          }
          on TimeoutException {
            errorMessage = "Timed out. Please check your connection and try again.";
            showError = true;
          }
          if (!showError) {

          }

        } else {
          print("Error country code not found for: " + _userInput);
          errorMessage = "Country code not found for: " + _userInput + "\nWe may not have your country available yet on FlyCharts. Please check github for more info.";
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Themes[activeTheme]!["appBar"],
          title: Text(
            'FlyCharts',
            style: TextStyle(color: Themes[activeTheme]!["appBar_text"]),
          ),
        ),
        body: Container(
          color: Themes[activeTheme]!["background"],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Welcome to FlyCharts! Please enter the ICAO for the airport you want charts for, below!',

                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 200.0,
                    height: 75.0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter ICAO',
                      ),
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

                        child: OutlinedButton(
                          onPressed: search,
                          child:  switch (loading) {
                            true => LoadingAnimationWidget.twoRotatingArc(
                              color: Colors.teal,
                              size: 20,
                            ),
                            false => Text("Show Charts"),
                          },
                        )
                    )
                ),
                Visibility(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      errorMessage,

                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      softWrap: true,

                    ),
                  ),
                  visible: showError,
                ),
                // Padding(
                //     padding: EdgeInsets.all(10),
                //     child: GestureDetector(
                //       onTap: _launchURL {"https://gi"},
                //       child: Image(
                //           width: 300.0,
                //           height: 50,
                //           image: AssetImage('assets/GitHub_Logo.png'),
                //       ),
                //     )
                //
                //
                //
                // ),

              ],
            ),
          ),
        )

    );
  }
}
