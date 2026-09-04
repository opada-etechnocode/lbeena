class FortuneWheelCustomerModel {
  FortuneWheelCustomerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<FortuneWheelCustomerList> data;

  factory FortuneWheelCustomerModel.fromJson(Map<String, dynamic> json){
    return FortuneWheelCustomerModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<FortuneWheelCustomerList>.from(json["data"]!.map((x) => FortuneWheelCustomerList.fromJson(x))),
    );
  }

}

class FortuneWheelCustomerList {
  FortuneWheelCustomerList({
    required this.id,
    required this.userName,
    required this.mobile,
    required this.profilePic,
    required this.accountType,
    required this.companyName,
    required this.orderIds,
    required this.orderDates,
  });

  final int? id;
  final dynamic userName;
  final String? mobile;
  final String? profilePic;
  final String? accountType;
  final String? companyName;
  final String? orderIds;
  final String? orderDates;

  factory FortuneWheelCustomerList.fromJson(Map<String, dynamic> json){
    return FortuneWheelCustomerList(
      id: json["id"],
      userName: json["user_name"],
      mobile: json["mobile"],
      profilePic: json["profile_pic"],
      accountType: json["account_type"],
      companyName: json["company_name"],
      orderIds: json["order_ids"],
      orderDates: json["order_dates"],
    );
  }

}
