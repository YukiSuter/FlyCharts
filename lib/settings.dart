import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

List<String> settingsNames = ["activeTheme", "pdfViewer"];

Map<String, Map<String, dynamic>> settingsInfo = {
  "activeTheme": {
    "label": "Theme",
    "choices": ["light", "dark"],
    "default": "dark"
  },
  "pdfViewer": {
    "label": "PDF Viewer",
    "choices": ["webview", "built-in"],
    "default": "built-in"
  }
};

dynamic getSettingValue(SharedPreferences prefs, String key, Type type) {
  switch (type) {
    case String:
      return prefs.getString(key);
    case int:
      return prefs.getInt(key);
    case bool:
      return prefs.getBool(key);
    case double:
      return prefs.getDouble(key);
    case List:
      return prefs.getStringList(key);
  }
}

dynamic setSettingValue(
    SharedPreferences prefs, String key, dynamic val) async {
  print("Setting " + key + " to " + (val));
  if (val is int) {
    await prefs.setInt(key, val);
    print("value set!");
  } else if (val is bool) {
    await prefs.setBool(key, val);
    print("value set!");
  } else if (val is double) {
    await prefs.setDouble(key, val);
    print("value set!");
  } else if (val is String) {
    await prefs.setString(key, val);
    print("value set!");
  } else if (val is List<String>) {
    await prefs.setStringList(key, val);
    print("value set!");
  }
}

List<String> getSettingsNames() {
  return settingsNames;
}

dynamic getSettingsInfo() {
  return settingsInfo;
}

void populateDefaults(SharedPreferences prefs) {
  for (var name in settingsNames) {
    setSettingValue(prefs, name, settingsInfo[name]?["default"]);
  }
}
