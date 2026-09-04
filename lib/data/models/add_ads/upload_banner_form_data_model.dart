import 'dart:io';

class AddBannerFromDataCompany {

  AddBannerFromDataCompany({
    required this.activeChat,
    required this.mobile,
    required this.categoryId,
    required this.image,
    required this.couponPercent,
    required this.inOut,
    required this.isHave,
    required this.idAdSpecialFeature,
    required this.price,
    required this.description,
    required this.isAddCoupon,
    required this.nameBanner,
    required this.couponDateNumber,

     this.url,
});
  int? activeChat ;
  String? categoryId ;
  File? image ;
  String? couponPercent ;
  String? type ;
  int? inOut ;
  int? isHave ;
  int? idAdSpecialFeature ;
  String? couponDateNumber ;
  String? mobile ;
  int? isAddCoupon ;
  String? nameBanner ;
  String? description ;
  String? userId ;
  String? accountType ;
  String? url ;
  String? price ;

}