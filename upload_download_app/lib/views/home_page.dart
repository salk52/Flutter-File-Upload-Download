import 'dart:io';
import 'dart:math' as math;

import 'package:upload_download_app/models/fab_mini_menu.dart';
import 'package:upload_download_app/models/file.dart' as model;
import 'package:upload_download_app/services/file_service.dart';
import 'package:upload_download_app/views/file_preview.dart';
import 'package:upload_download_app/views/file_row.dart';
import 'package:upload_download_app/util/util.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as fileUtil;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _buildFabMenus();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_refreshIndicatorKey.currentState.show();
      _dataLoad();
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  List<FabMiniMenu> fabItems;

  void _buildFabMenus() {
    fabItems = [
      FabMiniMenu(icon: Icons.cloud_upload, action: () => _uploadFile(_imageFile)),
      FabMiniMenu(
          //icon: Icons.image, action: () => _pickImage(ImageSource.gallery)),
          icon: Icons.image,
          action: () => _chooseFile()),
      FabMiniMenu(icon: Icons.camera, action: () => _pickImage(ImageSource.camera)),
    ];
  }

  void _uploadFile(File file) async {
    if (file == null) {
      _showSnackBar("Select file first");
      return;
    }

    _setUploadProgress(0, 0);

    try {
      // var httpResponse = await FileService.fileUpload(
      //     file: file, onUploadProgress: _setUploadProgress);

      await FileService.fileUploadMultipart(file: file, onUploadProgress: _setUploadProgress);

      _showSnackBar("File uploaded - ${fileUtil.basename(file.path)}");
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _setUploadProgress(int sentBytes, int totalBytes) {
    double __progressValue = Util.remap(sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);

    __progressValue = double.parse(__progressValue.toStringAsFixed(2));

    if (__progressValue != _progressValue)
      setState(() {
        _progressValue = __progressValue;
        _progressPercentValue = (_progressValue * 100.0).toInt();
      });
  }

  AnimationController _controller;

  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<model.File> _fileList = new List<model.File>();

  Future<Null> _dataLoad() async {
    try {
      _refreshIndicatorKey?.currentState?.show();

      var res = await FileService.fileGetAll();
      setState(() {
        _fileList = res;
      });
    } catch (err) {
      _fileList = List<model.File>();

      _showSnackBar("Error loading data");
    } finally {
      //_refreshIndicatorKey.currentState.hide();
    }
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  File _imageFile;

  double _progressValue = 0;
  int _progressPercentValue = 0;

  void _pickImage(ImageSource source) async {
    _imageFile = await ImagePicker.pickImage(source: source);
    setState(() {});
  }

  void _chooseFile() async {
    var fileName = await FilePicker.getFilePath(type: FileType.ANY);

    setState(() {
      _imageFile = File(fileName);
    });
  }

  //TabController _tabController;

  @override
  Widget build(BuildContext context) {
    DefaultTabController.of(context).addListener(() {
      setState(() {
        _fabOpacity = DefaultTabController.of(context).index == 0 ? 1 : 0;
      });
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.file_upload),
              text: 'Upload',
            ),
            Tab(icon: Icon(Icons.file_download), text: 'Download'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          _buildUploadView(),
          _buildDownloadView(),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _fabOpacity,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: _buildFabMenu(context),
      ),
    );
  }

  double _fabOpacity = 1;

  Widget _buildFabMenu(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(fabItems.length, (int index) {
        Widget child = new Container(
          padding: EdgeInsets.only(bottom: 10),
          // height: 70.0,
          // width: 56.0,
          //alignment: FractionalOffset.bottomRight,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              //   curve: new Interval(
              //       1.0 * index / 10.0, 1.0 - index / fabItems.length / 2.0,
              //       curve: Curves.fastOutSlowIn),
              curve: Curves.fastOutSlowIn,
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: false,
              child: new Icon(fabItems[index].icon, color: foregroundColor),
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
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.menu : Icons.close),
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

  Widget _buildUploadView() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Container(
              padding: EdgeInsets.only(top: 10),
              child: new Column(children: <Widget>[
                Text(
                  '$_progressPercentValue %',
                  style: Theme.of(context).textTheme.display1,
                ),
              ])),
          Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: LinearProgressIndicator(value: _progressValue)),
          new Expanded(flex: 1, child: _buildPreviewImage()),
        ]);
  }

  void _downloadFile(model.File file, FileRow fileRow) async {
    var fileName = await FileService.fileDownload(
        fileName: file.fileName, onDownloadProgress: fileRow.onDownloadProgress);

    try {
      await OpenFile.open(fileName);
    } catch (err) {
      _showSnackBar("Error opening file");
    }

    fileRow.onDownloadProgress(0, 0);

    // await Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //         fullscreenDialog: false,
    //         builder: (BuildContext c) {
    //           return new FilePreview(file: File(fileName));
    //         }));
  }

  Widget _buildDownloadView() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _dataLoad,
      child: //_fileList.isEmpty
          //? Center(child: Text("No data", style: TextStyle(fontSize: 26))) :
          ListView.separated(
        //physics: BouncingScrollPhysics(),
        itemCount: _fileList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_fileList[index].fileName),
            onDismissed: (direction) {
              FileService.fileDelete(_fileList[index].fileName);
              _fileList.removeAt(index);
              _showSnackBar("File deleted");
            },
            child: FileRow(
              file: _fileList[index],
              index: index,
              onTap: _downloadFile,
              onDismised: (i) {
                // _fileList.removeAt(i);
              },
            ),
          );
        },

        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.black38);
        },
      ),
    );
  }

  Widget _buildPreviewImage() {
    if (_imageFile == null) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "Choose file",
          style: TextStyle(fontSize: 26),
        ),
      );
    } else if (_imageFile != null &&
        ['.jpg', 'jpeg', '.bmp', '.png'].contains(
            fileUtil.extension(_imageFile.path))) // .contains(fileUtil.extension(_imageFile.path))
    {
      return Image.file(_imageFile);
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "File: ${fileUtil.basename(_imageFile.path)}",
          style: TextStyle(fontSize: 26),
        ),
      );
    }
  }
}
