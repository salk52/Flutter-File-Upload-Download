import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upload_download_app/services/app_service.dart';

class SettingsController extends ChangeNotifier {
  late SharedPreferences prefs;

  final Logger logger;
  final AppService appService;

  SettingsController(this.logger, this.appService);

  void setUrl(String url) async {
    appService.baseUrl = url;
    notifyListeners();
  }

  String get url => appService.baseUrl;

  //ThemeMode _themeMode;
  ThemeMode get thememode => appService.themeMode;

  void setThemeMode(ThemeMode themeMode) async {
    appService.themeMode = themeMode;
    notifyListeners();
  }
}
