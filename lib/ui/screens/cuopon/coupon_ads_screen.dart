import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/coupon/coupon_user_model.dart';
import 'package:syrians_in_uae/ui/screens/cuopon/cubit/coupon_cubit.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/add_ad_new/cities_model.dart';
import '../../../data/models/home_page/banner_product_model.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/ads_product_shimmer.dart';
import '../../../widgets/ads_product_widget.dart';
import '../../../widgets/community_shimmer.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../details_product/details_product.dart';
import '../home/cubit/cubit.dart';


class CouponAdsScreen extends StatefulWidget {
  const CouponAdsScreen({super.key});

  @override
  State<CouponAdsScreen> createState() => _CouponAdsScreenState();
}

class _CouponAdsScreenState extends State<CouponAdsScreen> {
  TextEditingController searchController = TextEditingController();
  String? accountType = DIManager.findDep<SharedPrefs>().getAccountType();
  List<DataProductBannerModel> couponUserModel = [];
  String? selectedEmirate;
  int? cityId;
  String? selectedCategory;
  int? selectedId;

  int page = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    /*
     GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child:,),
     */

    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(
            text: AppLocalizations.of(context)!.offer,
            context: context,
            isShowBack: true),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  CouponCubit()..getAllAdsCoupons(page: 1, isRefresh: false),
            ),
            BlocProvider(
              create: (context) => HomeCubit()..getCategoryMainAndSubCategory(),
              lazy: false,
            ),
          ],
          child: BlocConsumer<CouponCubit, CouponState>(
            listener: (context, state) {
              if (state is SuccessCouponsAdsState) {
                couponUserModel
                    .addAll(state.couponUserModel!.data!.mergedAds!.data);
              }

              if (state is SuccessSearchCouponsAdsState) {
                if (state.pageSearch == 1) {
                  couponUserModel =
                      state.couponUserModel!.data!.mergedAds!.data;
                } else {
                  couponUserModel
                      .addAll(state.couponUserModel!.data!.mergedAds!.data);
                }
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: DIManager.findDep<SharedPrefs>().getToken() == null
                    ? Column(
                        children: [
                          buildGoToLogin(context),
                        ],
                      )
                    : Column(
                        children: [
                          sizeHeightNormal(),
                          _buildAppBarCoupons(context),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: PopupMenuButton<Cities>(
                                    color: appTheme.whiteA700,
                                    onSelected: (Cities newValue) {
                                      setState(() {
                                        selectedEmirate = newValue.title;
                                        cityId = newValue.id!;
                                        print("$selectedEmirate : $cityId");
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return HomeCubit.get(context)
                                          .citiesModel!
                                          .data
                                          .map((Cities value) {
                                        return PopupMenuItem<Cities>(
                                          value: value,
                                          child: Text(value.title ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall),
                                        );
                                      }).toList();
                                    },
                                    child: Container(
                                      decoration: AppDecoration
                                          .dropdownButtonChoose
                                          .copyWith(
                                              color: appTheme.whiteA700),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      height: 26.h,
                                      // width: 90.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              selectedEmirate ?? "اختر الإمارة",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall),
                                          Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: PopupMenuButton<SubCategoryModel>(
                                    color: appTheme.whiteA700,
                                    onSelected: (SubCategoryModel newValue) {
                                      setState(() {
                                        selectedCategory = newValue
                                            .title; // قم بتخزين العنوان أو الكائن كما تحتاج
                                        selectedId = newValue
                                            .categoryId!; // قم بتخزين العنوان أو الكائن كما تحتاج
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return HomeCubit.get(context)
                                          .categoriesHavePrice
                                          .map((SubCategoryModel category) {
                                        return PopupMenuItem<SubCategoryModel>(
                                          value: category,
                                          child: Text(
                                            category.title ?? "غير معروف",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                        );
                                      }).toList();
                                    },
                                    child: Container(
                                      decoration: AppDecoration
                                          .dropdownButtonChoose
                                          .copyWith(
                                              color: appTheme.whiteA700),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      height: 26.h,
                                      // width: 90.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedCategory ?? "اختر الصنف",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                          Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: state is LoadingCouponsAdsState ||
                                          state is LoadingSearchCouponsAdsState
                                      ? LoadingAnimationWidget.fallingDot(
                                          size: 25,
                                          color: appTheme.greenColor)
                                      : Row(
                                          children: [
                                            textNormal(
                                                text: couponUserModel.length
                                                    .toString(),
                                                fontSize: 10.fSize),
                                            sizeWidthNormal(),
                                            CustomElevatedButton(
                                              text: 'عرض النتائج',
                                              height: 25.h,
                                              width: 77.w,
                                              onPressed: () {
                                                couponUserModel.clear();
                                                if (searchController
                                                    .text.isEmpty) {
                                                  BlocProvider.of<CouponCubit>(
                                                          context)
                                                      .getAllAdsCoupons(
                                                          page: 1,
                                                          isRefresh: false,
                                                          categoryId:
                                                              selectedId,
                                                          cityId: cityId);
                                                } else {
                                                  BlocProvider.of<CouponCubit>(
                                                          context)
                                                      .searchCouponsAds(
                                                          page: 1,
                                                          isRefresh: false,
                                                          categoryId:
                                                              selectedId,
                                                          description:
                                                              searchController
                                                                  .text,
                                                          cityId: cityId);
                                                }
                                              },
                                              buttonStyle: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(appTheme
                                                            .deepPurpleA10001),
                                              ),
                                              buttonTextStyle: themeLite
                                                  .textTheme.bodySmall!
                                                  .copyWith(fontSize: 10.fSize, color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SmartRefreshWidget(
                              onRefresh: () async {
                                page = 1;
                                pageSearch = 1;
                                couponUserModel = [];
                                await BlocProvider.of<CouponCubit>(context)
                                    .getAllAdsCoupons(
                                        page: page, isRefresh: false);
                                _refreshController.refreshCompleted();
                              },
                              controller: _refreshController,
                              onLoading: () async {
                                if (searchController.text.isEmpty) {
                                  page++;
                                  await BlocProvider.of<CouponCubit>(context)
                                      .getAllAdsCoupons(
                                          page: page, isRefresh: true);
                                } else {
                                  pageSearch++;
                                  await BlocProvider.of<CouponCubit>(context)
                                      .searchCouponsAds(
                                          page: pageSearch,
                                          description: searchController.text,
                                          categoryId: selectedId,
                                          isRefresh: true);
                                }
                                setState(() {});
                                _refreshController.loadComplete();
                              },
                              child: SingleChildScrollView(
                                  child: (state is LoadingCouponsAdsState)
                                      ? ListView.builder(
                                          itemCount: 6,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 5.h),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              // height: 48.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              // decoration: AppDecoration.outlineBlueGray,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  // BoxShadow(
                                                  //     color: Colors.grey,
                                                  //     spreadRadius: 2.h,
                                                  //     blurRadius: 6.h,
                                                  //     offset: Offset(
                                                  //       -3,
                                                  //       -3,
                                                  //     )
                                                  // ),
                                                ],
                                                // color: AppColorsController().defaultPrimaryColor,
                                                color: DIManager.findDep<
                                                                SharedPrefs>()
                                                            .getThemeApp() ==
                                                        'd'
                                                    ? appTheme.lightBlue100
                                                    : Colors.grey
                                                        .withOpacity(0.2),
                                              ),
                                              // color: Colors.grey.withOpacity(0.2),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4.h),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.sp),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor: appTheme
                                                          .baseColorShimmer,
                                                      highlightColor: appTheme
                                                          .highlightColorShimmer,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.person,
                                                            size: 30.r,
                                                          ),
                                                          SizedBox(
                                                            width: 5.sp,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 100.w,
                                                                height: 5.h,
                                                                decoration: AppDecoration
                                                                    .outlineButtonLite
                                                                    .copyWith(
                                                                        boxShadow: []),
                                                              ),
                                                              sizeHeightNormal(),
                                                              Container(
                                                                width: 40.w,
                                                                height: 4.h,
                                                                decoration: AppDecoration
                                                                    .outlineButtonLite
                                                                    .copyWith(
                                                                        boxShadow: []),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Shimmer.fromColors(
                                                      baseColor: appTheme
                                                          .baseColorShimmer,
                                                      highlightColor: appTheme
                                                          .highlightColorShimmer,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              height: 4.h,
                                                              decoration: AppDecoration
                                                                  .outlineButtonLite
                                                                  .copyWith(
                                                                      boxShadow: []),
                                                            ),
                                                            sizeHeightNormal(),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6,
                                                              height: 4.h,
                                                              decoration: AppDecoration
                                                                  .outlineButtonLite
                                                                  .copyWith(
                                                                      boxShadow: []),
                                                            ),
                                                            sizeHeightNormal(),
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 4.h,
                                                              decoration: AppDecoration
                                                                  .outlineButtonLite
                                                                  .copyWith(
                                                                      boxShadow: []),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Shimmer.fromColors(
                                                      baseColor: appTheme
                                                          .baseColorShimmer,
                                                      highlightColor: appTheme
                                                          .highlightColorShimmer,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 214.h,
                                                          decoration: AppDecoration
                                                              .outlineButtonLite
                                                              .copyWith(
                                                                  boxShadow: []),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 270.w,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor: appTheme
                                                                    .baseColorShimmer,
                                                                highlightColor:
                                                                    appTheme
                                                                        .highlightColorShimmer,
                                                                child:
                                                                    CustomImageView(
                                                                  imagePath:
                                                                      ImageConstant
                                                                          .likeIcon,
                                                                  color: appTheme
                                                                      .deepPurpleA100,
                                                                  height: 30.sp,
                                                                  width: 30.sp,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 12.w,
                                                              ),
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor: appTheme
                                                                    .baseColorShimmer,
                                                                highlightColor:
                                                                    appTheme
                                                                        .highlightColorShimmer,
                                                                child:
                                                                    Container(
                                                                  width: 50.w,
                                                                  height: 4.h,
                                                                  decoration: AppDecoration
                                                                      .outlineButtonLite
                                                                      .copyWith(
                                                                          boxShadow: []),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Shimmer.fromColors(
                                                                  baseColor:
                                                                      appTheme
                                                                          .baseColorShimmer,
                                                                  highlightColor:
                                                                      appTheme
                                                                          .highlightColorShimmer,
                                                                  child: Icon(
                                                                      Icons
                                                                          .chat)),
                                                              SizedBox(
                                                                width: 12.w,
                                                              ),
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor: appTheme
                                                                    .baseColorShimmer,
                                                                highlightColor:
                                                                    appTheme
                                                                        .highlightColorShimmer,
                                                                child:
                                                                    Container(
                                                                  width: 50.w,
                                                                  height: 4.h,
                                                                  decoration: AppDecoration
                                                                      .outlineButtonLite
                                                                      .copyWith(
                                                                          boxShadow: []),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                      : couponUserModel.isEmpty
                                          ? Container(
                                              height: 500.h,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    textNormal(
                                                        text:
                                                            'لايتوفر عروض بعد ..'),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : _buildAdsItems(context,
                                              adsProduct: couponUserModel,
                                              state: state)),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  final FocusNode _firstFocusNode = FocusNode();
  int pageSearch = 1;

  /// Section Widget
  Widget _buildAppBarCoupons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Padding(
        padding: EdgeInsets.only(right: 16.w, left: 16.w),
        child: CustomSearchView(
          autofocus: false,
          controller: searchController,
          focusNode: _firstFocusNode,
          borderDecoration: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.h),
            borderSide: BorderSide.none,
          ),
          hintText: "ابحث عن إعلان ..",
          onChanged: (value) {
            CouponCubit.get(context).searchCouponsAds(
              page: pageSearch,
              isRefresh: false,
              description: searchController.text,
              categoryId: selectedId,
              cityId: cityId,
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdsItems(
    BuildContext context, {
    List<DataProductBannerModel>? adsProduct,
    state,
  }) {
    return adsProduct == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: adsProduct.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        navigatorToPush(
                            context: context,
                            pageName: DetailsProduct(
                              detailsProduct: adsProduct[index],
                              categoryId:
                                  adsProduct[index].categoryId.toString(),
                              adsName: adsProduct[index].name,
                              idAds: adsProduct[index].adsId.toString(),
                              idBannerOrProduct:
                                  int.parse(adsProduct[index].adsId!),
                              idAdOnwerCompany:
                                  int.parse(adsProduct[index].userId!),
                            ));
                      },
                      child: AdsProductWidget(
                        dataProductItem: adsProduct[index],
                      ));
                },
              ),
              adsProduct.isNotEmpty
                  ? sizeHeightNormal(height: 10.h)
                  : Container(),
              if (state is LoadingRefreshCouponsAdsState) ...[
                Center(
                  child: Container(
                      width: 20.h,
                      height: 20.h,
                      child: CircularProgressIndicator(color: appTheme.greenColor,
                        strokeWidth: 1.5,
                      )),
                ),
              ],
              SizedBox(height: 60.h),
            ],
          );
  }

  void showDetailsCoupon(BuildContext context, CouponList coupons, index) {
    DateTime startDateTime = DateTime.parse(coupons.startDate.toString());

    String createdAtTime = DateFormat('yyyy-MM-dd').format(startDateTime);
    CouponCubit couponCubit = CouponCubit.get(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: appTheme.buttonColor,
            // title: Text(
            //   'هل أنت متأكد من حذف الإعلان ؟',
            //   style: themeLite.textTheme.titleSmall,
            // ),
            content: Container(
              height: accountType == 'company' ? 130.h : 110.h,
              child: Column(
                children: [
                  if (accountType == 'company') ...{
                    customDetailsCoupon(
                        title: 'اسم المستخدم',
                        contentCoupon: coupons.userName.toString()),
                  } else ...{
                    customDetailsCoupon(
                        title: 'اسم الشركة',
                        contentCoupon: coupons.companyName.toString()),
                  },
                  customDetailsCoupon(
                      title: 'اسم الإعلان',
                      contentCoupon: coupons.ads_description.toString()),
                  customDetailsCoupon(
                      title: 'نسبة الخصم',
                      contentCoupon: "%${coupons.couponPercent.toString()}"),
                  customDetailsCoupon(
                      title: 'تاريخ الكوبون', contentCoupon: createdAtTime),
                  if (accountType == 'company') ...{
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customDetailsCoupon(
                            title: 'رقم المستخدم',
                            contentCoupon: '${coupons.userMobile.toString()}+'),
                        // sizeWidthNormal(width: 4.w),
                        InkWell(
                            onTap: () {
                              copyToClipboard(
                                  '${coupons.userMobile.toString()}+', context);
                            },
                            child: textNormal(text: 'نسخ', fontSize: 12.sp)),
                      ],
                    ),
                  } else
                    ...{},
                  sizeHeightNormal(),
                  if (accountType == 'company') ...{
                    CustomElevatedButton(
                      text: coupons.used == '1' ? "تم الاستخدام" : "استخدام",
                      buttonTextStyle:
                          themeLite.textTheme.titleMedium!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                      ),
                      buttonStyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            coupons.used == '1' ? Colors.green : Colors.grey),
                      ),
                      width: 85.w,
                      height: 30.h,
                      onPressed: () {
                        if (coupons.used == '0') {
                          couponCubit.usedCoupons(
                              code: coupons.code.toString(),
                              indexCoupon: index);
                        }

                        Navigator.of(context).pop();
                      },
                    ),
                  } else ...{
                    CustomElevatedButton(
                      text: "إغلاق",
                      buttonTextStyle: themeLite.textTheme.titleMedium!
                          .copyWith(
                              fontSize: 12.sp, fontWeight: FontWeight.w300),
                      width: 85.w,
                      height: 30.h,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  },
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void copyToClipboard(String text, context) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarHelper.mySnackBarSuccess('تم نسخ الرقم', context);
  }

  Widget customDetailsCoupon({required String title, String? contentCoupon}) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgTrue,
          color: Colors.white,
          height: 14.w,
          width: 14.w,
        ),
        sizeWidthNormal(width: 4.w),
        textNormal(
            text: '$title', fontWeight: FontWeight.w300, fontSize: 12.sp),
        Container(
          width: 120.w,
          child: textNormal(
              text: ': $contentCoupon',
              fontWeight: FontWeight.w300,
              fontSize: 12.sp),
        ),
      ],
    );
  }
}
