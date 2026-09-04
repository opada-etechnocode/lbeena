class EditAdsModel {
  EditAdsModel({
    required this.status,
    required this.message,
  });

  final String? status;
  final String? message;

  factory EditAdsModel.fromJson(Map<String, dynamic> json){
    return EditAdsModel(
      status: json["status"],
      message: json["message"],
    );
  }

}
