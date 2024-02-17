import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:upload_download_app/services/file_service.dart';
import 'package:upload_download_app/services/snackbar_service.dart';
import 'package:upload_download_app/util/services.dart';
import 'package:upload_download_app/util/util.dart';

class UploadController extends ChangeNotifier {
  UploadController(this.logger);

  final Logger logger;

  //List<file_model.File> _fileList = List.empty();

  //List<file_model.File> get fileList => _fileList;

  XFile _imageFile = XFile("");
  XFile get imageFile => _imageFile;

  setImageFile(XFile imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }

  String _imageFileName = "";
  String get imageFileName => _imageFileName;
  setImageFileName(String imageFileName) {
    _imageFileName = imageFileName;
    notifyListeners();
    logger.d("imageFileName set to $_imageFileName");
  }

  double _progressValue = 0;
  double get progressValue => _progressValue;

  void uploadFile(String fileName) async {
    try {
      var response = await FileService.fileUploadMultipart(file: XFile(fileName), onUploadProgress: setUploadProgress);

      debugPrint("uploadFile - $fileName");
      locator<SnackbarService>().showSnackBar("File uploaded - $response");
    } catch (err) {
      debugPrint("err - $err");
      //locator<SnackbarService>().showSnackBar("Error opening file - $err");
    }

    setUploadProgress(0, 0);
  }

  void setUploadProgress(int sentBytes, int totalBytes) {
    double newProgressValue = Util.remap(sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 100);

    newProgressValue = double.parse(newProgressValue.toStringAsFixed(0));

    if (newProgressValue != _progressValue) {
      _progressValue = newProgressValue;
      notifyListeners();
    }
  }

  List<MediaModel> imageList = <MediaModel>[];
}
