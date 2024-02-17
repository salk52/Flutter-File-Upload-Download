import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/services/app_service.dart';
import 'package:upload_download_app/services/snackbar_service.dart';
import 'package:upload_download_app/theme/dark_theme.dart';
import 'package:upload_download_app/theme/light_theme.dart';
import 'package:upload_download_app/util/services.dart';
import 'package:upload_download_app/views/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppService>(builder: (context, appService, child) {
      return MaterialApp(
        title: 'File Upload/Download',
        themeMode: appService.themeMode,
        darkTheme: darkTheme,
        theme: lightTheme,
        home: const HomePage(title: 'File Upload/Download'),
        //navigatorKey: services.locator<DialogService>().dialogNavigationKey,
        navigatorKey: locator<SnackbarService>().navigatorKey,
      );
    });
  }
}
