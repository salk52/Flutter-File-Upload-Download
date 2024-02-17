import 'dart:io';

import 'package:flutter/material.dart';

class FilePreview extends StatefulWidget {
  @override
  State<FilePreview> createState() => _FilePreviewState();

  const FilePreview({super.key, required this.file});

  final File file;
}

class _FilePreviewState extends State<FilePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Image.file(
          widget.file,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
