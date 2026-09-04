class WhatsappCompanyStatusModel {
  WhatsappCompanyStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final String? data;

  factory WhatsappCompanyStatusModel.fromJson(Map<String, dynamic> json){
    return WhatsappCompanyStatusModel(
      status: json["status"]?.toString(),
      message: json["message"],
      data: json["data"]?.toString(),
    );
  }

}
