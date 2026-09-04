class PaymentPackageModel {
  PaymentPackageModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory PaymentPackageModel.fromJson(Map<String, dynamic> json){
    return PaymentPackageModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.packageCompany,
  });

  final PackageCompany? packageCompany;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      packageCompany: json["PackageCompany"] == null ? null : PackageCompany.fromJson(json["PackageCompany"]),
    );
  }

}

class PackageCompany {
  PackageCompany({
    required this.userId,
    required this.packageId,
    required this.startAt,
    required this.endAt,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  final String? userId;
  final String? packageId;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  factory PackageCompany.fromJson(Map<String, dynamic> json){
    return PackageCompany(
      userId: json["user_id"]?.toString(),
      packageId: json["package_id"]?.toString(),
      startAt: DateTime.tryParse(json["start_at"]?.toString() ?? ""),
      endAt: DateTime.tryParse(json["end_at"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ""),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      id: json["id"],
    );
  }

}
