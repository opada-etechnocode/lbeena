import 'package:syrians_in_uae/data/models/add_ad_new/category_model.dart';

class ActivityCompanyModel {
  ActivityCompanyModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<ActivityCompanyList> data;

  factory ActivityCompanyModel.fromJson(Map<String, dynamic> json){
    return ActivityCompanyModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<ActivityCompanyList>.from(json["data"]!.map((x) => ActivityCompanyList.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }

}

class ActivityCompanyList {
  ActivityCompanyList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.subcategories,
    required this.status,
    required this.banner_image,
  });

  final int? id;
  final String? name;
  final String? banner_image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? status;
  final List<SubCategoryModel> subcategories;
  factory ActivityCompanyList.fromJson(Map<String, dynamic> json){
    return ActivityCompanyList(
      id: json["id"],
      name: json["name"],
      banner_image: json["banner_image"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      status: json["status"],
      subcategories: json["subcategories"] == null ? [] : List<SubCategoryModel>.from(json["subcategories"]!.map((x) => SubCategoryModel.fromJson(x))),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner_image': banner_image,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
      'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }

}
