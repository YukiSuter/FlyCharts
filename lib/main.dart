import 'dart:async';
import 'dart:io';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'package:internet_file/internet_file.dart';

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
    "accent": Color.fromARGB(255, 0, 150, 136),
    "appBarPrimary": Color.fromARGB(255, 0, 45, 105),
    "appBarSecondary": Color.fromARGB(255, 17, 83, 83),
    "appBar_text": Colors.white,
    "searchBar_text": Color.fromARGB(255, 255, 255, 255),
    "searchBar_background": Color.fromARGB(255, 58, 58, 58),
    "searchBar_border": Color.fromARGB(255, 43, 43, 43),
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

  double choicesSize = 300;
  Icon choicesIcon = Icon(Icons.arrow_back_ios_new);

  String tempPath = "";


  var pdfPinchController = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/sample.pdf'),
  );

  var pdfController = PdfController(
    document: PdfDocument.openAsset('assets/sample.pdf'),
  );

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

  Future<void> _openChart(index) async {
    selectedOptionIndex = index;
    _setPDF(widget.charts[chartTypeList[selectedTypeIndex]][chartOptionList[selectedOptionIndex]]["link"]);

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
      pdfPinchController.loadDocument(PdfDocument.openData(InternetFile.get(link)));
    } else {
      pdfController.loadDocument(PdfDocument.openData(InternetFile.get(link)));
    }


    // setState(() {
    //
    // });
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
                                        onTap: () => _openChart(index),
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
                ),
                MouseRegion(
                  child: GestureDetector(
                    child:Container(
                      width: 30,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(5),
                      color: chartsCloseColor,
                      child: choicesIcon,
                    ),
                    onTap: () => setState(() {
                      choicesIcon = choicesSize == 300? Icon(Icons.arrow_forward_ios) : Icon(Icons.arrow_back_ios_new);
                      choicesSize = choicesSize == 300? 0 : 300;
                    }),
                    onTapDown: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose_hover"];}),
                    onTapUp: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose"];}),
                  ),
                  onEnter: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose_hover"];}),
                  onExit: (s) => setState(() {chartsCloseColor = Themes[activeTheme]["chartsClose"];}),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.pink,
                        alignment: Alignment.center,
                        child: Text("Click here to open in another program!")
                      ),
                      Expanded(
                        child: Container(
                          color: Themes[activeTheme]!["background"],
                          child: Builder(
                              builder: (context) {
                                if (Platform.isIOS || Platform.isAndroid) {
                                  return PdfViewPinch(
                                    controller: pdfPinchController,
                                  );
                                } else {
                                  return PdfView(
                                    controller: pdfController,
                                  );
                                }
                              }
                          )
                        )
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 15,
                        width: double.infinity,
                        child: Text(
                          "FOR SIMULATION PURPOSES ONLY!"
                        )
                      )
                    ],
                  )
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
        body: Container(
          color: Themes[activeTheme]!["background"],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15), 
                        child:SearchBar()
                      )
                    ]
                  )
                )
              ),
              BottomNavBarFb2()
              ],
            )
        )

    );
  }
}

class BottomNavBarFb2 extends StatelessWidget {
  const BottomNavBarFb2({Key? key}) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBottomBar(
                    text: "Home",
                    icon: Icons.home,
                    selected: true,
                    onPressed: () {}),
                IconBottomBar(
                    text: "Search",
                    icon: Icons.search_outlined,
                    selected: false,
                    onPressed: () {}),
                IconBottomBar(
                    text: "Cart",
                    icon: Icons.local_grocery_store_outlined,
                    selected: false,
                    onPressed: () {}),
                IconBottomBar(
                    text: "Calendar",
                    icon: Icons.date_range_outlined,
                    selected: false,
                    onPressed: () {})
              ],
            ),
          ),
        ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

 final primaryColor = const Color(0xff4338CA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? primaryColor : Colors.black54,
          ),
        ),
         Text(
          text,
          style: TextStyle(
              fontSize: 12,
              height: .1,
              color: selected
                  ? primaryColor
                  : Colors.grey.withOpacity(.75)),
        )
      ],
    );
  }
}


class FadeAppBarTutorial extends StatefulWidget {
  const FadeAppBarTutorial({Key? key}) : super(key: key);

  @override
  State<FadeAppBarTutorial> createState() => _FadeAppBarTutorialState();
}

class _FadeAppBarTutorialState extends State<FadeAppBarTutorial> {
  late ScrollController _scrollController;
  double _scrollControllerOffset = 0.0;

  _scrollListener() {
    setState(() {
      _scrollControllerOffset = _scrollController.offset;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff123456),
        body: Container(
          // Place as the child widget of a scaffold
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fdave-hoefler-PEkfSAxeplg-unsplash.jpg?alt=media&token=8b7e1d44-a52f-49f9-a3ae-e542cca0f368"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                      child: Container(
                    height: MediaQuery.of(context).size.height * 1.5,
                    child: Center(
                        child: Text(
                      "🚀",
                      style: TextStyle(
                          color: Themes[activeTheme]!["searchBar_text"],
                          fontSize: 75,
                          fontWeight: FontWeight.bold),
                    )),
                  ))
                ],
              ),
              PreferredSize(
                  child: FadeAppBar(scrollOffset: _scrollControllerOffset),
                  preferredSize: Size(MediaQuery.of(context).size.width, 20.0))
            ],
          ), // Place child here
        ));
  }
}

class FadeAppBar extends StatelessWidget {
  final double scrollOffset;
  const FadeAppBar({Key? key, required this.scrollOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 24.0,
          ),
          color: Colors.white
              .withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
          child: SafeArea(child: SearchInput()),
        ));
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1)),
        ]),
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            // prefixIcon: Icon(Icons.email),
            prefixIcon: Icon(Icons.search, size: 20, color: Themes[activeTheme]!["accent"]),
            filled: true,
            fillColor: Themes[activeTheme]!["searchBar_background"],
            hintText: 'Search by ICAO',
            hintStyle: TextStyle(color: Themes[activeTheme]!["searchBar_text"].withOpacity(.75)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Themes[activeTheme]!["searchBar_border"], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Themes[activeTheme]!["searchBar_border"], width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
          onChanged: (value) {
            
          },
        ));
  }
}