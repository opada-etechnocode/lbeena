class StatusUserResult {
  StatusUserResult({
    required this.statusUser,
    required this.token,
    required this.accountType,
    required this.company_name,
    required this.user_name,
    required this.membershipNumber,
    required this.message,
    required this.is_ugc,
  });

  final String? statusUser;
  final String? token;
  final String? accountType;
  final String? company_name;
  final String? user_name;
  final String? message;
  final String? membershipNumber;
  final bool? is_ugc;

  factory StatusUserResult.fromJson(Map<String, dynamic> json){
    return StatusUserResult(
      statusUser: json["status"],
      membershipNumber: json["membership_number"]?.toString(),
      accountType: json["account_type"],
      message: json["message"],
      company_name: json["company_name"],
      user_name: json["user_name"],
      is_ugc: json["is_ugc"],
      token: json["token"],
    );
  }

}
