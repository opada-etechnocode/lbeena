class RegisterModel {
  RegisterModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory RegisterModel.fromJson(Map<String, dynamic> json){
    return RegisterModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  final String? accessToken;
  final String? tokenType;
  final User? user;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

}

class User {
  User({
    required this.mobile,
    required this.userName,
    required this.accountType,
    required this.isAcceptTerms,
    required this.isShownEmail,
    required this.isShownMobile,
    required this.isActive,
    required this.roleId,
    required this.actionId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  final String? mobile;
  final String? userName;
  final String? accountType;
  final int? isAcceptTerms;
  final int? isShownEmail;
  final int? isShownMobile;
  final int? isActive;
  final int? roleId;
  final int? actionId;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      mobile: json["mobile"]?.toString(),
      userName: json["user_name"]?.toString(),
      accountType: json["account_type"]?.toString(),
      isAcceptTerms: json["is_accept_terms"],
      isShownEmail: json["is_shown_email"],
      isShownMobile: json["is_shown_mobile"],
      isActive: json["is_active"],
      roleId: json["role_id"],
      actionId: json["action_id"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      id: json["id"],
    );
  }

}
