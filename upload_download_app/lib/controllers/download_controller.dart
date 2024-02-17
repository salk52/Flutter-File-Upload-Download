import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
//import 'package:open_file_plus/open_file_plus.dart';
import 'package:open_filex/open_filex.dart';

import 'package:upload_download_app/models/file.dart' as file_model;
import 'package:upload_download_app/services/file_service.dart';
import 'package:upload_download_app/services/snackbar_service.dart';
import 'package:upload_download_app/util/services.dart';
import 'package:upload_download_app/util/util.dart';
import 'package:upload_download_app/views/controls/file_row.dart';

class DownloadController extends ChangeNotifier {
  DownloadController(this.logger) {
    dataLoad();
  }

  final Logger logger;

  List<file_model.File> _fileList = List.empty();

  List<file_model.File> get fileList => _fileList;

  double _progressValue = 0;

  void downloadFile(file_model.File file, FileRow fileRow) async {
    try {
      var fileName =
          await FileService.fileDownload2(fileName: file.fileName, onDownloadProgress: fileRow.onDownloadProgress);

      await OpenFilex.open(fileName);
    } catch (err) {
      locator<SnackbarService>().showSnackBar("Error opening file - $err");
    }

    fileRow.onDownloadProgress(0, 0);
  }

  Future<void> dataLoad() async {
    try {
      var res = await FileService.fileGetAll();

      _fileList = res;

      notifyListeners();

      locator<SnackbarService>().showSnackBar("Data loaded...");
    } catch (err) {
      locator<SnackbarService>().showSnackBar("Error loading data - $err");
    } finally {
      //_refreshIndicatorKey.currentState.hide();
    }
  }

  void setUploadProgress(int sentBytes, int totalBytes) {
    double newProgressValue = Util.remap(sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);

    newProgressValue = double.parse(newProgressValue.toStringAsFixed(2));

    if (newProgressValue != _progressValue) {
      _progressValue = newProgressValue;
      notifyListeners();
    }
  }
}
