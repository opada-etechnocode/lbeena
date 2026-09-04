class NotificationsModel {
  NotificationsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final List<Datum> data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json){
    return NotificationsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.adId,
    required this.type,
    required this.title,
    required this.message,
    required this.body,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.isBanner,
    required this.idBanner,
    required this.inOut,
    required this.typeNotification,
    required this.categoryId,
    required this.postId,
    required this.reminder_id,
    required this.reminder_others,
    required this.following_id,
  });

  final int? id;
  final int? reminder_others;
  final int? following_id;
  final String? userId;
  final String? adId;
  final String? type;
  final String? title;
  final String? message;
  final String? body;
  final String? read;
  final String? isBanner;
  final String? idBanner;
  final String? inOut;
  final String? categoryId;
  final String? typeNotification;
  final String? postId;
  final String? reminder_id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      following_id: json["following_id"],
      userId: json["user_id"]?.toString(),
        reminder_others: json["reminder_others"],
      reminder_id: json["reminder_id"]?.toString(),
      adId: json["ad_id"]?.toString(),
      type: json["type"]?.toString(),
      title: json["title"]?.toString(),
      message: json["message"]?.toString(),
      body: json["body"]?.toString(),
      read: json["read"]?.toString(),
      categoryId: json["category_id"]?.toString(),
      inOut: json["in_out"]?.toString(),
      idBanner: json["banner_id"]?.toString(),
      isBanner: json["isBanner"]?.toString(),
      typeNotification: json["type_notification"]?.toString(),
      postId: json["post_id"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ""),
    );
  }

}
