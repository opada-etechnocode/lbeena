class CategoriesAddAdsModel {
  CategoriesAddAdsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final DataCategoriesAddAds? data;

  factory CategoriesAddAdsModel.fromJson(Map<String, dynamic> json){
    return CategoriesAddAdsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataCategoriesAddAds.fromJson(json["data"]),
    );
  }

}

class DataCategoriesAddAds {
  DataCategoriesAddAds({
    required this.mainCategories,
    required this.anotherCategories,
  });

  final List<Category> mainCategories;
  final List<Category> anotherCategories;

  factory DataCategoriesAddAds.fromJson(Map<String, dynamic> json){
    return DataCategoriesAddAds(
      mainCategories: json["main_categories"] == null ? [] : List<Category>.from(json["main_categories"]!.map((x) => Category.fromJson(x))),
      anotherCategories: json["another_categories"] == null ? [] : List<Category>.from(json["another_categories"]!.map((x) => Category.fromJson(x))),
    );
  }

}

class Category {
  Category({
    required this.id,
    required this.parentId,
    required this.sortOrder,
    required this.filterShow,
    required this.sliderShow,
    required this.icon,
    required this.headImg,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.hasChild,
    required this.anotherSection,
    required this.title,
    required this.categoryId,
    required this.languageId,
  });

  final int? id;
  final String? parentId;
  final String? sortOrder;
  final String? filterShow;
  final String? sliderShow;
  final String? icon;
  final dynamic headImg;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? hasChild;
  final String? anotherSection;
  final String? title;
  final String? categoryId;
  final String? languageId;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      parentId: json["parent_id"]?.toString(),
      sortOrder: json["sort_order"]?.toString(),
      filterShow: json["filter_show"]?.toString(),
      sliderShow: json["slider_show"]?.toString(),
      icon: json["icon"]?.toString(),
      headImg: json["head_img"]?.toString(),
      status: json["status"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ""),
      deletedAt: json["deleted_at"]?.toString(),
      hasChild: json["hasChild"]?.toString(),
      anotherSection: json["another_section"]?.toString(),
      title: json["title"]?.toString(),
      categoryId: json["category_id"]?.toString(),
      languageId: json["language_id"]?.toString(),
    );
  }

}
