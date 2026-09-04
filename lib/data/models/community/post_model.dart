import 'community_post_model.dart';

class PostModel {
  PostModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<CommunityModelDatum> data;

  factory PostModel.fromJson(Map<String, dynamic> json){
    return PostModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<CommunityModelDatum>.from(json["data"]!.map((x) => CommunityModelDatum.fromJson(x))),
    );
  }

}
