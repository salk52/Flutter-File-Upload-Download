import 'package:flutter/material.dart';

//import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/controllers/download_controller.dart';
import 'package:upload_download_app/services/file_service.dart';

import 'package:upload_download_app/services/snackbar_service.dart';
import 'package:upload_download_app/util/services.dart';
import 'package:upload_download_app/views/controls/file_row.dart';

class DownloadTab extends StatefulWidget {
  const DownloadTab({super.key});

  @override
  State<DownloadTab> createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> with AutomaticKeepAliveClientMixin<DownloadTab> {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  DownloadController get downloadController => Provider.of<DownloadController>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<DownloadController>(builder: (context, downloadControllerConsumer, child) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await downloadController.dataLoad();
        },
        child: //_fileList.isEmpty
            //? Center(child: Text("No data", style: TextStyle(fontSize: 26))) :

            Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            //physics: BouncingScrollPhysics(),
            itemCount: downloadControllerConsumer.fileList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 6,
                shadowColor: Colors.transparent,
                child: Dismissible(
                  key: Key(downloadControllerConsumer.fileList[index].fileName),
                  onDismissed: (direction) {
                    FileService.fileDelete(downloadControllerConsumer.fileList[index].fileName);
                    downloadControllerConsumer.fileList.removeAt(index);
                    locator<SnackbarService>().showSnackBar("File deleted");
                  },
                  child: FileRow(
                    file: downloadControllerConsumer.fileList[index],
                    index: index,
                    onTap: downloadControllerConsumer.downloadFile,
                    onDismised: (i) {
                      // _fileList.removeAt(i);
                    },
                    onDownloadProgress: downloadControllerConsumer.setUploadProgress,
                    key: Key(downloadControllerConsumer.fileList[index].fileName),
                  ),
                ),
              );
            },

            // separatorBuilder: (BuildContext context, int index) {
            //   return const Divider(color: Colors.black38);
            // },
          ),
        ),
      );
    });
  }
}
