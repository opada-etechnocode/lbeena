class CheckMobileExistsModel {
  CheckMobileExistsModel({
    required this.status,
    required this.message,
  });

  final bool? status;
  final String? message;

  factory CheckMobileExistsModel.fromJson(Map<String, dynamic> json){
    return CheckMobileExistsModel(
      status: json["status"],
      message: json["message"],
    );
  }

}
