import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/controllers/upload_controller.dart';
import 'dart:math' as math;

import 'package:upload_download_app/models/fab_mini_menu.dart';

class FabMenu extends StatefulWidget {
  const FabMenu({super.key});

  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with TickerProviderStateMixin {
  late AnimationController _controller;

  UploadController get uploadController => Provider.of<UploadController>(context, listen: false);

  @override
  void initState() {
    super.initState();

    _buildFabMenus();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(fabItems.length, (int index) {
        Widget child = Container(
          padding: const EdgeInsets.only(bottom: 10),
          // height: 70.0,
          // width: 56.0,
          //alignment: FractionalOffset.bottomRight,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              //   curve: new Interval(
              //       1.0 * index / 10.0, 1.0 - index / fabItems.length / 2.0,
              //       curve: Curves.fastOutSlowIn),
              curve: Curves.fastOutSlowIn,
            ),
            child: FloatingActionButton(
              heroTag: null,
              //backgroundColor: backgroundColor,
              mini: false,
              child: Icon(fabItems[index].icon),
              onPressed: () {
                fabItems[index].action();
                _controller.reverse();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          FloatingActionButton(
            heroTag: null,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _controller.value * 1.0 * math.pi,
                  child: Icon(_controller.isDismissed ? Icons.menu : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }

  late List<FabMiniMenu> fabItems;

  // XFile? _imageFile;

  void _buildFabMenus() {
    fabItems = [
      FabMiniMenu(icon: Icons.cloud_upload, action: () => uploadController.uploadFile(uploadController.imageFileName)),
      FabMiniMenu(
          //icon: Icons.image, action: () => _pickImage(ImageSource.gallery)),
          icon: Icons.image,
          action: () => _chooseFile()),
      FabMiniMenu(icon: Icons.camera, action: () => _pickImage(ImageSource.camera)),
    ];
  }

  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    var imageFile = await picker.pickImage(source: source);
    if (imageFile != null) {
      uploadController.setImageFileName(imageFile.path);
    }
  }

  void _chooseFile() async {
    final ImagePicker picker = ImagePicker();

    var fileNames = await picker.pickMedia();

    if (fileNames != null) {
      //uploadController.setImageFile(fileNames.files[0]);
      uploadController.setImageFileName(fileNames.path);
    }
  }
}
