import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/data/models/profile_company/package_company_model.dart';
import 'package:syrians_in_uae/ui/screens/payment/payment_page.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/add_ads/add_ads_model.dart';
import '../../../widgets/components.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';

class AllPackageCompanyPage extends StatefulWidget {
  AllPackageCompanyPage({super.key,
  this.isFromAddAds =false,
  this.priceAdsAndBanner,
    this.idSelectedAdsSpecialFeatures,
    this.priceAdsSpecialFeatures,this.adsModel,this.isSpecial =false ,this.idPackage,this.isAddAds = false


  });
bool isFromAddAds =false;

  bool isAddAds = false;

  bool isSpecial = false;
  AddAdsModel? adsModel;
  int? idPackage;
  int? idSelectedAdsSpecialFeatures;
  String? priceAdsAndBanner;
  String? priceAdsSpecialFeatures;
  @override
  State<AllPackageCompanyPage> createState() => _PackageCompanyPageState();
}

List<PackageCompany> packagePaid = [];
class _PackageCompanyPageState extends State<AllPackageCompanyPage> {
  PackageCompanyModel? packageCompanyModel;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text:   'الباقات', context: context,isShowBack: true),

        body: BlocProvider(
          create: (context) => ProfileCubit()..getAllPackageCompany(),
          child: BlocConsumer<ProfileCubit, ProfileStates>(
            listener: (context, state) {
              if (state is SuccessPackageCompanyState) {
                packageCompanyModel = state.packageCompanyModel;
                packagePaid = [];
                for(int i =0; i< packageCompanyModel!.data!.packagecompany.length;i++)
                {
                  if(packageCompanyModel!.data!.packagecompany[i].statusPayment == 'paid') {
                    packagePaid.add(packageCompanyModel!.data!.packagecompany[i]);
                  }
                }
                print(packagePaid.length);
                print(packageCompanyModel!.data!.packagecompany.length);
                print(packagePaid.length);

              }
            },
            builder: (context, state) {
              return   SmartRefreshWidget(
                onRefresh: () async {
                   ProfileCubit.get(context).getAllPackageCompany();
                  _refreshController.refreshCompleted();
                },
                onLoading: () async {
                  _refreshController.loadComplete();
                },
                controller: _refreshController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    child: Column(
                      children: [

                          state is LoadingPackageCompanyState
                              ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:  EdgeInsets.symmetric(
                                      vertical: 8.h
                                  ),
                                  child: BannerItemShimmer(),
                                );
                              })
                              : packageCompanyModel ==null ?Container():packageCompanyModel!
                              .data!.packagecompany.length ==packagePaid.length? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  sizeHeightNormal(
                                    height: 300.h
                                  ),
                                  textNormal(text: 'لايوجد باقات متاحة للإشتراك ..'),
                                ],
                              ):ListView.builder(
                              shrinkWrap: true,
                              itemCount: packageCompanyModel!
                                  .data!.packagecompany.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _buildPackageItem(
                                    context,
                                    packageCompanyModel!
                                        .data!.packagecompany[index]);
                              }),



                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
          ),
    );
  }

  /// Section Widget
  Widget _buildPackageItem(
      BuildContext context, PackageCompany packageCompanyModel) {
    String colorPackage = packageCompanyModel.colorPackage!.substring(1);
    colorPackage = '0xFF$colorPackage';
    // تحديد تنسيق التاريخ
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime startDate = dateFormat.parse(packageCompanyModel.startAt!);
    DateTime endPackageDate = startDate.add(Duration(days: int.parse(packageCompanyModel.packagePeriod!)));
    String endAtCompanyPackage = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(endPackageDate.toString()));

    double price = double.parse(packageCompanyModel.price!);
    print(colorPackage);
    return packageCompanyModel.statusPayment == 'paid'?Container(): Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Stack(
        children: [
          Container(
            // width: 361.h,
            height: 160.h,
            decoration: AppDecoration.gradientPackage.copyWith(
              // color: Color(int.parse(colorPackage)),
                color: Color(int.parse(colorPackage)),
                border: Border.all(color: Color(int.parse(colorPackage))),
                gradient: LinearGradient(
                  begin: Alignment(0.90, 0.77),
                  end: Alignment(0.18, 0.83),
                  colors: [
                    appTheme.whiteA700,
                    Color(int.parse(colorPackage)),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(int.parse(colorPackage)),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 0))
                ],
                borderRadius: BorderRadius.circular(50.r)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 26.w),
                  child: RotatedBox(
                    quarterTurns: 3, // تدوير النص بزاوية 270 درجة (أي 90 درجة عكس عقارب الساعة)
                    child: textNormal(
                      text: packageCompanyModel.title.toString(),
                      color: appTheme.black900,
                      fontSize: AppFontSize.fontSize_24,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              left: 35.w,
              top: 10.h,
              child: Row(
                children: [
                  textNormal(
                      text: price.toString(),
                      color: Colors.white,
                      fontSize: AppFontSize.fontSize_20),
                  sizeWidthNormal(width: 5.h),
                  textNormal(
                      text: 'درهم / ${packageCompanyModel.adsPeriod} يوم'
                          .toString(),
                      color: Colors.white,
                      fontSize: AppFontSize.fontSize_20),
                ],
              )),
          Positioned(
              left: 180.w,
              top: 100.h,
              child: Row(
                children: [
                  textNormal(
                      text: 'عدد الإعلانات : '.toString(),
                      color: Colors.white),
                  textNormal(
                      text: packageCompanyModel.adsQty.toString(),
                      color: Colors.white),
                ],
              )),
          Positioned(
              left: 100.w,
              top: 120.h,
              child: Row(
                children: [
                  textNormal(
                      text: 'مدة انتهاء الباقة '.toString(),
                      color: Colors.white),
                  textNormal(
                      text: endAtCompanyPackage.toString(),
                      color: Colors.white),
                ],
              )),
          Positioned(
              left: 20.w,
              top: 90.h,
              child: Row(
                children: [
                  packageCompanyModel.statusPayment == 'paid'?Padding(
                    padding:  EdgeInsets.only(left: 30.w,right: 30.w,top: 30.h,bottom: 10.h),
                    child: textNormal(text: ' تم الشراء', color: Colors.white),
                  ): InkWell(
                      onTap: (){
                        if(widget.isFromAddAds){
                          navigatorToPushReplacement(context: context, pageName: PaymentPage(
                            isFromPackage: true,
                            idPackage:packageCompanyModel.id,
isAddAds: true,
                            isSpecial: widget.isSpecial,
                            adsModel: widget.adsModel,
                            idSelectedAdsSpecialFeatures: widget.idSelectedAdsSpecialFeatures,
                            priceAdsSpecialFeatures: widget.priceAdsSpecialFeatures,
                            priceAdsAndBanner: widget.priceAdsAndBanner,
                          ));
                        }else {
                          navigatorToPush(context: context, pageName: PaymentPage(
                            isFromPackage: true,
                            idPackage:packageCompanyModel.id,

                          ));
                        }

                      },
                      child:  Stack(
                        alignment: Alignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor:appTheme.borderImageColor,
                            highlightColor: appTheme.baseColorShimmer.withOpacity(.5),
loop: 3,
                            period: Duration(milliseconds: 1500),
                            child: Padding(
                              padding:  EdgeInsets.only(left: 10.w,right: 10.w,top: 30.h,bottom: 10.h),
                              child: Container(
                                  height: 30.h,
                                  width: 60.w,
                                 decoration: AppDecoration.outlineContainer,
                                  child: Center(child: textNormal(text: 'شراء', color: Colors.white))),
                            ),
                          ),
                          Positioned(
                            bottom: 10.h,
                            child: Container(
                                height: 30.h,
                                width: 60.w,
                                child: Center(child: textNormal(text: 'شراء', color: Colors.white))),
                          ),
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }

}

