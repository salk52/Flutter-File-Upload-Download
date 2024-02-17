import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as file_util;
import 'package:path_provider/path_provider.dart';

import 'package:upload_download_app/models/file.dart' as model;
import 'package:permission_handler/permission_handler.dart';
import 'package:upload_download_app/services/preferences_service.dart';
import 'package:upload_download_app/util/services.dart';

//import 'package:sanitize_filename/sanitize_filename.dart';

typedef OnDownloadProgressCallback = void Function(int receivedBytes, int totalBytes);
typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

class FileService {
  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  static String get baseUrl =>
      locator<PreferencesService>().url; //Provider.of<SettingsController>(locator<BuildContext>(), listen: false).url;

  static fileGetAllMock() {
    return List.generate(
      20,
      (i) => model.File(
          fileName: 'filename $i.jpg', dateModified: DateTime.now().add(Duration(minutes: i)), size: i * 1000),
    );
  }

  static Future<List<model.File>> fileGetAll() async {
    var httpClient = getHttpClient();

    final url = '$baseUrl/api/file';

    var httpRequest = await httpClient.getUrl(Uri.parse(url));

    var httpResponse = await httpRequest.close();

    var jsonString = await readResponseAsString(httpResponse);

    var list = model.fileFromJson(jsonString);

    list.sort((a, b) => b.dateModified.compareTo(a.dateModified));

    return list;
  }

  static Future<String> fileDelete(String fileName) async {
    var httpClient = getHttpClient();

    final url = Uri.encodeFull('$baseUrl/api/file/$fileName');

    var httpRequest = await httpClient.deleteUrl(Uri.parse(url));

    var httpResponse = await httpRequest.close();

    var response = await readResponseAsString(httpResponse);

    return response;
  }

  static Future<String> fileUpload({required File file, OnUploadProgressCallback? onUploadProgress}) async {
    //assert(file != null);

    //debugger();

    final url = '$baseUrl/api/file';

    final fileStream = file.openRead();

    int totalByteLength = file.lengthSync();

    final httpClient = getHttpClient();

    final request = await httpClient.postUrl(Uri.parse(url));

    request.headers.set(HttpHeaders.contentTypeHeader, ContentType.binary);

    request.headers.add("filename", file_util.basename(file.path));

    request.contentLength = totalByteLength;

    int byteCount = 0;
    Stream<List<int>> streamUpload = fileStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }

          sink.add(data);
        },
        handleError: (error, stack, sink) {
          debugPrint(error.toString());
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    if (httpResponse.statusCode != 200) {
      throw Exception('Error uploading file');
    } else {
      return await readResponseAsString(httpResponse);
    }
  }

  static Future<String> fileUploadMultipart({required XFile file, OnUploadProgressCallback? onUploadProgress}) async {
    //assert(file != null);

    //debugger();

    final url = '$baseUrl/api/file';

    final httpClient = getHttpClient();

    final request = await httpClient.postUrl(Uri.parse(url));

    int byteCount = 0;

    var multipart = await http.MultipartFile.fromPath(file_util.basename(file.path), file.path);

    // final fileStreamFile = file.openRead();

    // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
    //     filename: fileUtil.basename(file.path));

    var requestMultipart = http.MultipartRequest("POST", Uri.parse(url));

    requestMultipart.files.add(multipart);

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;

    request.contentLength = totalByteLength;

    request.headers.set(HttpHeaders.contentTypeHeader, requestMultipart.headers[HttpHeaders.contentTypeHeader]!);

    Stream<List<int>> streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();
//
    var statusCode = httpResponse.statusCode;

    if (statusCode ~/ 100 != 2) {
      throw Exception('Error uploading file, Status code: ${httpResponse.statusCode}');
    } else {
      return await readResponseAsString(httpResponse);
    }
  }

  static Future<String> fileDownload({required String fileName, OnUploadProgressCallback? onDownloadProgress}) async {
    //debugger();

    // var checkPermission = await checkPermissionStatus();

    // if (!checkPermission) {
    //   await requestPermission();
    // }

    final url = Uri.encodeFull('$baseUrl/api/file/$fileName');

    final httpClient = getHttpClient();

    final request = await httpClient.getUrl(Uri.parse(url));

    request.headers.add(HttpHeaders.contentTypeHeader, "application/octet-stream");

    var httpResponse = await request.close();

    int byteCount = 0;
    int totalBytes = httpResponse.contentLength;

    var appDocDir = await getExternalStorageDirectory();

    appDocDir = Directory('/storage/emulated/0/Download');

    //debugger();

    var appDocPath = appDocDir.path;

    debugPrint("---------------------------------------");
    debugPrint("PATH: $appDocPath");

    var file = File("$appDocPath/$fileName");

    //var randomAccesFile = file.openSync(mode: FileMode.write);

    var completer = Completer<String>();

    var progress = 0;

    httpResponse.listen(
      (data) async {
        byteCount += data.length;

        //randomAccesFile.writeFromSync(data);
        file.writeAsBytes(data);

        var currentProgress = ((byteCount * 1.0 / totalBytes * 100)).toInt();

        //print("currentProgress: $currentProgress");

        if (progress != currentProgress) {
          progress = currentProgress;
          //print("---------------------------------------");
          //print("Progress: $progress %");

          onDownloadProgress?.call(byteCount, totalBytes);
        }
      },
      onDone: () async {
        //await randomAccesFile.close();

        completer.complete(file.path);
      },
      onError: (e) async {
        //await randomAccesFile.close();
        await file.delete();
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  static Future<String> fileDownload2({required String fileName, OnUploadProgressCallback? onDownloadProgress}) async {
    final url = Uri.encodeFull('$baseUrl/api/file/$fileName');

    var appDocDir = await getExternalStorageDirectory();

    appDocDir = Directory('/storage/emulated/0/Download');

    var appDocPath = appDocDir.path;

    //var fullFilename = "$appDocPath/${sanitizeFilename(fileName)}";

    var fullFilename = "$appDocPath/$fileName";

    if (await File(fullFilename).exists()) {
      fullFilename = "$appDocPath/_$fileName";
    }

    // print("-----------------------------------");
    // print(fullFilename);
    // print(fullFilename2);

    Dio dio = Dio();

    await dio.download(
      url,
      fullFilename,
      onReceiveProgress: (recivedBytes, totalBytes) {
        onDownloadProgress?.call(recivedBytes, totalBytes);
      },
      deleteOnError: true,
    );
    return fullFilename;
  }

  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  static Future<void> requestPermission() async {
    const permission = Permission.manageExternalStorage;

    if (await permission.isDenied) {
      await permission.request();
    }
  }

  static Future<bool> checkPermissionStatus() async {
    const permission = Permission.manageExternalStorage;

    return await permission.status.isGranted;
  }
}
