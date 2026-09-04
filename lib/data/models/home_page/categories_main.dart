import '../../../widgets/components.dart';

class  CategoriesMainModel {
  CategoriesMainModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final List<DataCategoriesMain> data;

  factory CategoriesMainModel.fromJson(Map<String, dynamic> json){
    return CategoriesMainModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<DataCategoriesMain>.from(json["data"]!.map((x) => DataCategoriesMain.fromJson(x))),
    );
  }

}

class DataCategoriesMain {
  DataCategoriesMain({
    required this.categoryId,
    required this.icon,
    required this.title,
     this.isHaveBanner,
     this.isHaveProduct,
     this.isHaveVideo,
     this.color,
  });

  final String? categoryId;
  final String? icon;
  final String? title;
  final String? isHaveVideo;
  final String? isHaveBanner;
  final String? isHaveProduct;
  final String? color;

  factory DataCategoriesMain.fromJson(Map<String, dynamic> json){
    return DataCategoriesMain(
      categoryId: json["category_id"]?.toString(),
      icon: json["icon"]?.toString(),
      title: json["title"]?.toString(),
      isHaveVideo: json["have_video"]?.toString(),
      isHaveProduct: json["have_product"]?.toString(),
      isHaveBanner: json["have_banner"]?.toString(),
      color: json["color"] !=null? colorWithoutHashtag( json["color"]!.toString()):null,
    );
  }

}
