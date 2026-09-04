class UgcCategoryModel {
  UgcCategoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<UgcCategoryData> data;

  factory UgcCategoryModel.fromJson(Map<String, dynamic> json){
    return UgcCategoryModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<UgcCategoryData>.from(json["data"]!.map((x) => UgcCategoryData.fromJson(x))),
    );
  }

}

class UgcCategoryData {
  UgcCategoryData({
    required this.id,
    required this.status,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? status;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UgcCategoryData.fromJson(Map<String, dynamic> json){
    return UgcCategoryData(
      id: json["id"],
      status: json["status"],
      name: json["name"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
