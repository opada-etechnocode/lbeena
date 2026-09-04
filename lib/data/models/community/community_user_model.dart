import '../home_page/ads_evaluation_model.dart';
import 'community_post_model.dart';

class CommunityPostUserModel {
  CommunityPostUserModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
final List<CommunityModelDatum>? data;

  factory CommunityPostUserModel.fromJson(Map<String, dynamic> json){
    return CommunityPostUserModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<CommunityModelDatum>.from(json["data"]!.map((x) => CommunityModelDatum.fromJson(x))),
    );
  }

}

class Comment {
  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePic,
    required this.likesCount,
    required this.isLikeComment,
    required this.isHaveComment,
    required this.name,
  });

  final String? id;
  final String? postId;
  final String? userId;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? profilePic;
  final String? isHaveComment;
  final int? likesCount;
  final bool? isLikeComment;
  final String? name;

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      id: json["id"]?.toString(),
      isHaveComment: json["is_have_comment"]?.toString(),
      postId: json["post_id"]?.toString(),
      userId: json["user_id"]?.toString(),
      content: json["content"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ""),
      profilePic: json["profile_pic"]?.toString(),
      likesCount: json["likes_count"],
      isLikeComment: json["is_like_comment"],
      name: json["name"]?.toString(),
    );
  }

}
