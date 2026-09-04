class IsFollowingModel {
  IsFollowingModel({
    required this.status,
    required this.message,
    required this.isFollowing,
  });

  final bool? status;
  final String? message;
  final int? isFollowing;

  factory IsFollowingModel.fromJson(Map<String, dynamic> json){
    return IsFollowingModel(
      status: json["status"],
      message: json["message"],
      isFollowing: json["is_following"],
    );
  }

}
