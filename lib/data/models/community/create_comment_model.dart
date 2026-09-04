import 'package:syrians_in_uae/data/models/community/community_post_model.dart';

import 'comments__id_posts_model.dart';

class CreateCommentModel {
  CreateCommentModel({
    required this.message,
    required this.status,
    required this.comment,
  });

  final String? message;
  final bool? status;
  final CommentsListModel? comment;

  factory CreateCommentModel.fromJson(Map<String, dynamic> json){
    return CreateCommentModel(
      message: json["message"],
      status: json["status"],
      comment: json["comment"] == null ? null : CommentsListModel.fromJson(json["comment"]),
    );
  }

}
