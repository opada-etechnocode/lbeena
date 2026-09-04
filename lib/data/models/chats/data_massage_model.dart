import 'package:cloud_firestore/cloud_firestore.dart';

class DataMassageModel {
  String? text;
  String? receiverId;
  String? senderId;
  String? senderName;
  String? senderImage;
  DateTime? dateTime;
   // DateTime? sentAt;
   String? read;
   String? type;
   String? sent;
  String? totalDurationRecord;
  /*
    dataMassage
    {
          'text': 'Hello',
          'senderId': '1234',
          'receiverId': '4321',
          'dateTime': '2023/11/7'
        }
     */

  DataMassageModel({
    required this.text,
     this.receiverId,
     this.senderName,
     this.senderImage,
    required this.senderId,
     this.dateTime,
     // this.sentAt,
     this.read,
    required this.type,
     this.sent,
     this.totalDurationRecord,
  });

  DataMassageModel.forJson(Map<String, dynamic> json) {
    text = json['text']as String;
    senderName = json['senderName'];
    senderImage = json['senderImage'];
    receiverId = json['receiverId'];
    senderId = json['senderId']as String;
    dateTime= (json['dateTime'] as Timestamp).toDate();
    // sentAt= (json['sentAt'] as Timestamp).toDate();
    // type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    type = json['type'].toString() ;
    read = json['read'].toString();
    sent = json['sent'].toString();
    totalDurationRecord = json['totalDurationRecord'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderImage': senderImage,
      // 'sentAt': sentAt,
      'senderName': senderName,
      'receiverId': receiverId,
      'totalDurationRecord': totalDurationRecord,
      'senderId': senderId,
      'dateTime': dateTime,
      'read': read,
      'sent': sent,
      'type': type,
    };
  }
}


class DataNotificationsModel {
  String? adId;
  String? receiverId;
  String? senderId;
  // String? dateTime;

  /*
    dataMassage
    {
          'text': 'Hello',
          'senderId': '1234',
          'receiverId': '4321',
          'dateTime': '2023/11/7'
        }
     */

  DataNotificationsModel({
    required this.receiverId,
    required this.senderId,
    // required this.dateTime,
    required this.adId,
  });

  DataNotificationsModel.forJson(Map<String, dynamic> json) {
    adId = json['ad_id']as String;
    receiverId = json['user_id_2']as String;
    senderId = json['user_id']as String;
    // dateTime = json['dateTime'] as String;
    // dateTime = json['dateTime'] as String;
  }

  Map<String, dynamic> toMap() {
    return {
      'ad_id': adId,
      'user_id_2': receiverId,
      'user_id': senderId,
      // 'dateTime': dateTime,
    };
  }
}




class DataNotificationsHomePageModel {
  String? body;
  String? ad_id;
  String? banner_id;
  String? category_id;
  Timestamp? created_at;
  String? following_id;
  String? id;
  String? in_out;
  String? isBanner;
  String? message;
  String? order_id;
  String? order_type;
  String? reminder_id;
  String? reminder_others;
  String? type;
  String? user_id;
  String? comment_id;
  String? post_id;
  String? title;
  String? type_notification;
  String? is_read;

  DataNotificationsHomePageModel({
    required this.body,
    required this.comment_id,
    required this.post_id,
    required this.title,
    required this.type_notification,
    required this.is_read,
    required this.ad_id,
    required this.category_id,
    required this.id,
    required this.banner_id,
    required this.following_id,
    required this.created_at,
    required this.in_out,
    required this.isBanner,
    required this.message,
    required this.order_id,
    required this.order_type,
    required this.reminder_id,
    required this.reminder_others,
    required this.type,
    required this.user_id,
  });

  DataNotificationsHomePageModel.forJson(Map<String, dynamic> json) {
    is_read = json['read']?.toString();
    body = json['body']?.toString();
    comment_id = json['comment_id']?.toString();
    post_id = json['post_id']?.toString();
    title = json['title']?.toString();
    type_notification = json['type_notification']?.toString();
    ad_id = json['ad_id']?.toString();
    category_id = json['category_id']?.toString();
    id = json['id']?.toString();
    banner_id = json['banner_id']?.toString();
    following_id = json['following_id']?.toString();
    created_at = json['created_at'] as Timestamp?;
    in_out = json['in_out']?.toString();
    isBanner = json['isBanner']?.toString();
    message = json['message']?.toString();
    order_id = json['order_id']?.toString();
    order_type = json['order_type']?.toString();
    reminder_id = json['reminder_id']?.toString();
    reminder_others = json['reminder_others']?.toString();
    type = json['type']?.toString();
    user_id = json['user_id']?.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'read': is_read,
      'ad_id': ad_id,
      'banner_id': banner_id,
      'body': body,
      'category_id': category_id,
      'created_at': created_at,
      'following_id': following_id,
      'id': id,
      'in_out': in_out,
      'isBanner': isBanner,
      'message': message,
      'order_id': order_id,
      'order_type': order_type,
      'post_id': post_id,
      'reminder_id': reminder_id,
      'reminder_others': reminder_others,
      'title': title,
      'type': type,
      'type_notification': type_notification,
      'user_id': user_id,
    };
  }
}
enum Type { text, image }
