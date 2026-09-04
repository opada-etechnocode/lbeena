import 'comments__id_posts_model.dart';
import 'hashtag_model.dart';

class CommunityPostModel {
  CommunityPostModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final CommunityAllPost? data;

  factory CommunityPostModel.fromJson(Map<String, dynamic> json){
    return CommunityPostModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : CommunityAllPost.fromJson(json["data"]),
    );
  }

}

class CommunityAllPost {
  CommunityAllPost({
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
  final List<CommunityModelDatum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory CommunityAllPost.fromJson(Map<String, dynamic> json){
    return CommunityAllPost(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<CommunityModelDatum>.from(json["data"]!.map((x) => CommunityModelDatum.fromJson(x))),
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
  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((x) => x.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((x) => x.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

}

class CommunityModelDatum {
  CommunityModelDatum({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.background,
    required this.image,
    required this.video,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.status,
    required this.acceptDate,
    required this.profilePic,
    required this.comments,
    required this.name,
    required this.likesCount,
    required this.isLikePost,
    required this.hashtags,
    required this.pin,
    required this.hashtagData,
    required this.isHaveComment,
    required this.hashtagsWithId,
    required this.is_content_group,
    required this.color,
    required this.voice_time,
    required this.is_have_chat,
    required this.voice,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? content;
  final String? background;
  final String? voice;
  final String? voice_time;
  String? image;
  final String? video;
  final dynamic createdAt;
  final dynamic updatedAt;
  final String? type;
  final String? status;
  final DateTime? acceptDate;
  final dynamic profilePic;
  final List<CommentsListModel> comments;
  final String? name;
   String? isHaveComment;
   String? pin;
   int? likesCount;
   int? is_have_chat;
   int? is_content_group;
   bool? isLikePost;
  final List<dynamic> hashtags;
  final List<Hashtag> hashtagsWithId;
  final List<Hashtag> hashtagData;
  final List<ColorsBackground> color;

  factory CommunityModelDatum.fromJson(Map<String, dynamic> json){
    return CommunityModelDatum(
      id: json["id"]?.toString(),
      voice: json["voice"]?.toString(),
      voice_time: json["voice_time"]?.toString(),
      isHaveComment: json["is_have_comment"]?.toString(),
      userId: json["user_id"]?.toString(),
      title: json["title"]?.toString(),
      content: json["content"]?.toString(),
      background: json["background"]?.toString(),
      image: json["image"]?.toString(),
      pin: json["pin"]?.toString(),
      video: json["video"]?.toString(),
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
      type: json["type"]?.toString(),
      status: json["status"]?.toString(),
      acceptDate: DateTime.tryParse(json["accept_date"] ?? ""),
      profilePic: json["profile_pic"]?.toString(),
      comments: json["comments"] == null ? [] : List<CommentsListModel>.from(json["comments"]!.map((x) => CommentsListModel.fromJson(x))),
      name: json["name"]?.toString(),
      likesCount: json["likes_count"],
      is_have_chat: json["is_have_chat"],
      isLikePost: json["is_like_post"],
      is_content_group: json["is_content_group"],
      hashtagsWithId: json["hashtags"] == null ? [] : List<Hashtag>.from(json["hashtags"].map((x) => Hashtag.fromJson(x))),
      hashtags: json["hashtags_old"] == null ? [] : List<dynamic>.from(json["hashtags_old"]!.map((x) => x)),
      hashtagData: json["hashtagData"] == null ? [] : List<Hashtag>.from(json["hashtagData"]!.map((x) => Hashtag.fromJson(x))),
      color: json["color"] == null ? [] : List<ColorsBackground>.from(json["color"]!.map((x) => ColorsBackground.fromJson(x))),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'background': background,
      'image': image,
      'voice': voice,
      'voice_time': voice_time,
      'video': video,
      'created_at': createdAt?.toString(),
      'updated_at': updatedAt?.toString(),
      'type': type,
      'status': status,
      'accept_date': acceptDate?.toIso8601String(),
      'profile_pic': profilePic,
      'comments': comments.map((x) => x.toJson()).toList(),
      'name': name,
      'is_have_comment': isHaveComment,
      'pin': pin,
      'likes_count': likesCount,
      'is_like_post': isLikePost,
      'hashtags':  hashtagsWithId.map((x) => x.toJson()).toList(),
      'hashtags_old': hashtags,
      'hashtagData': hashtagData.map((x) => x.toJson()).toList(),
      'color': color.map((x) => x.toJson()).toList(),
      'is_have_chat': is_have_chat,
      'is_content_group': is_content_group,
    };
  }

}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"]?.toString(),
      label: json["label"]?.toString(),
      active: json["active"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }

}
