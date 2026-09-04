class ColorAppModel {
  ColorAppModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory ColorAppModel.fromJson(Map<String, dynamic> json){
    return ColorAppModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.color1,
    required this.color2,
    required this.color3,
  });

  final String? color1;
  final String? color2;
  final String? color3;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      color1: json["color1"]?.toString(),
      color2: json["color2"]?.toString(),
      color3: json["color3"]?.toString(),
    );
  }

}
