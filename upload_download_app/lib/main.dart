import 'package:flutter/material.dart';
import 'package:upload_download_app/util/custom_http_overrides.dart';
import 'package:upload_download_app/views/home_page.dart';

void main() {
  // ENABLE SELFSIGNED CERTIFICATES FOR WHOLE APP
  // HttpOverrides.global = new CustomHttpOverrides();

  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload/Download Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: HomePage(title: 'File Upload/Download Demo'),
      ),
    );
  }
}
