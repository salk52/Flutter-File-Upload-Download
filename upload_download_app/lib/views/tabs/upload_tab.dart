import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/controllers/upload_controller.dart';
import 'package:upload_download_app/services/app_service.dart';
import 'package:upload_download_app/views/controls/preview_image.dart';

class UploadTab extends StatefulWidget {
  const UploadTab({super.key});

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  final double _progressValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadController>(builder: (context, uploadControllerConsumer, child) {
      return Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(children: <Widget>[
              Text(
                '${uploadControllerConsumer.progressValue} %',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ])),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: LinearProgressIndicator(value: _progressValue)),
        Expanded(
          child: Stack(
            children: [
              PreviewImage(
                imageFileName: uploadControllerConsumer.imageFileName,
              ),
              Consumer<AppService>(builder: (context, appService, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Chip(
                    // side: BorderSide(color: Colors.black, width: 2),
                    label: Text('API Url: ${appService.baseUrl}'),
                  ),
                  //Text(appService.baseUrl, style: Theme.of(context).textTheme.bodyLarge),
                  // TextButton(onPressed: () => appService.proba(), child: Text("Proba"))
                );
              }),
            ],
          ),
        ),
      ]);
    });
  }
}
