import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:upload_download_app/models/file.dart';
import 'package:upload_download_app/util/util.dart';

class FileRow extends StatefulWidget {
  _FileRowState createState() => _FileRowState();

  FileRow(
      {Key key,
      @required this.file,
      @required this.index,
      @required this.onTap,
      @required this.onDismised})
      : assert(file != null),
        assert(index != null),
        super(key: key);

  final File file;
  final int index;
  final void Function(File, FileRow) onTap;
  final void Function(int) onDismised;

  final _isDownloading = false;

  void Function(int, int) onDownloadProgress;
}

class _FileRowState extends State<FileRow> {
  final _formatter = new DateFormat('yyyy/MM/dd HH:ss');

  double _progressValue = 0.0;
  int _progressPercentValue = 0;
  double _uploadHeight = 0;

  @override
  void initState() {
    super.initState();

    widget.onDownloadProgress = _setDownloadProgress;
  }

  Widget build(BuildContext context) {
    return
        // Dismissible(
        //   key: Key(widget.file.fileName),
        //   onDismissed: (direction) async {
        //     widget.onDismised(widget.index);
        //     await Future.delayed(Duration(seconds: 1));
        //     setState(() {});

        //     Scaffold.of(context)
        //         .showSnackBar(SnackBar(content: Text("${widget.file.fileName} deleted")));
        //   },
        //   child:
        Column(
      children: <Widget>[
        ListTile(
          title: Text(widget.file.fileName),
          subtitle: Text(_formatter.format(widget.file.dateModified)),
          onTap: () {
            widget.onTap(widget.file, widget);
          },
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          height: _uploadHeight,
          child: ClipRect(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: LinearProgressIndicator(
                    value: _progressValue,
                  ),
                ),
                Text(
                  "$_progressPercentValue %",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _setDownloadProgress(int receivedBytes, int totalBytes) {
    double __progressValue = Util.remap(receivedBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);

    if (receivedBytes == 0 && totalBytes == 0) {
      _uploadHeight = 0;
    } else if (_uploadHeight == 0) {
      _uploadHeight = 50;
    }

    __progressValue = double.parse(__progressValue.toStringAsFixed(2));

    if (__progressValue != _progressValue)
      setState(() {
        _progressValue = __progressValue;
        _progressPercentValue = (_progressValue * 100.0).toInt();
      });
  }
}
