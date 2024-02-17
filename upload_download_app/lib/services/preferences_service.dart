import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  late final SharedPreferences _sharedPreferences;

  PreferencesService(this._sharedPreferences);

  void load() {
    _url = _sharedPreferences.getString('url') ?? "http://192.168.0.12:8080";

    //_sharedPreferences.setInt('themeMode', 0);
  }

  late String _url = "";

  void setUrl(String url) async {
    _url = url;

    await _sharedPreferences.setString('url', url);
  }

  String get url => _url;

  late ThemeMode _themeMode = ThemeMode.values[_sharedPreferences.getInt('themeMode') ?? 0];

  void setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;

    await _sharedPreferences.setInt('themeMode', themeMode.index);
  }

  ThemeMode get themeMode => _themeMode;
}
