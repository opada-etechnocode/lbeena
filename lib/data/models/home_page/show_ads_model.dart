class ShowAdsModel {
  ShowAdsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final dynamic status;
  final String? message;
  final String? data;

  factory ShowAdsModel.fromJson(Map<String, dynamic> json){
    return ShowAdsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"]?.toString(),
    );
  }

}
