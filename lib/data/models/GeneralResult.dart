class GeneralResult {
  GeneralResult({
    required this.success,
    required this.message,
  });

  final String? success;
  final String? message;

  factory GeneralResult.fromJson(Map<String, dynamic> json){
    return GeneralResult(
      success: json["success"],
      message: json["message"],
    );
  }

}
