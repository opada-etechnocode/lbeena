class UgcUsersModel {
  UgcUsersModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<UgcUsersData> data;

  factory UgcUsersModel.fromJson(Map<String, dynamic> json){
    return UgcUsersModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null ? [] : List<UgcUsersData>.from(json["data"]!.map((x) => UgcUsersData.fromJson(x))),
    );
  }

}

class UgcUsersData {
  UgcUsersData({
    required this.id,
    required this.userName,
    required this.profilePic,
    required this.mobile,
    required this.accountType,
    required this.status,
    required this.cityId,
    required this.cityName,
    required this.categoryUgcId,
    required this.categoryName,
    required this.gender,
    required this.links,
    required this.createdAt,
    required this.adsCount,
    required this.rating,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.userId,
    required this.note,
    required this.membershipNumber,
    required this.hasMoreThan3000,
  });

  final int? id;
  final int? userId;
  final String? userName;
  final String? profilePic;
  final String? mobile;
  final String? accountType;
  final String? membershipNumber;
  final int? status;
  final int? cityId;
  final String? cityName;
  final int? categoryUgcId;
  final String? categoryName;
  final String? gender;
  final String? followersCount;
  final String? followingCount;
  final String? postsCount;
  final String? adsCount;
  final String? rating;
  final String? note;
  final int? hasMoreThan3000;
  final DateTime? createdAt;
  final List<String> links;

  factory UgcUsersData.fromJson(Map<String, dynamic> json){
    return UgcUsersData(
      id: json["id"],
      userId: json["user_id"],
      hasMoreThan3000: json["has_more_than_3000"],
      membershipNumber: json["membership_number"]?.toString(),
      note: json["note"],
      userName: json["user_name"],
      profilePic: json["profile_pic"],
      mobile: json["mobile"],
      accountType: json["account_type"],
      status: json["status"],
      cityId: json["city_id"],
      cityName: json["city_name"],
      categoryUgcId: json["category_ugc_id"],
      categoryName: json["category_name"],
      rating: json["rating"],
      adsCount: json["ads_count"]?.toString(),
      postsCount: json["posts_count"]?.toString(),
      followingCount: json["following_count"]?.toString(),
      followersCount: json["followers_count"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      gender: json["gender"],
      links: json["links"] == null ? [] : List<String>.from(json["links"]!.map((x) => x)),
    );
  }

}
