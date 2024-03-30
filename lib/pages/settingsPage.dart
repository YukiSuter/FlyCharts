import 'package:flutter/material.dart';
import 'package:flycharts/main.dart';
import 'package:flycharts/scaling.dart';
import 'package:flycharts/settings.dart';
import 'package:flycharts/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({super.key, required this.oNavKey});
  final GlobalKey<NavigatorState> oNavKey;

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> settingsInfo = getSettingsInfo();
    List<String> settingsNames = getSettingsNames();
    List<dynamic> settingsValues = [];

    double calcSF = scaleFactor(context);
    return Scaffold(
      body: FutureBuilder(
          future: _prefsFuture,
          builder: (context, snapshot) {
            print("prefs: " + _prefs.toString());
            if (_prefs == null) {
              return Center(child: CircularProgressIndicator());
            }

            for (var i = 0; i < settingsNames.length; i++) {
              dynamic setting =
                  getSettingValue(_prefs!, settingsNames[i], String);
              if (setting == null) {
                setting = settingsInfo[settingsNames[i]]["default"];
                settingsValues.add(setting);
                setSettingValue(_prefs!, settingsNames[i], setting);
              }
              settingsValues.add(setting);
            }

            if (snapshot.hasData) {
              return Container(
                width: MediaQuery.of(context).size.width,
                color: activeTheme(_prefs!, "background"),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 80 * calcSF,
                      bottom: 80 * calcSF,
                      left: 300 * calcSF,
                      right: 300 * calcSF),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Settings",
                          style: TextStyle(color: activeTheme(_prefs!, "text")),
                          textScaler: TextScaler.linear(3 * calcSF),
                        ),
                        SizedBox(height: 25 * calcSF),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(8 * calcSF),
                            itemCount: settingsNames.length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget options() {
                                dynamic choices =
                                    settingsInfo[settingsNames[index]]
                                        ["choices"];

                                if (choices == "bool") {
                                  return Switch(
                                    value: settingsValues[index],
                                    onChanged: (bool value) {
                                      setState(() {
                                        settingsValues[index] != value;
                                        setSettingValue(_prefs!,
                                            settingsNames[index], value);
                                      });
                                    },
                                  );
                                } else if (choices is List<String>) {
                                  return DropdownMenu<String>(
                                    textStyle: TextStyle(
                                        color: activeTheme(_prefs!, "text")),
                                    initialSelection: settingsValues[index],
                                    onSelected: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        settingsValues[index] = value!;
                                        setSettingValue(_prefs!,
                                            settingsNames[index], value);
                                        if (settingsNames[index] ==
                                            "activeTheme") {
                                          widget.oNavKey.currentState!.push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FlyCharts(
                                                          loadpage: widget)));
                                        }
                                      });
                                    },
                                    dropdownMenuEntries:
                                        settingsInfo[settingsNames[index]]
                                                ["choices"]
                                            .map<DropdownMenuEntry<String>>(
                                                (String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  );
                                }
                                return Text("ERROR NO MATCHING WIDGET",
                                    style: TextStyle(color: Colors.red));
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                    top: 8 * calcSF, bottom: 8 * calcSF),
                                child: Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        settingsInfo[settingsNames[index]]
                                            ["label"],
                                        style: TextStyle(
                                          color: activeTheme(_prefs!, "text"),
                                        ),
                                      ),
                                      options()
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }

            return CircularProgressIndicator();
          }),
    );
  }
}
