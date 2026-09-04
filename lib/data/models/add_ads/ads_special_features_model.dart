class AdsSpecialFeaturesModel {
  AdsSpecialFeaturesModel({
    required this.success,
     this.data,
    required this.message,
  });

  final String? success;
  final List<DatumAdsSpecialFeatures>? data;
  final String? message;

  factory AdsSpecialFeaturesModel.fromJson(Map<String, dynamic> json){
    return AdsSpecialFeaturesModel(
      success: json["success"],
      data: json["data"] == null ? [] : List<DatumAdsSpecialFeatures>.from(json["data"]!.map((x) => DatumAdsSpecialFeatures.fromJson(x))),
      message: json["message"],
    );
  }

}

class DatumAdsSpecialFeatures {
  DatumAdsSpecialFeatures({
    required this.featureName,
    required this.id,
    required this.languageId,
    required this.price,
  });

  final String? featureName;
  final String? id;
  final String? languageId;
  final String? price;

  factory DatumAdsSpecialFeatures.fromJson(Map<String, dynamic> json){
    return DatumAdsSpecialFeatures(
      featureName: json["feature_name"]?.toString(),
      id: json["id"]?.toString(),
      languageId: json["language_id"]?.toString(),
      price: json["price"]?.toString(),
    );
  }

}
