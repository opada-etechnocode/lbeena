import '../add_ad_new/category_details_model.dart';

class CommentsByIdPostsModel {
  CommentsByIdPostsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final Data? data;

  factory CommentsByIdPostsModel.fromJson(Map<String, dynamic> json){
    return CommentsByIdPostsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<CommentsListModel> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<CommentsListModel>.from(json["data"]!.map((x) => CommentsListModel.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

}

class CommentsListModel {
  CommentsListModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePic,
    required this.likesCount,
    required this.isLikeComment,
    required this.name,
    required this.isHaveComment,
  });

  final String? id;
  final String? postId;
  final String? userId;
  String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? profilePic;
  int? likesCount;
  bool? isLikeComment;
  final String? name;
  final String? isHaveComment;

  factory CommentsListModel.fromJson(Map<String, dynamic> json){
    return CommentsListModel(
      id: json["id"]?.toString(),
      isHaveComment: json["is_have_comment"]?.toString(),
      postId: json["post_id"]?.toString(),
      userId: json["user_id"]?.toString(),
      content: json["content"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      profilePic: json["profile_pic"]?.toString(),
      likesCount: json["likes_count"] ??0,
      isLikeComment: json["is_like_comment"] ?? false,
      name: json["name"]?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'profile_pic': profilePic,
      'likes_count': likesCount,
      'is_like_comment': isLikeComment,
      'name': name,
      'is_have_comment': isHaveComment,
    };
  }

}
