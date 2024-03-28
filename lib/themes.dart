import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String defaultTheme = "dark";

Map<String, Map<String, Color>> Themes = {
  "light": {
    'background': Color.fromARGB(255, 255, 255, 255),
    'secondaryBackground': Color.fromARGB(255, 246, 246, 246),
    'tertiaryBackground': Color(0xffE7E7E7),
    'border': Color.fromARGB(255, 0, 0, 0),
    'text': Colors.black,
    'sideBarButtons': Color.fromARGB(255, 48, 48, 48),
  },
  "dark": {
    'background': Color(0xFF282828),
    'secondaryBackground': Color(0xFF131313),
    'tertiaryBackground': Color(0xFF232323),
    'border': Color.fromARGB(255, 255, 255, 255),
    'text': Colors.white,
    'sideBarButtons': Color.fromARGB(255, 207, 207, 207),
  },
};

Color? activeTheme(SharedPreferences prefs, String themeOption) {
  String? active = prefs.getString('activeTheme');

  active ??= defaultTheme;

  print("Active Theme: " + active);

  if (Themes[active]?.containsKey(themeOption) != null) {
    return Themes[active]?[themeOption];
  } else {
    return const Color.fromARGB(255, 212, 59, 110);
  }
}
