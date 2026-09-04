class   GeneralModel {
  GeneralModel({
    required this.success,
    required this.status,
    required this.message,
  });

  final bool? success;
  final bool? status;
  final String? message;
  factory GeneralModel.fromJson(Map<String, dynamic> json){
    return GeneralModel(
      success: json["success"],
      status: json["status"],
      message: json["message"],
    );
  }

  
}


class   CreatePostModel {
  CreatePostModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? success;
  final bool? status;
  final String? message;
  final DataCreatePost? data;
  factory CreatePostModel.fromJson(Map<String, dynamic> json){
    return CreatePostModel(
      success: json["success"],
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataCreatePost.fromJson(json["data"]),
    );
  }


}

class   DeletePost {
  DeletePost({
    required this.status,
    required this.message,
  });

  final int? status;
  final String? message;
  factory DeletePost.fromJson(Map<String, dynamic> json){
    return DeletePost(
      status: json["status"],
      message: json["message"],
    );
  }


}

class DataCreatePost {
  DataCreatePost({
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
    required this.contentNew,
    required this.backgroundNew,
    required this.imageNew,
    required this.videoNew,
    required this.pin,
    required this.isHaveComment,
    required this.isHaveCommentNew,
    required this.isEdit,
    required this.voice,
    required this.voiceTime,
    required this.isHaveChat,
    required this.isHaveChatNew,
    required this.isContentGroup,
  });

  final int? id;
  final int? userId;
  final String? title;
  final String? content;
  final dynamic background;
  final dynamic image;
  final dynamic video;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final String? type;
  final String? status;
  final DateTime? acceptDate;
  final dynamic contentNew;
  final dynamic backgroundNew;
  final dynamic imageNew;
  final dynamic videoNew;
  final int? pin;
  final int? isHaveComment;
  final dynamic isHaveCommentNew;
  final int? isEdit;
  final dynamic voice;
  final dynamic voiceTime;
  final int? isHaveChat;
  final dynamic isHaveChatNew;
  final int? isContentGroup;

  factory DataCreatePost.fromJson(Map<String, dynamic> json){
    return DataCreatePost(
      id: json["id"],
      userId: json["user_id"],
      title: json["title"],
      content: json["content"],
      background: json["background"],
      image: json["image"],
      video: json["video"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: json["updated_at"],
      type: json["type"],
      status: json["status"],
      acceptDate: DateTime.tryParse(json["accept_date"] ?? ""),
      contentNew: json["content_new"],
      backgroundNew: json["background_new"],
      imageNew: json["image_new"],
      videoNew: json["video_new"],
      pin: json["pin"],
      isHaveComment: json["is_have_comment"],
      isHaveCommentNew: json["is_have_comment_new"],
      isEdit: json["is_edit"],
      voice: json["voice"],
      voiceTime: json["voice_time"],
      isHaveChat: json["is_have_chat"],
      isHaveChatNew: json["is_have_chat_new"],
      isContentGroup: json["is_content_group"],
    );
  }}


class   ChangeStatusCounterForWhatsappShareChatModel {
  ChangeStatusCounterForWhatsappShareChatModel({

    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? data;
  final String? message;
  factory ChangeStatusCounterForWhatsappShareChatModel.fromJson(Map<String, dynamic> json){
    return ChangeStatusCounterForWhatsappShareChatModel(
      data: json["data"]?.toString(),
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
    );
  }


}
