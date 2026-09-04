class AdsChatsModel {
  String? massage;
  String? nameOwnerAds;
  String? userNamePersonSender;
  String? nameAds;
  String? ad_id;
  String? user_id;
  String? user_id_2;
  String? imageAds;
  String? imageCompany;
  String? imageUser;
  String? dateTime;
  String? isOnLine;
  String? read;
  String? type;
  String? idAdOnwerCompany;
  bool? isBannerInOut;
  String? categoryId;
  bool? isBanner;
  int? idBannerOrProduct;
  /*
       dataAds
    {
           'nameAds':'سيارة نيسان',
           'lastText':'Hello',
           'ad_id':'1234',
           'imageAds':'as/asd/asd.png',
           'dateTime':'2023/11/7'
        }
     */

  AdsChatsModel({
    required this.massage,
    required this.imageCompany,
    required this.imageUser,
    required this.nameOwnerAds,
    required this.nameAds,
    required this.userNamePersonSender,
    required this.ad_id,
    required this.user_id,
    required this.user_id_2,
    required this.imageAds,
    required this.dateTime,
    required this.type,
    this.isOnLine,
    required this.read,
    required this.isBannerInOut,
    required this.categoryId,
    required this.isBanner,
    required this.idBannerOrProduct,
    required this.idAdOnwerCompany,
  });

  AdsChatsModel.forJson(Map<String, dynamic> json) {
    massage = json['massage']as String;
    isBannerInOut = json['isBannerInOut']as bool;
    categoryId = json['categoryId']as String;
    idAdOnwerCompany = json['idAdOnwerCompany']as String;
    isBanner = json['isBanner']as bool;
    idBannerOrProduct = json['idBannerOrProduct']as int;
    type = json['type']as String;
    imageCompany = json['imageCompany']as String;
    imageUser = json['imageUser']as String;
    nameOwnerAds = json['nameOwnerAds']as String;
    user_id = json['user_id']as String;
    user_id_2 = json['user_id_2']as String;
    nameAds = json['nameAds'] as String;
    userNamePersonSender = json['userNamePersonSender'] as String;
    ad_id = json['ad_id'] as String;
    imageAds = json['imageAds'] as String;
    dateTime = json['dateTime'] as String;
    isOnLine = json['isOnLine'] ??json['isOnLine'].toString();
    read = json['read'] as String;
  }

  Map<String, dynamic> toMap() {
    return {
      'massage': massage,
      'isBannerInOut': isBannerInOut,
      'idAdOnwerCompany': idAdOnwerCompany,
      'categoryId': categoryId,
      'isBanner': isBanner,
      'idBannerOrProduct': idBannerOrProduct,
      'type': type,
      'nameAds': nameAds,
      'imageCompany': imageCompany,
      'imageUser': imageUser,
      'nameOwnerAds': nameOwnerAds,
      'user_id': user_id,
      'user_id_2': user_id_2,
      'ad_id': ad_id,
      'imageAds': imageAds,
      'userNamePersonSender': userNamePersonSender,
      'dateTime': dateTime,
      'isOnLine': isOnLine,
      'read': read,
    };
  }
}
