import 'dart:async';
import 'dart:io';

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
    "chartsClose": Color(0xFF232323),
    "chartsClose_hover": Color(0xFF262626),
    "chartChoice": Color(0xFF232323),
    "chartChoice_hover": Color(0xFF262626),
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

class VertText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const VertText(this.text, this.style);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 21,
      child: Wrap(
        runSpacing: 30,
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: text.split("").map((string) => Text(string, style: style)).toList(),
      )
    );
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
  Map<String, Color> chartTypeButtonColors = {};
  Map<String, Color> chartOptionButtonColors = {};
  late Color chartOptionContainerColor;
  List<String> chartTypeList = [];
  int selectedTypeIndex = 0;
  List<String> chartOptionList = [];
  int selectedOptionIndex = 0;
  bool choicesActive = false;
  bool selectedActive = false;

  Color chartsCloseColor = Themes[activeTheme]["chartsClose"];

  int maxCAC = 1;
  int CAC = 1;

  Future<void> _loadCharts(chartType) async {
    print("Showing: " + chartType);
    print(chartTypeButtonColors);
    selectedTypeIndex = chartTypeList.indexOf(chartType);
    chartOptionContainerColor = Themes[activeTheme]!["chartTypeUnderlineColors"][selectedTypeIndex];
    print(Themes[activeTheme]!["chartTypeUnderlineColors"][selectedTypeIndex]);

    choicesActive = true;

    chartOptionButtonColors = {};
    chartOptionList = [];

    for (String option in widget.charts[chartTypeList[selectedTypeIndex]].keys) {
      print("Adding: " + option);
      chartOptionList.add(option);
      _setChartOptionButton(chartOptionList.indexOf(option), "normal");
    }

    print(chartOptionList);

    for (String type in chartTypeList) {
      if (type == chartType) {
        _setChartTypeButton(chartTypeList.indexOf(type), "active");
      } else {
        _setChartTypeButton(chartTypeList.indexOf(type), "normal");
      }
    }
    setState(() {

    });
  }

  Future<void> _setChartOptionButton(index, status) async {
    if (status == "hover") {
      chartOptionButtonColors[chartOptionList[index]] = Themes[activeTheme]!["chartChoice_hover"];
    } if (status == "active") {
      chartOptionButtonColors[chartOptionList[index]] = Themes[activeTheme]!["chartTypeUnderlineColors"][selectedTypeIndex];
    } if (status == "normal") {
      chartOptionButtonColors[chartOptionList[index]] = Themes[activeTheme]!["chartChoice"];
    }
  }

  Future<void> _setChartTypeButton(index, status) async {
    if (status == "hover") {
      chartTypeButtonColors[chartTypeList[index]] = Themes[activeTheme]!["chartTypeButtons_hover"];
    } if (status == "active") {
      chartTypeButtonColors[chartTypeList[index]] = Themes[activeTheme]!["chartTypeUnderlineColors"][selectedTypeIndex];
    } if (status == "normal") {
      chartTypeButtonColors[chartTypeList[index]] = Themes[activeTheme]!["chartTypeButtons"];
    }
  }


  @override
  Widget build(BuildContext context) {

    if (chartTypeList.isEmpty) { // Fill the type Array
      chartOptionContainerColor = Color(0xFF1F1F1F);
      for (String chart in widget.charts.keys) {
        chartTypeList.add(chart);
      }
    }

    if (chartTypeButtonColors.isEmpty) { // Fill the typeButtonColors
      List<String> Keys = widget.charts.keys.toList();
      for (String type in Keys) {
        _setChartTypeButton(Keys.indexOf(type), "normal");
      }
    }

    print("Map filled");

    //Calculate the crossAxisCount of the choices grid
    maxCAC = (MediaQuery.of(context).size.width/400).floor();
    print("CAC = " + widget.charts[chartTypeList[selectedTypeIndex]].keys.length.toString());
    print("maxCAC = " + maxCAC.toString());
    if (maxCAC <= widget.charts[chartTypeList[selectedTypeIndex]].keys.length) { CAC = maxCAC;}
    else {print("setting CAC"); CAC = widget.charts[chartTypeList[selectedTypeIndex]].keys.length;}

    print(widget.charts[chartTypeList[selectedTypeIndex]].keys);
    print(widget.charts[chartTypeList[selectedTypeIndex]]);

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
            child: Row(
              children: [
                Container( // Selector Column
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        children: List.generate(widget.charts.keys.length, (index) {
                          return Expanded(
                              child: MouseRegion(
                                child:GestureDetector(
                                  child: Container(
                                    color: chartTypeButtonColors[chartTypeList[index]],
                                    width: 30,
                                    child: Row(
                                      children: [
                                        Container(
                                            color: Themes[activeTheme]!["chartTypeUnderlineColors"]?.elementAt(index),
                                            width: 5
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(2),
                                            child: Container(
                                              child:VertText(
                                              chartTypeList[index],
                                              TextStyle(fontWeight: FontWeight.bold, color: Themes[activeTheme]!["chartType_text"]),
                                            )
                                          )
                                        ),

                                      ],
                                    ),
                                  ),
                                  onTap: () => _loadCharts(chartTypeList[index]),
                                  onTapDown: (s) => setState(() {if (selectedTypeIndex != index) {_setChartTypeButton(index, "normal");}}),
                                  onTapUp: (s) => setState(() {if (selectedTypeIndex != index) {_setChartTypeButton(index, "hover");}}),
                                ),
                                onEnter: (s) => setState(() {if (selectedTypeIndex != index) {_setChartTypeButton(index, "hover");}}),
                                onExit: (s) => setState(() {if (selectedTypeIndex != index) {_setChartTypeButton(index, "normal");}}),
                              )
                          );
                        })
                    )
                ),
                Container(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(3),
                  color: chartOptionContainerColor,
                  child: Builder(
                    builder: (context) {
                      if (!choicesActive) {
                        return Container(
                          padding: EdgeInsets.all(7),
                          child: Text("No chart type selected! Please choose from the column on the left."),
                          alignment: Alignment.center,
                        );
                      } else {
                        return Container(
                          color: Themes[activeTheme]["background"],
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView.separated(
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                            itemCount: chartOptionList.length,
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              return MouseRegion(
                                child: GestureDetector(
                                  child: Container(
                                    color: chartOptionButtonColors[chartOptionList[index]],
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Text(
                                          chartOptionList[index],
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.charts[chartTypeList[selectedTypeIndex]][chartOptionList[index]]["detail"]
                                        )
                                      ],
                                    )
                                  ),
                                  // onTap: () => _loadCharts(chartTypeList[index]),
                                  onTapDown: (s) => setState(() {if (selectedOptionIndex != index) {_setChartOptionButton(index, "normal");}}),
                                  onTapUp: (s) => setState(() {if (selectedOptionIndex != index) {_setChartOptionButton(index, "hover");}}),
                                ),
                                onEnter: (s) => setState(() {if (selectedOptionIndex != index) {_setChartOptionButton(index, "hover");}}),
                                onExit: (s) => setState(() {if (selectedOptionIndex != index) {_setChartOptionButton(index, "normal");}}),
                              );
                            }
                          ),
                        );
                      }
                    },
                  )
                ),
                MouseRegion(
                  child: GestureDetector(
                    child:Container(
                      width: 30,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(5),
                      color: chartsCloseColor,
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                    onTap: () => print("Hi"),
                    onTapDown: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose_hover"];}),
                    onTapUp: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose"];}),
                  ),
                  onEnter: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose_hover"];}),
                  onExit: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose"];}),
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

    _userInput = _userInput.toUpperCase();

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
