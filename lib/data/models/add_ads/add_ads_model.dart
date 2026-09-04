class AddAdsModel {
  AddAdsModel({
    required this.success,
    required this.message,
    required this.additionalMessage,
    required this.data,
  });

  final bool? success;
  final String? message;
  final String? additionalMessage;
  final Data? data;

  factory AddAdsModel.fromJson(Map<String, dynamic> json){
    return AddAdsModel(
      success: json["success"],
      message: json["message"],
      additionalMessage: json["additional_message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.adsId,
    required this.categoryId,
    required this.price,
    required this.userId,
    required this.bannerId,
  });

  final int? adsId;
  final String? categoryId;
  final String? price;
  final String? userId;
  final int? bannerId;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      adsId: json["id"],
      categoryId: json["category_id"]?.toString(),
      price: json["price"]?.toString(),
      userId: json["user_id"]?.toString(),
      bannerId: json["banner_id"],
    );
  }

}
