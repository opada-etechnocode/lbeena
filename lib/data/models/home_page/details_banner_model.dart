import 'banner_product_model.dart';

class DetailsBannerModel {
  DetailsBannerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final DataProductBannerModel? data;

  factory DetailsBannerModel.fromJson(Map<String, dynamic> json){
    return DetailsBannerModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataProductBannerModel.fromJson(json["data"]),
    );
  }

}
