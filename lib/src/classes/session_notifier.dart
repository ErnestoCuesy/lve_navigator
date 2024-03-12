import 'package:flutter/material.dart';
import 'package:lvenavigator2/src/resources/definitions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionNotifier with ChangeNotifier {
  ThemeData? _themeData;
  late SharedPreferences _prefs;

  SessionNotifier() {
    initialize();
  }

  ThemeData? get themeData => _themeData;

  bool get currentlyDark => _themeData == darkTheme;

  SharedPreferences get prefs => _prefs;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  initialize() async {
    await SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      String? isDarkTheme = prefs.getString("_darkMode");
      if (isDarkTheme != null && isDarkTheme == 'true') {
        setTheme(darkTheme);
      } else {
        setTheme(lightTheme);
      }

    });
  }
}