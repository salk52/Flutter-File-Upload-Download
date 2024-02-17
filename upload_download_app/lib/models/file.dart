import 'dart:convert';

// USED https://app.quicktype.io/ TO CREATE THIS FILE FROM /api/file GET

List<File> fileFromJson(String str) {
  final jsonData = json.decode(str);
  return List<File>.from(jsonData.map((x) => File.fromJson(x)));
}

String fileToJson(List<File> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class File {
  String fileName;
  DateTime dateModified;
  int size;

  File({
    required this.fileName,
    required this.dateModified,
    required this.size,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    //debugPrint( "Datum: ${json["dateModified"]}");

    return File(
      fileName: json["fileName"],
      dateModified: DateTime.parse(json["dateModified"]),
      size: json["size"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "dateModified": dateModified,
        "size": size,
      };
}
