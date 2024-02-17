import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upload_download_app/models/file.dart';
import 'package:upload_download_app/util/util.dart';

class FileRow extends StatefulWidget {
  //get onDownloadProgress => Widget_onDownloadProgress;

  //_FileRowState createState() => _FileRowState();
  @override
  State<FileRow> createState() => _FileRowState();

  FileRow(
      {super.key,
      required this.file,
      required this.index,
      required this.onTap,
      required this.onDismised,
      required this.onDownloadProgress});

  final File file;
  final int index;

  final void Function(File, FileRow) onTap;
  final void Function(int) onDismised;
  late void Function(int, int) onDownloadProgress;
}

class _FileRowState extends State<FileRow> {
  final _formatter = DateFormat('yyyy/MM/dd HH:ss');

  double _progressValue = 0.0;
  int _progressPercentValue = 0;
  double _uploadHeight = 0;

  @override
  void initState() {
    super.initState();

    widget.onDownloadProgress = _onDownloadProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.file.fileName),
            subtitle: Text(_formatter.format(widget.file.dateModified)),
            //isThreeLine: true,
            onTap: () {
              widget.onTap(widget.file, widget);
            },
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            height: _uploadHeight,
            child: ClipRect(
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 26, 0, 0),
                    child: Text(
                      "$_progressPercentValue %",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDownloadProgress(int receivedBytes, int totalBytes) {
    double newProgressValue = Util.remap(receivedBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);

    if (receivedBytes == 0 && totalBytes == 0) {
      _uploadHeight = 0;
    } else if (_uploadHeight == 0) {
      _uploadHeight = 50;
    }

    newProgressValue = double.parse(newProgressValue.toStringAsFixed(2));

    if (newProgressValue != _progressValue) {
      setState(() {
        _progressValue = newProgressValue;
        _progressPercentValue = (_progressValue * 100.0).toInt();
      });
    }
  }
}
