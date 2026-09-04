class EditProfileModel {
  EditProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory EditProfileModel.fromJson(Map<String, dynamic> json){
    return EditProfileModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.userName,
    required this.mobile,
  });

  final String? userName;
  final String? mobile;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      userName: json["user_name"]?.toString(),
      mobile: json["mobile"]?.toString(),
    );
  }

}
