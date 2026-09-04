import 'dart:io';
import 'dart:ui';

class ArgumentMessage {
  final String? read;
  final String? nameAds;
  final String? imageAds;
  final String? imageCompany;
  final String? imageUser;
  final String? nameOwnerAds;
  final String? user_name_person_sender;
  final String? user_id;
  final int? user_id_2;
  final int? ad_id;
  final String? ad_id_firebase;
  final bool? adsIsJob;
  final List<File>? files;
  bool? isBannerInOut;
  String? categoryId;
  bool? isBanner;
  int? idBannerOrProduct;
  String? idAdOnwerCompany;

  ArgumentMessage({
    this.read,
    this.user_id_2,
    this.ad_id,
    this.ad_id_firebase,
    this.imageCompany,
    this.imageUser,
    this.adsIsJob,
    this.idAdOnwerCompany,
    this.user_id,
    this.files,
    this.nameAds,
    this.user_name_person_sender,
    this.imageAds,
    this.nameOwnerAds,
    this.isBannerInOut,
    this.categoryId,
    this.isBanner,
    this.idBannerOrProduct,
  });
}


class ArgumentMessageGroup {
  final String? adminId;
  final String? groupName;
  final String? groupId;
  final String? createdAt;
  final Map<String, dynamic>? userGroups;


  ArgumentMessageGroup({
    this.adminId,
    this.groupId,
    this.groupName,
    this.createdAt,
    this.userGroups,
  });
}
