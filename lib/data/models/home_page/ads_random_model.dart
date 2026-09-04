import 'banner_product_model.dart';

class AdsRandomModel {
  AdsRandomModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory AdsRandomModel.fromJson(Map<String, dynamic> json){
    return AdsRandomModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.mergedAds,
  });

  final List<DataProductBannerModel> mergedAds;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      mergedAds: json["mergedAds"] == null ? [] : List<DataProductBannerModel>.from(json["mergedAds"]!.map((x) => DataProductBannerModel.fromJson(x))),
    );
  }

}