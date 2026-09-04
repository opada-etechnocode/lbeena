class AddAdModel {
  AddAdModel({
    required this.message,
    required this.status,
    required this.ads,
  });

  final String? message;
  final String? status;
  final Ads? ads;

  factory AddAdModel.fromJson(Map<String, dynamic> json){
    return AddAdModel(
      message: json["message"],
      status: json["status"],
      ads: json["ads"] == null ? null : Ads.fromJson(json["ads"]),
    );
  }

}

class Ads {
  Ads({
    required this.adId,
    required this.description,
    required this.price,
    required this.sortOrder,
    required this.isActiveChat,
    required this.image,
    required this.userId,
  });

  final int? adId;
  final String? description;
  final String? price;
  final int? sortOrder;
  final int? isActiveChat;
  final dynamic image;
  final int? userId;

  factory Ads.fromJson(Map<String, dynamic> json){
    return Ads(
      adId: json["ad_id"],
      description: json["description"],
      price: json["price"],
      sortOrder: json["sort_order"],
      isActiveChat: json["is_active_chat"],
      image: json["image"],
      userId: json["user_id"],
    );
  }

}
