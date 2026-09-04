class PriceAdsModel {
  PriceAdsModel({
    required this.success,
    required this.message,
    required this.adsPrice,
    required this.bannerPrice,
  });

  final String? success;
  final String? message;
  final String? adsPrice;
  final String? bannerPrice;

  factory PriceAdsModel.fromJson(Map<String, dynamic> json){
    return PriceAdsModel(
      success: json["success"],
      message: json["message"],
      adsPrice: json["ads_price"]?.toString(),
      bannerPrice: json["banner_price"]?.toString(),
    );
  }

}
