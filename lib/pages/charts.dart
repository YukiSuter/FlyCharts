import 'dart:async';
import 'dart:io';
import 'package:flycharts/themes.dart';
import 'package:flycharts/widgets/vertText.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'package:internet_file/internet_file.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../charts/chartMaps.dart' as cm;
import 'package:url_launcher/url_launcher.dart';

class ChartsPage extends StatefulWidget {
  final String adname;
  final Map<String, dynamic> charts;

  const ChartsPage({Key? key, required this.adname, required this.charts})
      : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  Map<String, Color> chartTypeButtonColors = {};
  Map<String, Color> chartOptionButtonColors = {};
  late Color chartOptionContainerColor;
  List<String> chartTypeList = [];
  int selectedTypeIndex = 0;
  List<String> chartOptionList = [];
  int selectedOptionIndex = 0;
  bool choicesActive = false;
  bool selectedActive = false;
  double choicesSize = 300;
  Icon choicesIcon = Icon(Icons.arrow_back_ios_new);

  String tempPath = "";

  var pdfPinchController = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/sample.pdf'),
  );

  var pdfController = PdfController(
    document: PdfDocument.openAsset('assets/sample.pdf'),
  );

  int maxCAC = 1;
  int CAC = 1;

  Future<void> _loadCharts(chartType) async {
    print("Showing: " + chartType);
    print(chartTypeButtonColors);
    selectedTypeIndex = chartTypeList.indexOf(chartType);
    chartOptionContainerColor =
        activeTheme(_prefs!, "chartTypeUnderlineColors")![selectedTypeIndex];
    print(activeTheme(_prefs!, "chartTypeUnderlineColors")![selectedTypeIndex]);

    choicesActive = true;

    chartOptionButtonColors = {};
    chartOptionList = [];

    for (String option
        in widget.charts[chartTypeList[selectedTypeIndex]].keys) {
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
    setState(() {});
  }

  Future<void> _openChart(index) async {
    selectedOptionIndex = index;
    _setPDF(widget.charts[chartTypeList[selectedTypeIndex]]
        [chartOptionList[selectedOptionIndex]]["link"]);
  }

  Future<void> _setPDF(link) async {
    //
    // Directory tempDir = await getTemporaryDirectory();
    // final dirExists = await tempDir.exists();
    // if (!dirExists) {
    //   await tempDir.create();
    // }
    //
    // String tempPath = tempDir.path;
    //
    // final pdfFile = File('$tempPath/tempchart.pdf');
    //
    //
    // final pdfResponse = await http.get(Uri.parse(link));
    //
    //
    // await pdfFile.writeAsBytes(pdfResponse.bodyBytes);

    if (Platform.isIOS || Platform.isAndroid) {
      pdfPinchController
          .loadDocument(PdfDocument.openData(InternetFile.get(link)));
    } else {
      pdfController.loadDocument(PdfDocument.openData(InternetFile.get(link)));
    }

    // setState(() {
    //
    // });
  }

  Future<void> _setChartOptionButton(index, status) async {
    if (status == "hover") {
      chartOptionButtonColors[chartOptionList[index]] =
          activeTheme(_prefs!, "chartTypeButtons_hover");
    }
    if (status == "active") {
      chartOptionButtonColors[chartOptionList[index]] =
          activeTheme(_prefs!, "chartTypeUnderlineColors")[selectedTypeIndex];
    }
    if (status == "normal") {
      chartOptionButtonColors[chartOptionList[index]] =
          activeTheme(_prefs!, "chartChoice");
    }
  }

  Future<void> _setChartTypeButton(index, status) async {
    if (status == "hover") {
      chartTypeButtonColors[chartTypeList[index]] =
          activeTheme(_prefs!, "chartTypeButtons_hover");
    }
    if (status == "active") {
      chartTypeButtonColors[chartTypeList[index]] =
          activeTheme(_prefs!, "chartTypeUnderlineColors")[selectedTypeIndex];
    }
    if (status == "normal") {
      print(chartTypeButtonColors);
      print(index);
      chartTypeButtonColors[chartTypeList[index]] =
          activeTheme(_prefs!, "chartChoice");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Loading chartsPage");
    return FutureBuilder(
      future: _prefsFuture,
      builder: (context, snapshot) {
        print("prefs: " + _prefs.toString());
        print("Seeing if prefs has data");
        if (_prefs == null) {
          print("No prefs data");
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          print("Prefs data exists");
          Color chartsCloseColor = activeTheme(_prefs!, "chartsClose");
          print("Filling map");
          if (chartTypeList.isEmpty) {
            // Fill the type Array
            chartOptionContainerColor = Color(0xFF1F1F1F);
            for (String chart in widget.charts.keys) {
              chartTypeList.add(chart);
            }
          }

          if (chartTypeButtonColors.isEmpty) {
            // Fill the typeButtonColors
            List<String> Keys = widget.charts.keys.toList();
            print(Keys);
            for (String type in Keys) {
              print(type);
              _setChartTypeButton(chartTypeList.indexOf(type), "normal");
            }
          }

          print("Map filled");

          //Calculate the crossAxisCount of the choices grid
          maxCAC = (MediaQuery.of(context).size.width / 400).floor();
          print("CAC = " +
              widget.charts[chartTypeList[selectedTypeIndex]].keys.length
                  .toString());
          print("maxCAC = " + maxCAC.toString());
          if (maxCAC <=
              widget.charts[chartTypeList[selectedTypeIndex]].keys.length) {
            CAC = maxCAC;
          } else {
            print("setting CAC");
            CAC = widget.charts[chartTypeList[selectedTypeIndex]].keys.length;
          }

          print(widget.charts[chartTypeList[selectedTypeIndex]].keys);
          print(widget.charts[chartTypeList[selectedTypeIndex]]);

          return Scaffold(
            body: Container(
              color: activeTheme(_prefs!, "background"),
              child: Row(
                children: [
                  Container(
                      // Selector Column
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          children:
                              List.generate(widget.charts.keys.length, (index) {
                        return Expanded(
                            child: MouseRegion(
                          child: GestureDetector(
                            child: Container(
                              color:
                                  chartTypeButtonColors[chartTypeList[index]],
                              width: 30,
                              child: Row(
                                children: [
                                  Container(
                                      color: activeTheme(_prefs!,
                                              "chartTypeUnderlineColors")
                                          ?.elementAt(index),
                                      width: 5),
                                  Container(
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                          child: VertText(
                                        chartTypeList[index],
                                        TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                activeTheme(_prefs!, "text")),
                                      ))),
                                ],
                              ),
                            ),
                            onTap: () => _loadCharts(chartTypeList[index]),
                            onTapDown: (s) => setState(() {
                              if (selectedTypeIndex != index) {
                                _setChartTypeButton(index, "normal");
                              }
                            }),
                            onTapUp: (s) => setState(() {
                              if (selectedTypeIndex != index) {
                                _setChartTypeButton(index, "hover");
                              }
                            }),
                          ),
                          onEnter: (s) => setState(() {
                            if (selectedTypeIndex != index) {
                              _setChartTypeButton(index, "hover");
                            }
                          }),
                          onExit: (s) => setState(() {
                            if (selectedTypeIndex != index) {
                              _setChartTypeButton(index, "normal");
                            }
                          }),
                        ));
                      }))),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                        width: choicesSize,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(3),
                        color: chartOptionContainerColor,
                        child: Builder(
                          builder: (context) {
                            if (!choicesActive) {
                              return Container(
                                padding: EdgeInsets.all(7),
                                child: Text(
                                    "No chart type selected! Please choose from the column on the left."),
                                alignment: Alignment.center,
                              );
                            } else {
                              return Container(
                                color: activeTheme(_prefs!, "background"),
                                width: double.infinity,
                                height: double.infinity,
                                child: ListView.separated(
                                    padding: EdgeInsets.all(5),
                                    scrollDirection: Axis.vertical,
                                    itemCount: chartOptionList.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return MouseRegion(
                                        child: GestureDetector(
                                          child: Container(
                                              color: chartOptionButtonColors[
                                                  chartOptionList[index]],
                                              padding: EdgeInsets.all(5),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    chartOptionList[index],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: activeTheme(
                                                          _prefs!, "text"),
                                                    ),
                                                  ),
                                                  Text(
                                                      widget.charts[chartTypeList[
                                                              selectedTypeIndex]]
                                                          [chartOptionList[
                                                              index]]["detail"],
                                                      style: TextStyle(
                                                        color: activeTheme(
                                                            _prefs!, "text"),
                                                      ))
                                                ],
                                              )),
                                          onTap: () => _openChart(index),
                                          onTapDown: (s) => setState(() {
                                            if (selectedOptionIndex != index) {
                                              _setChartOptionButton(
                                                  index, "normal");
                                            }
                                          }),
                                          onTapUp: (s) => setState(() {
                                            if (selectedOptionIndex != index) {
                                              _setChartOptionButton(
                                                  index, "hover");
                                            }
                                          }),
                                        ),
                                        onEnter: (s) => setState(() {
                                          if (selectedOptionIndex != index) {
                                            _setChartOptionButton(
                                                index, "hover");
                                          }
                                        }),
                                        onExit: (s) => setState(() {
                                          if (selectedOptionIndex != index) {
                                            _setChartOptionButton(
                                                index, "normal");
                                          }
                                        }),
                                      );
                                    }),
                              );
                            }
                          },
                        )),
                  ),
                  MouseRegion(
                    child: GestureDetector(
                      child: Container(
                        width: 30,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(5),
                        color: chartsCloseColor,
                        child: choicesIcon,
                      ),
                      onTap: () => setState(() {
                        choicesIcon = choicesSize == 300
                            ? Icon(
                                Icons.arrow_forward_ios,
                                color: activeTheme(_prefs!, "text"),
                              )
                            : Icon(
                                Icons.arrow_back_ios_new,
                                color: activeTheme(_prefs!, "text"),
                              );
                        choicesSize = choicesSize == 300 ? 0 : 300;
                      }),
                      onTapDown: (s) => setState(() {
                        chartsCloseColor =
                            activeTheme(_prefs!, "chartsClose_hover");
                      }),
                      onTapUp: (s) => setState(() {
                        chartsCloseColor = activeTheme(_prefs!, "chartsClose");
                      }),
                    ),
                    onEnter: (s) => setState(() {
                      chartsCloseColor =
                          activeTheme(_prefs!, "chartsClose_hover");
                    }),
                    onExit: (s) => setState(() {
                      chartsCloseColor = activeTheme(_prefs!, "chartsClose");
                    }),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.pink,
                          alignment: Alignment.center,
                          child:
                              Text("Click here to open in another program!")),
                      Expanded(
                          child: Container(
                              color: activeTheme(_prefs!, ("background")),
                              child: Builder(builder: (context) {
                                if (Platform.isIOS || Platform.isAndroid) {
                                  return PdfViewPinch(
                                    controller: pdfPinchController,
                                  );
                                } else {
                                  return PdfView(
                                    controller: pdfController,
                                  );
                                }
                              }))),
                      Container(
                          padding: EdgeInsets.all(5),
                          height: 15,
                          width: double.infinity,
                          child: Text("FOR SIMULATION PURPOSES ONLY!"))
                    ],
                  ))
                ],
              ),
            ),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
