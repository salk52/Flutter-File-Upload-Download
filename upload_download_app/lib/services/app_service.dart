import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:upload_download_app/services/dialog_service.dart';
import 'package:upload_download_app/services/preferences_service.dart';
import 'package:upload_download_app/util/services.dart';

class AppService extends ChangeNotifier {
  AppService(this.logger, this._preferencesService);

  final Logger logger;
  final PreferencesService _preferencesService;

  Future<String> getWelcomeMessage() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Welcome to the app';
  }

  String get baseUrl => _preferencesService.url;

  //String backed = "";

  set baseUrl(String value) {
    _preferencesService.setUrl(value);
    //backed = value;
    notifyListeners();
    logger.w('Base URL changed to $value');
  }

  proba() {
    locator<DialogService>().showMyDialog(
        title: 'Hello, Dialog!',
        description:
            'This is a dialog.\n\nIt is a dialog.\n\nasasdsdm sdasdas \n\nasdasda gdf gdfg');
  }

  // ThemeMode _themeMode;
  // ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    _preferencesService.setThemeMode(value);
    notifyListeners();
    logger.w('Theme mode changed to $value');
  }

  ThemeMode get themeMode => _preferencesService.themeMode;
}
