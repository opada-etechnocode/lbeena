import '../../../widgets/components.dart';

class CategoriesAddPostModel {
  CategoriesAddPostModel({
    required this.status,
    required this.message,
    required this.data,
    required this.colors,
  });

  final String? status;
  final String? message;
  final List<SubCategoryModel> data;
  final List<ColorNew> colors;

  factory CategoriesAddPostModel.fromJson(Map<String, dynamic> json){
    return CategoriesAddPostModel(
      status: json["status"],
      message: json["message"],colors: json["colors"] == null ? [] : List<ColorNew>.from(json["colors"]!.map((x) => ColorNew.fromJson(x))),

      data: json["data"] == null ? [] : List<SubCategoryModel>.from(json["data"]!.map((x) => SubCategoryModel.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'colors': colors.map((e) => e.toJson()).toList(),
    };
  }

}
class ColorNew {
  ColorNew({
    required this.color1,
    required this.color2,
    required this.color3,
  });

  final String? color1;
  final String? color2;
  final String? color3;

  factory ColorNew.fromJson(Map<String, dynamic> json){
    return ColorNew(
      color1: json["color1"],
      color2: json["color2"],
      color3: json["color3"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color1': color1,
      'color2': color2,
      'color3': color3,
    };
  }


}
class SubCategoryModel {
  SubCategoryModel({
    required this.id,
    required this.icon,
    required this.headImg,
    required this.status,
    required this.title,
    required this.categoryId,
    required this.count_id,
    required this.languageId,
    required this.hasSubcategory,
    required this.subcategories,
    required this.color,
    required this.have_price,
    required this.subcategory_id,
  });

  final int? id;
  final int? have_price;
  final String? icon;
  final dynamic headImg;
  final String? status;
  final String? title;
  final String? color;
  final int? categoryId;
  final int? languageId;
  final bool? hasSubcategory;
  final int? count_id;
  final int? subcategory_id;
  final List<SubCategoryModel> subcategories;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json){
    return SubCategoryModel(
      id: json["id"],
      icon: json["icon"],
      headImg: json["head_img"],
      status: json["status"]?.toString(),
      title: json["title"] ?? json["name"] ,
      have_price: json["have_price"],
      count_id: json["count_id"],
      categoryId: json["category_id"],
      languageId: json["language_id"],
      hasSubcategory: json["has_subcategory"],
      subcategory_id: json["subcategory_id"],
      color: json["color"] !=null? colorWithoutHashtag( json["color"]!.toString()):null,
      subcategories: json["subcategories"] == null ? [] : List<SubCategoryModel>.from(json["subcategories"]!.map((x) => SubCategoryModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'head_img': headImg,
      'status': status,
      'title': title,
      'have_price': have_price,
      'count_id': count_id,
      'category_id': categoryId,
      'language_id': languageId,
      'has_subcategory': hasSubcategory,
      'subcategory_id': subcategory_id,
      'color': color,
      'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }


}
