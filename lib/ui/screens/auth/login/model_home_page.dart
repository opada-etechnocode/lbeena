import '../../../../data/models/add_ad_new/category_model.dart';
import '../../../../data/models/home_page/home_page_model.dart';

class HomePageLoginModel {
  HomePageModel? homePageModel;
  CategoriesAddPostModel? categoriesMainModel;
  // HomePageModel? adsRandomModel;

  HomePageLoginModel({
    required this.homePageModel,
    required this.categoriesMainModel,
    // required this.adsRandomModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'homePageModel': homePageModel?.toJson(),
      'categoriesMainModel': categoriesMainModel?.toJson(),
      // 'adsRandomModel': adsRandomModel?.toJson(),
    };
  }

  factory HomePageLoginModel.fromJson(Map<String, dynamic> json) {
    return HomePageLoginModel(
      homePageModel: json['homePageModel'] == null
          ? null
          : HomePageModel.fromJson(json['homePageModel']),
      categoriesMainModel: json['categoriesMainModel'] == null
          ? null
          : CategoriesAddPostModel.fromJson(json['categoriesMainModel']),
      // adsRandomModel: HomePageModel.fromJson(json['adsRandomModel']),
    );
  }
}
