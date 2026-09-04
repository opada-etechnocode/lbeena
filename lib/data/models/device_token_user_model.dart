class DeviceTokenUserModel {
  DeviceTokenUserModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory DeviceTokenUserModel.fromJson(Map<String, dynamic> json){
    return DeviceTokenUserModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.iosTokens,
    required this.androidTokens,
  });

  final List<String> iosTokens;
  final List<String> androidTokens;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      iosTokens: json["ios_tokens"] == null ? [] : List<String>.from(json["ios_tokens"]!.map((x) => x)),
      androidTokens: json["android_tokens"] == null ? [] : List<String>.from(json["android_tokens"]!.map((x) => x)),
    );
  }

}
