import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/favorite/cubit/favorite_page_cubit.dart';
import 'package:syrians_in_uae/widgets/ads_product_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/home_page/banner_product_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../../widgets/ads_product_widget.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/top_curved_item.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../details_product/details_product.dart';
import '../home/cubit/cubit.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  bool isLoadingFavorite = true;
  List<DataProductBannerModel> favoriteAdsData = [];
  List<DataProductBannerModel> favoriteBannerData = [];

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text:  'المفضلة',isShowBack: true,context: context),
        body: BlocProvider(
          create: (context) => FavoritePageCubit()..getFavoriteAds(),
          child: BlocConsumer<FavoritePageCubit, FavoritePageState>(
            listener: (context, state) {
              if (state is LoadingGetFavoriteAdsState) {
                isLoadingFavorite = true;
              }
              if (state is ErrorGetFavoriteAdsState) {
                isLoadingFavorite = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
              if (state is SuccessGetFavoriteAdsState) {
                isLoadingFavorite = false;
                favoriteAdsData =[];
                favoriteBannerData =[];
                for (int i = 0; i < state.homePageModel.relatedAds!.length; i++) {
                  if(state.homePageModel.relatedAds![i].type == 'A')
                  {
                    favoriteBannerData.add( state.homePageModel.relatedAds![i]);

                  } else if (state.homePageModel.relatedAds![i].type == 'B')
                  {
                    favoriteAdsData.add( state.homePageModel.relatedAds![i]);

                  }
                }
              }
            },
            builder: (context, state) {
              return RefreshIndicator(
                  color: appTheme.greenColor,
                  backgroundColor: appTheme.lightBlue100,
                  onRefresh: () {
                    return FavoritePageCubit.getDate(context).getFavoriteAds();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: isLoadingFavorite
                        ? SingleChildScrollView(
                            child: AdsProductShimmer(
                            isNotNeedName: true,
                          ))
                        : favoriteAdsData?.length == 0 &&
                                favoriteBannerData?.length == 0
                            ? Center(
                                child: textNormal(
                                    text: 'لا يوجد اعلانات مفضلة',
                                    fontSize: AppFontSize.fontSize_16,
                                    fontWeight: FontWeight.bold),
                              )
                            : SingleChildScrollView(
                              child: Column(
                                children: [
                                  sizeHeightNormal(),
                                  favoriteBannerData.length ==0?Container():  Container(
                                    height: 180.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: favoriteBannerData.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context,index){
                                      return  buildBannerItem(context, favoriteBannerData[index]);
                                    }),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),

                                      // physics:const NeverScrollableScrollPhysics(),
                                      itemCount: favoriteAdsData?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        // print(homePageModel!.data!.adsProduct!.data.length);
                                        return GestureDetector(
                                            onTap: () {
                                              navigatorToPush(
                                                  context: context,
                                                  pageName: DetailsProduct(
                                                    idBannerOrProduct: int.parse(
                                                        favoriteAdsData![index].adsId!),
                                                    categoryId: favoriteAdsData![index]
                                                        .categoryId
                                                        .toString(),
                                                    detailsProduct:
                                                        favoriteAdsData![index],
                                                    adsName:
                                                        favoriteAdsData![index].name,
                                                    idAds: favoriteAdsData![index]
                                                        .adsId
                                                        .toString(),

                                                    idAdOnwerCompany: int.parse(
                                                        favoriteAdsData![index]
                                                            .userId!),
                                                    // detailsProduct: ,
                                                    // idProduct: int.parse(data.data[index].adsId!),
                                                  ));
                                            },
                                            child: AdsProductWidget(
                                              dataProductItem: favoriteAdsData![index],
                                            ));
                                      },
                                    ),
                                ],
                              ),
                            ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
/// Section Widget
Widget buildBannerItem(BuildContext context, DataProductBannerModel dataBanner) {
  // print(AppEndpoints.baseImageUrl + dataBanner.image.toString());
  // print(dataBanner.url.toString());
  return Column(
    children: [
      Padding(
        padding:  EdgeInsets.symmetric(horizontal: 3.w),
        child: GestureDetector(
          onTap: () {

              navigatorToPush(
                  context: context,
                  pageName: DetailsProduct(
                    detailsProductFromBanner: dataBanner,
                    isBanner: true,
                    adsName: dataBanner.name,
                    categoryId: dataBanner.categoryId.toString(),
                    idAds: dataBanner.adsId.toString(),
                    idBannerOrProduct: int.parse(dataBanner.bannerId!),
                    idAdOnwerCompany: int.parse(dataBanner.userId!),
                  ));

          },
          child: Container(
            width: 320.w,
            height: 150.h,
            // margin: EdgeInsets.only(left: 2.h, right: 2.h),
            // padding: EdgeInsets.symmetric(
            //   horizontal: 15.h,
            //   vertical: 1.v,
            // ),
            decoration: AppDecoration.fillWhiteA.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder40,
                color: appTheme.lightBlue100,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.lightBlue100,
                    spreadRadius: 3,
                    blurRadius: 9,
                    offset: Offset(
                      0,
                      0,
                    ),
                  ),
                ]),
            child: CustomImageView(
              imagePath:dataBanner.image.toString().contains('http')? dataBanner.image.toString():
              AppEndpoints.baseUrlWithoutApi + dataBanner.image.toString(),
              width: 350.w,
              height: 155.h,
              alignment: Alignment.center,
              radius: BorderRadius.circular(
                35.r,
              ),
              fit: BoxFit.fill,
              placeHolder: ImageConstant.imgLogoApp,
            ),
          ),
        ),
      ),
      // sizeHeightNormal(height: 15.h),
    ],
  );
}
