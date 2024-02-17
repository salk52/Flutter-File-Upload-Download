import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/controllers/upload_controller.dart';
import 'package:upload_download_app/views/pages/camera_page.dart';
import 'package:upload_download_app/views/pages/settings_page.dart';

List<Widget> homePageActions(BuildContext context) {
  var uploadController = Provider.of<UploadController>(context, listen: false);

  return [
    IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () async {
        late List<CameraDescription> cameras;

        cameras = await availableCameras();

        var imageFile = await Navigator.push<String>(
          context,
          CupertinoPageRoute(
            builder: (context) => CameraPage(camera: cameras[0]),
          ),
        );

        if (imageFile != null) {
          uploadController.setImageFileName(imageFile);
        }
      },
    ),
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const SettingsPage()),
        );
      },
    ),
  ];
}
