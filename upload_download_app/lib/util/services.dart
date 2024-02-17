import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upload_download_app/controllers/download_controller.dart';
import 'package:upload_download_app/controllers/settings_controller.dart';
import 'package:upload_download_app/controllers/upload_controller.dart';
import 'package:upload_download_app/services/app_service.dart';
import 'package:upload_download_app/services/dialog_service.dart';
import 'package:upload_download_app/services/preferences_service.dart';
import 'package:upload_download_app/services/snackbar_service.dart';

import 'package:get_it/get_it.dart';

var locator = GetIt.instance;

Future setup() async {
  final logger = Logger();

  final preferencesService = PreferencesService(await SharedPreferences.getInstance());

  preferencesService.load();

  locator.registerSingleton<Logger>(logger);
  locator.registerSingleton<SnackbarService>(SnackbarService());
  locator.registerSingleton<PreferencesService>(preferencesService);
  locator.registerSingleton<DialogService>(DialogService());

  final appService = AppService(logger, preferencesService);

  locator.registerSingleton<AppService>(appService);

  logger.w("SERVICES are ready");
}

Future<List<SingleChildWidget>> getProviders() async {
  final logger = locator<Logger>();

  final appService = AppService(locator<Logger>(), locator<PreferencesService>());

  return [
    ChangeNotifierProvider(create: (context) => appService),
    ChangeNotifierProvider(create: (context) => SettingsController(logger, appService)),
    ChangeNotifierProvider(create: (context) => DownloadController(logger)),
    ChangeNotifierProvider(create: (context) => UploadController(logger)),
  ];
}
