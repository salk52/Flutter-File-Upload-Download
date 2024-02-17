import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/util/services.dart' as services;
import 'package:upload_download_app/views/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await services.setup();

  runApp(
    BetterFeedback(
      child: MultiProvider(
        providers: await services.getProviders(),
        child: const AppWidget(),
      ),
    ),
  );
}
