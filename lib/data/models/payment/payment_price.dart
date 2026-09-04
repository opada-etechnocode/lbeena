class PricePaymentModel {
  PricePaymentModel({
    required this.status,
    required this.message,
    required this.ads,
  });

  final bool? status;
  final String? message;
  final AdsPricePaymnet? ads;

  factory PricePaymentModel.fromJson(Map<String, dynamic> json){
    return PricePaymentModel(
      status: json["status"],
      message: json["message"],
      ads: json["ads"] == null ? null : AdsPricePaymnet.fromJson(json["ads"]),
    );
  }

}

class AdsPricePaymnet {
  AdsPricePaymnet({
    required this.priceProduct,
    required this.priceBanner,
  });

  final String? priceProduct;
  final String? priceBanner;

  factory AdsPricePaymnet.fromJson(Map<String, dynamic> json){
    return AdsPricePaymnet(
      priceProduct: json["price_product"]?.toString(),
      priceBanner: json["price_banner"]?.toString(),
    );
  }

}