import 'dart:io';

class AddProductFromDataCompany {

  AddProductFromDataCompany({
   required this.activeChat,
   required this.mobile,
   required this.categoryId,
   required this.image,
   required this.couponPercent,
   required this.inOut,
   required this.isHave,
   required this.idAdSpecialFeature,
   required this.couponDateNumber,
   required this.price,
   required this.adsName,
   required this.isAddCoupon,
   required this.adsDescription,
});
  int? activeChat ;
  String? categoryId ;
  List<File>? image ;
  String? couponPercent ;
  String? couponDateNumber ;
  String? type ;
  int? inOut ;
  int? isHave ;
  int? idAdSpecialFeature ;
  String? mobile ;
  int? isAddCoupon ;
  String? adsName ;
  String? adsDescription ;
  String? userId ;
  String? accountType ;
  String? price ;

}