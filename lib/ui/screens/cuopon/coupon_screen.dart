import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/coupon/coupon_outer_model.dart';
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

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/theme_helper.dart';


class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController searchOuterController = TextEditingController();
  String? accountType = DIManager.findDep<SharedPrefs>().getAccountType();
  List<CouponList> couponUserModel = [];
  List<CouponsOuterList> couponOuterModel = [];

  int page = 1;
  int pageSearchOuter = 1;
  int pageOuter = 1;
  int typeCoupons = 1;
  bool isLoadingCouponsUser = true;
  bool isLoadingCouponsOuter = true;
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
        appBar: appBarNormalWithIcon(text:  'كوبونات',isShowBack: true,context: context),
        body:  BlocProvider(
          create: (context) => CouponCubit()..getAllCouponsUser(page: 1,isRefresh: false)..getAllCouponsOuter(isRefresh: false, page: 1),
          child: BlocConsumer<CouponCubit, CouponState>(
            listener: (context, state) {
              if(state is LoadingCouponsUsersState) {
                isLoadingCouponsUser = true;
              } else if (state is LoadingCouponsOuterState) {
                isLoadingCouponsOuter = true;
              } else {
                isLoadingCouponsUser = false;
                isLoadingCouponsOuter = false;
              }
              if (state is SuccessCouponsUsersState) {
                couponUserModel.addAll(state.couponUserModel!.coupons!.data);
              }


              if(state is SuccessCouponsOuterState) {
                couponOuterModel.addAll(state.couponOuterModel!.coupons!.data);
              }
              if (state is SuccessSearchCouponsOuterState) {
                if (state.pageSearch == 1) {
                  couponOuterModel = state.couponOuterModel!.coupons!.data;
                } else {
                  couponOuterModel.addAll(state.couponOuterModel!.coupons!.data);
                }
              }

              if (state is SuccessSearchCouponsUsersState) {
                if (state.pageSearch == 1) {
                  couponUserModel = state.couponUserModel!.coupons!.data;
                } else {
                  couponUserModel.addAll(state.couponUserModel!.coupons!.data);
                }
              }

              if (state is SuccessReadCouponsState) {
                couponUserModel[state.indexCoupon].read = '1';
              }

              if (state is SuccessUsedCouponsState) {
                couponUserModel[state.indexCoupon].used = '1';
              }
            },
            builder: (context, state) {
              return  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Column(
                      children: [
                        sizeHeightNormal(),
                        _buildAppBarCoupons(context),
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    typeCoupons = 1;
                                  });
                                },
                                text:   'كوبوناتك',
                                width: 150.w,
                                height: 30.h,
                                buttonTextStyle: themeLite.textTheme.titleSmall!
                                    .copyWith(
                                    color:typeCoupons == 1
                                        ? Colors.white
                                        : appTheme.black900,
                                    fontSize: 12.fSize),
                                buttonStyle: CustomButtonStyles.baseBorderButton
                                    .copyWith(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                    typeCoupons != 1 
                                        ? appTheme.lightBlue100
                                        : appTheme.greenColor,),
                                ),
                              ),
                              sizeWidthNormal(),
                              CustomElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    setState(() {
                                      typeCoupons = 2;
                                    });
                                  });
                                },
                                text:     'أكواد خصم',
                                width: 150.w,
                                height: 30.h,
                                buttonStyle: CustomButtonStyles.baseBorderButton
                                    .copyWith(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                    typeCoupons != 2
                                        ? appTheme.lightBlue100
                                        : appTheme.greenColor,),
                                ),
                                buttonTextStyle: themeLite.textTheme.titleSmall!
                                    .copyWith(
                                    color:   typeCoupons == 2
                                        ? Colors.white
                                        : appTheme.black900,
                                    fontSize: 12.fSize),
                              ),


                            ],
                          ),
                        ),
                       Expanded(
                          flex: 3,
                          child: SmartRefreshWidget(
                            onRefresh: () async {
                              page = 1;
                              pageOuter = 1;
                              pageSearchOuter = 1;
                              pageSearch = 1;

                              BlocProvider.of<CouponCubit>(context).getAllCouponsUser(page: page,isRefresh: false);
                              BlocProvider.of<CouponCubit>(context).getAllCouponsOuter(isRefresh: false, page: pageOuter);
                              searchOuterController.text = '';
                              searchController.text = '';
                              couponUserModel = [];
                              couponOuterModel = [];
                              _refreshController.refreshCompleted();
                            },
                            controller: _refreshController,
                            onLoading: () async {

                              if(typeCoupons ==1)
                              {
                                page++;
                                pageSearch++;
                                if (searchController.text.isEmpty) {
                                  await BlocProvider.of<CouponCubit>(
                                      context)
                                      .getAllCouponsUser(
                                      page: page,
                                      isRefresh: true);
                                } else {
                                  await BlocProvider.of<CouponCubit>(
                                      context)
                                      .searchCouponsUser(
                                      page: pageSearch,
                                      code:
                                      searchController.text,
                                      isRefresh: true);
                                }
                              }else{
                                pageOuter++;
                                pageSearchOuter++;
                                if (searchController.text.isEmpty) {
                                  await BlocProvider.of<CouponCubit>(
                                      context)
                                      .getAllCouponsOuter(
                                      isRefresh: true, page: pageOuter);
                                } else {
                                  await BlocProvider.of<CouponCubit>(
                                      context)
                                      .searchAllCouponsOuter(
                                      page: pageSearchOuter,
                                      title:
                                      searchOuterController.text,
                                      isRefresh: true);
                                }
                              }

                              // await BlocProvider.of<CouponCubit>(context).getAllCouponsUser(page: page,isRefresh: true);
                              setState(() {});
                              _refreshController.loadComplete();
                            },
                            child: SingleChildScrollView(
                                child:



                                typeCoupons ==1?
                                (isLoadingCouponsUser
                                    ? _buildCouponShimmer()
                                    : couponUserModel.isEmpty
                                    ? Padding(
                                  padding: EdgeInsets.only(top: 220.h),
                                  child: Center(
                                    child: textNormal(
                                        text: 'لايتوفر كوبونات بعد ..'),
                                  ),
                                )
                                    :  _buildCoupons(
                                    context, couponUserModel,state))

                            :
                                (isLoadingCouponsOuter
                                    ? Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      sizeHeightNormal(height: 250.h),
                                      LoadingAnimationWidget.beat(
                                        color: appTheme.greenColor,
                                        size: 100,
                                      ),
                                    ],
                                  ),
                                )
                                    : couponOuterModel.isEmpty
                                    ? Padding(
                                  padding: EdgeInsets.only(top: 220.h),
                                  child: Center(
                                    child: textNormal(
                                        text: 'لايتوفر أكواد خصم بعد ..'),
                                  ),
                                )
                                    : _buildCouponsOuters(
                                    context, couponOuterModel,state))),
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
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Padding(
        padding: EdgeInsets.only(right: 16.w, left: 16.w),
        child: CustomSearchView(
          autofocus: false,
          controller: typeCoupons ==1? searchController:searchOuterController,
          focusNode: _firstFocusNode,
          hintText: typeCoupons ==1?  "ابحث عن كوبون ..":'ابحث عن كود خصم ..',
          onChanged: (value) {
            if(typeCoupons ==1){
              CouponCubit.get(context)
                  .searchCouponsUser(code: value, page: pageSearch,isRefresh: false);}else{
              CouponCubit.get(context)
                  .searchAllCouponsOuter(title: value, page: pageSearchOuter,isRefresh: false);
            }
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildCoupons(BuildContext context, List<CouponList> coupons,state) {
    CouponCubit couponCubit = CouponCubit.get(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 100.h,
            crossAxisCount: 3,
            mainAxisSpacing: 30.h,
            crossAxisSpacing: 15.h,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: coupons.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                couponCubit.readCoupons(
                    code: coupons[index].code.toString(), indexCoupon: index);
                // setState(() {
                //   coupons[index].read = '1';
                // });
                showDetailsCoupon(context, coupons[index], index);
              },
              child: Column(
                children: [
                  Container(
                    height: 70.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          height: 75.h,
                          width: 110.h,
                          imagePath: ImageConstant.imgBackCoupons,
                          fit: BoxFit.fill,
                        ),
                        coupons[index].read == '1'
                            ? Container()
                            : Positioned(
                                bottom: 30.h,
                                right: 25.w,
                                child: textNormal(
                                    text: '*',
                                    fontSize: 25.sp,
                                    color: Colors.red),
                              ),
                        if (accountType == 'company') ...{
                          Positioned(
                            bottom: 7.h,
                            // bottom: 43.h,
                            // left: 25.w,
                            child: CustomImageView(
                              imagePath: ImageConstant.imgTrue,
                              color: coupons[index].used == '1'
                                  ? Colors.green
                                  : Colors.white,
                              height: 20.w,
                              width: 20.w,
                            ),
                          ),
                        },
                        Text(
                          coupons[index].code.toString(),
                          style: themeLite.textTheme.titleSmall!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (state is LoadingRefreshCouponsUsersState) ...[
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

  /// Section Widget
  Widget _buildCouponsOuters(BuildContext context, List<CouponsOuterList> coupons,state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: coupons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: InkWell(
                onTap: (){

                  Clipboard.setData(ClipboardData(text:  coupons[index].code.toString(),));
                  SnackBarHelper.mySnackBarSuccess(' تم نسخ الكود ${coupons[index].code.toString()}', context);
                },
                child: Row(
                  children: [
                    // جزء الخصم - Left Section
                    Container(
                      width: 80.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: appTheme.greenColor, // لون مميز حسب نوع الكوبون
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),

                        ),
                        border: Border.all(color: Colors.black.withOpacity(.5)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${coupons[index].discountPercentage.toString()}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'خصم',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // جزء المعلومات - Right Section
                    Expanded(
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.r),
                            bottomRight: Radius.circular(15.r),
                          ),
                          border: Border.all(color: Colors.black.withOpacity(.5)),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                sizeHeightNormal(),
                            Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  coupons[index].providerName.toString(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                coupons[index].code.toString(),
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.greenColor,
                                ),
                              ),
                            ),
                            coupons[index].description.toString() !='null'?   Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Container(
                                width: double.infinity,
                                child: textNormal(text: coupons[index].description.toString(),maxLines: 1,fontSize: 11.sp),
                              ),
                            ):Container()
                            ,
                            Spacer(),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                'صالح لـ ${coupons[index].durationDays} أيام',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                  fontFamily: DIManager.findDep<SharedPrefs>().getFontType(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            sizeHeightNormal(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (state is LoadingRefreshCouponsOuterState) ...[
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

  Widget _buildCouponShimmer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 65.h,
            crossAxisCount: 3,
            mainAxisSpacing: 30.h,
            crossAxisSpacing: 15.h,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 22,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              // baseColor: appTheme.cyan400,
              // highlightColor: appTheme.blue600,
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200.h,
                    width: 110.h,
                    // width: double.maxFinite,
                    // padding: EdgeInsets.symmetric(vertical: 14),
                    child: Image.asset(
                      ImageConstant.imgBackCoupons,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    '',
                    style: themeLite.textTheme.titleSmall,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 60.h),
      ],
    );
  }

  void showDetailsCoupon(BuildContext context, CouponList coupons, index) {
    DateTime startDateTime = DateTime.parse(coupons.startDate.toString());

    String createdAtTime = DateFormat('yyyy-MM-dd').format(startDateTime);
    CouponCubit couponCubit = CouponCubit.get(context);
    List<String> words = coupons.ads_description.toString().split(' '); // تقسيم النص إلى كلمات
    String firstThreeWords = words.take(3).join(' '); // أخذ أول ثلاث كلمات ودمجها

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
              height: accountType == 'company' ? 140.h : 120.h,
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
                      contentCoupon: cleanHtmlText(firstThreeWords.toString())  ),
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
