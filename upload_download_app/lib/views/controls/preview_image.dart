import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as file_util;

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, required this.imageFileName});

  final String imageFileName;

  @override
  Widget build(BuildContext context) {
    if (imageFileName == "") {
      return Container(
        //color: Colors.red,
        alignment: Alignment.center,
        child: const Text(
          "Choose file",
          style: TextStyle(fontSize: 26),
        ),
      );
    } else if (imageFileName != "" &&
        ['.jpg', 'jpeg', '.bmp', '.png']
            .contains(file_util.extension(imageFileName))) // .contains(fileUtil.extension(_imageFile.path))
    {
      return Image.file(File(imageFileName), fit: BoxFit.fitHeight);
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "File: ${file_util.basename(imageFileName)}",
          style: const TextStyle(fontSize: 26),
        ),
      );
    }
  }
}
