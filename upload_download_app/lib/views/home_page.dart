import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upload_download_app/views/home_page_actions.dart';
import 'package:upload_download_app/views/tabs/download_tab.dart';
import 'package:upload_download_app/views/tabs/upload_tab.dart';
import 'controls/fab_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      setState(() {
        _fabOpacity = _controller.index == 0 ? 1 : 0;
      });
    });

    //locator.registerSingleton<GlobalKey<ScaffoldState>>(_scaffoldKey);
  }

  //final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  Future<void> requestPermission() async {
    const permission = Permission.manageExternalStorage;

    if (await permission.isDenied) {
      await permission.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController.of(context).addListener(() {
    //   setState(() {
    //     _fabOpacity = DefaultTabController.of(context).index == 0 ? 1 : 0;
    //   });
    // });

    //var uploadController = Provider.of<UploadController>(context, listen: false);

    return Scaffold(
      //key: locator<SnackbarService>().messengerKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: homePageActions(context),
        //backgroundColor: Theme.of(context).colorScheme.background,
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(
              icon: Icon(Icons.file_upload),
              text: 'Upload',
            ),
            Tab(icon: Icon(Icons.file_download), text: 'Download'),
            // Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          UploadTab(),
          DownloadTab(),
          //SettingsTab(),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _fabOpacity,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: const FabMenu(),
      ),
    );
  }

  double _fabOpacity = 1;
}
