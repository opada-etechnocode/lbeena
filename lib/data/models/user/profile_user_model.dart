class ProfileUserModel {
  ProfileUserModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory ProfileUserModel.fromJson(Map<String, dynamic> json){
    return ProfileUserModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.user,
  });

  final User? user;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

}

class User {
  User({
    required this.userName,
    required this.mobile,
    required this.profilePic,
    required this.createdAt,
    required this.note,
    required this.desc_user,
  });

  final String? userName;
  final String? mobile;
  final String? profilePic;
  final String? desc_user;
  final DateTime? createdAt;
  final dynamic note;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userName: json["user_name"]?.toString(),
      desc_user: json["desc_user"]?.toString(),
      mobile: json["mobile"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      note: json["note"]?.toString(),
    );
  }

}
