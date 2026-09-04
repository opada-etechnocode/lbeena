class EditMobileNumberModel {
  EditMobileNumberModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final String? success;
  final String? message;
  final String? data;

  factory EditMobileNumberModel.fromJson(Map<String, dynamic> json){
    return EditMobileNumberModel(
      success: json["success"],
      message: json["message"],
      data: json["data"],
    );
  }

}
