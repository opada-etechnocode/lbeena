import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/edit_ad_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/helper/snack_bar_helper.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/chats/message_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/loader_for_page.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../auth/login/login_screen.dart';
import '../../cart/cart_page.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../../chats/chat_messages_ad.dart';
import '../../home/cubit/cubit.dart';

class DetailsAdWidget extends StatefulWidget {
  DetailsAdWidget({super.key,
  required this.dataDetailsProduct,
    required this.isBanner,
    required this.isBannerInOut,
    required this.idBannerOrProduct,
    required this.categoryId,
    required this.idAdOnwerCompany,
    required this.isFavorite,
    required this.isOwnerCompany,
    required this.loadingActiveChats,
    required this.tokenUser,
    required this.isChats,
    required this.mobileNumber,
    required this.isFromStore,
    required this.type,
  });
 final dynamic dataDetailsProduct;
 final bool isBanner;
  final bool isBannerInOut;
  final int? idBannerOrProduct;
  final String categoryId;
  final String idAdOnwerCompany;
  final bool isFavorite;
  final bool isOwnerCompany;
  final bool loadingActiveChats;
  final bool isChats;
  final bool isFromStore;
  final String? tokenUser;
  late String mobileNumber;
  final String type;

  @override
  State<DetailsAdWidget> createState() => _DetailsAdWidgetState();
}

class _DetailsAdWidgetState extends State<DetailsAdWidget> {

  final PageController _pageViewController =
  PageController(initialPage: 0);
  int _activePage = 0;

  String? createdAt;
  String? createdAtTime;

  @override
  void initState() {
    String createdAt = widget.dataDetailsProduct.acceptDate.toString();

    DateTime createdAtDateTime =
    DateTime.parse(createdAt == 'null' ? '2024-04-25 12:13:42' : createdAt);
    createdAtTime = DateFormat('hh:mma /yyyy-MM-dd').format(createdAtDateTime);
    if(   widget.mobileNumber.toString() != 'null' &&
        widget.mobileNumber.toString() != '000'){
      String myString = widget.mobileNumber;
      String newString = widget.mobileNumber.length >= 11  && widget.mobileNumber.contains('971')? myString.substring(3) : widget.mobileNumber;
      mobileNoController?.text = newString;
    }

    super.initState();
  }
  bool _isAddingToCart = false;

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 7.h),
          child: Neumorphic(
            style: getNeumorphicStyle().copyWith(
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18.r)),
              shadowLightColor:purpleShadowColor.withOpacity(1),
              shadowDarkColor: purpleShadowColor.withOpacity(0.4),
              color: appTheme.lightBlue100,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 450.h,
              // height: 480.h,
              // color: appTheme.buttonColor,
              decoration: AppDecoration.outlineContainer.copyWith(
                borderRadius: BorderRadius.zero,
                border: null,
                  boxShadow: [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      widget.isBanner
                          ? CustomImageView(
                        imagePath:
                        widget.dataDetailsProduct.image.toString().contains('http')
                            ? widget.dataDetailsProduct.image.toString()
                            : AppEndpoints.baseUrlWithoutApi +
                            widget.dataDetailsProduct.image.toString(),
                        // AppEndpoints.baseImageUrl +
                        //     dataDetailsProduct.image.toString(),
                        // imagePath: '${ImageConstant.imagePath}/1.PNG',
                        height: 190.h,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        radius: BorderRadius.circular(
                          35.r,
                        ),
                        // alignment: Alignment.center,
                      )
                          : Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (widget.dataDetailsProduct.imageNames.isEmpty ||
                              widget.dataDetailsProduct.imageNames[0] == '' ||
                              widget.dataDetailsProduct.imageNames == null) ...{
                            Container(),
                          } else ...{
                            AspectRatio(
                              aspectRatio: 1080 / 1350,
                              child: PageView.builder(
                                  controller: _pageViewController,
                                  onPageChanged: (int index) {
                                    setState(() {
                                      _activePage = index;
                                    });
                                  },
                                  itemCount:
                                  widget.dataDetailsProduct.imageNames.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            backgroundColor: appTheme
                                                .borderImageColor
                                                .withOpacity(.001),
                                            contentPadding:
                                            EdgeInsets.all(0.sp),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(0.0),
                                            ),
                                            content: CustomImageView(
                                              imagePath: widget.dataDetailsProduct
                                                  .imageNames[index]
                                                  .toString()
                                                  .contains('http')
                                                  ? widget.dataDetailsProduct
                                                  .imageNames[index]
                                                  .toString()
                                                  : AppEndpoints
                                                  .baseUrlWithoutApi +
                                                  widget.dataDetailsProduct
                                                      .imageNames[index]
                                                      .toString(),
                                              // imagePath: '${ImageConstant.imagePath}/1.PNG',

                                              // height: 190.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fitHeight,
                                              // radius: BorderRadius.circular(15.r),
                                              // alignment: Alignment.center,
                                            ), // استبدل هذا بمسار الصورة الخاص بك
                                          ),
                                        );
                                      },
                                      // onLongPressEnd: (a){
                                      //   Navigator.of(context).pop();
                                      // },
                                      child: CustomImageView(
                                        imagePath: widget.dataDetailsProduct
                                            .imageNames[index]
                                            .toString()
                                            .contains('http')
                                            ? widget.dataDetailsProduct
                                            .imageNames[index]
                                            .toString()
                                            : AppEndpoints.baseUrlWithoutApi +
                                            widget.dataDetailsProduct
                                                .imageNames[index]
                                                .toString(),
                                        // imagePath: '${ImageConstant.imagePath}/1.PNG',

                                        height: 190.h,
                                        width:
                                        MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        radius: BorderRadius.only(
                                            topLeft: Radius.circular(15.r),
                                            topRight: Radius.circular(15.r)),
                                        // alignment: Alignment.center,
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<Widget>.generate(
                                    widget.dataDetailsProduct.imageNames.length ?? 0,
                                        (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          _pageViewController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn);
                                        },
                                        child: CircleAvatar(
                                            radius: (4).r,
                                            // check if a dot is connected to the current page
                                            // if true, give it a different color
                                            backgroundColor:
                                            _activePage == index
                                                ? Colors.white
                                                : Colors.black
                                                .withOpacity(.6)),
                                      ),
                                    )),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 3.h),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  reverse:
                                  true, // لعرض العناصر من اليمين لليسار
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    // محاذاة لليمين
                                    children: List<Widget>.generate(
                                      widget.dataDetailsProduct.imageNames.length ?? 0,
                                          (index) => GestureDetector(
                                        onTap: () {
                                          _pageViewController.animateToPage(
                                            index,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn,
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4.h),
                                          width: _activePage == index
                                              ? 65.sp
                                              : 50.sp,
                                          // العرض يختلف حسب الصورة النشطة
                                          height: _activePage == index
                                              ? 65.sp
                                              : 50.sp,
                                          // الارتفاع يختلف
                                          decoration: BoxDecoration(
                                            color: _activePage == index
                                                ? Colors.white
                                                : Colors.black.withOpacity(.6),
                                            borderRadius:
                                            BorderRadius.circular(4.sp),
                                            // زوايا مربعة بدلاً من دائرة
                                            border: _activePage == index
                                                ? Border.all(
                                                color: Colors.black,
                                                width: 2)
                                                : null, // إطار للصورة النشطة
                                          ),
                                          child: CustomImageView(
                                            imagePath: widget.dataDetailsProduct
                                                .imageNames[index]
                                                .toString()
                                                .contains('http')
                                                ? widget.dataDetailsProduct
                                                .imageNames[index]
                                                .toString()
                                                : AppEndpoints
                                                .baseUrlWithoutApi +
                                                widget.dataDetailsProduct
                                                    .imageNames[index]
                                                    .toString(),
                                            // imagePath: '${ImageConstant.imagePath}/1.PNG',

                                            // height: 190.h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.fitHeight,
                                            // radius: BorderRadius.circular(15.r),
                                            // alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          }
                        ],
                      ),
                      if (widget.isBannerInOut == false) ...[
                        Row(
                          children: [
                            Spacer(),
                            if (isLoadingShareAds) ...{
                            CircleAvatar(
                            backgroundColor: appTheme.greenColorApp,
child:
                            Shimmer.fromColors(
                                baseColor: appTheme.baseColorShimmer,
                                highlightColor: appTheme.highlightColorShimmer,
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgShare,
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ))
                            } else ...{
                            CircleAvatar(
                            backgroundColor: appTheme.greenColorApp,
child:
                            InkWell(
                                onTap: () {
                                  // print('object');

                                  HomeCubit.get(context)
                                      .changeStatusCounterForWhatsappShareChat(
                                      idAds: int.parse(widget.dataDetailsProduct.adsId!),
                                      type: 2);
                                  shareAds(
                                      nameAds: widget.dataDetailsProduct.name.toString(),
                                      descriptionAds:
                                      widget.dataDetailsProduct.description.toString(),
                                      idAdsAndBanner: widget.idBannerOrProduct!,
                                      categoryId: widget.categoryId.toString(),
                                      idAdsProduct:
                                      int.parse(widget.dataDetailsProduct.adsId!),
                                      idCompany: widget.idAdOnwerCompany.toString(),
                                      isBanner: widget.isBanner,
                                      imageUrl: widget.isBanner
                                          ? widget.dataDetailsProduct.image
                                          .toString()
                                          .contains('http')
                                          ? widget.dataDetailsProduct.image.toString()
                                          : AppEndpoints.baseUrlWithoutApi +
                                          widget.dataDetailsProduct.image.toString()
                                          : widget.dataDetailsProduct.imageNames[0]
                                          .toString()
                                          .contains('http')
                                          ? widget.dataDetailsProduct.imageNames[0]
                                          .toString()
                                          : AppEndpoints.baseUrlWithoutApi +
                                          widget.dataDetailsProduct.imageNames[0]
                                              .toString());
                                },
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgShare,
                                  width: 20.fSize,
                                  height: 20.fSize,
                                  color: Colors.white,
                                ),
                              )),
                            },
                            HomeCubit.get(context).isLoadingIsFavorites
                                ? Shimmer.fromColors(
                              baseColor: appTheme.baseColorShimmer,
                              highlightColor: appTheme.highlightColorShimmer,
                              child: IconButton(
                                  onPressed: () {
                                    if (widget.tokenUser == null) {
                                      // print('object');
                                      navigatorToPush(
                                          context: context,
                                          pageName: LoginScreen(
                                            isNeedIconBac: true,
                                          ));
                                    } else {
                                      HomeCubit.get(context)
                                          .addAndRemoveAdsFromFavorites(
                                          adsId: int.parse(
                                              widget.dataDetailsProduct.ad_id!));
                                    }
                                  },
                                  icon:CircleAvatar(
                                    backgroundColor: appTheme.greenColorApp,
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 25.fSize,
                                    ),
                                  )),
                            )
                                :  IconButton(
                                onPressed: () {
                                  if (widget.tokenUser == null) {
                                    // print('object');
                                    navigatorToPush(
                                        context: context,
                                        pageName: LoginScreen(
                                          isNeedIconBac: true,
                                        ));
                                  } else {
                                    HomeCubit.get(context)
                                        .addAndRemoveAdsFromFavorites(
                                        adsId: int.parse(
                                            widget.dataDetailsProduct.ad_id!));
                                  }
                                },
                                icon: CircleAvatar(
                                  backgroundColor: appTheme.greenColorApp,

                                  child: Icon(
                                    widget.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                    size: 25.fSize,
                                  ),
                                )),

                          ],
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isOwnerCompany &&
                            widget.dataDetailsProduct.status == '2') ...[
                          widget.dataDetailsProduct.note == null
                              ? Container()
                              : textNormal(
                              text: widget.dataDetailsProduct.note ?? '',
                              color: appTheme.activeButtonNavigatorBarIcon,
                              overflow: TextOverflow.visible),
                        ],
                        (widget.dataDetailsProduct.name == null || widget.dataDetailsProduct.name == "null")
                            ? Container()
                            : Text(
                          widget.dataDetailsProduct.name.toString(),
                          style: themeLite.textTheme.titleSmall!
                              .copyWith(color: Colors.white),
                        ),
                        if ((widget.dataDetailsProduct.description != null ||
                           createdAt != 'null') &&
                            !widget.isBannerInOut) ...[
                          Row(
                            children: [
                              Text('التفاصيل :',
                                  style: themeLite.textTheme.titleSmall),
                              Spacer(),
                              Text(
                               createdAt == 'null' ? '' :  createdAtTime.toString(),
                                style: themeLite.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.visible),
                              ),
                            ],
                          ),
                          widget.dataDetailsProduct.description == null
                              ? Container()
                              : Text( cleanHtmlText(widget.dataDetailsProduct.description.toString()),
                            // unescape.convert(widget.dataDetailsProduct.description.toString()),
                            style: themeLite.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                        if (widget.isBannerInOut == false) ...[
                          sizeHeightNormal(
                            height: 10.h,
                          ),
                          widget.dataDetailsProduct.toString() == '0.0' ||
                              widget.dataDetailsProduct.price.toString() == '0' ||
                              widget.dataDetailsProduct.price.toString() == '0.00' ||
                              widget.dataDetailsProduct.price.toString() == 'null'
                              ? Row(
                            children: [
                              Container(),
                              Spacer(),
                              if ((widget.dataDetailsProduct.imageNames.isEmpty ||
                                  widget.dataDetailsProduct.imageNames[0] == '' ||
                                  widget.dataDetailsProduct.imageNames == null))
                                ...{}
                              else ...{
                                Row(
                                  children: [
                                    Container(
                                      child: RatingBarIndicator(
                                        rating: double.parse(
                                            widget.dataDetailsProduct.evaluationsAd ??
                                                '0')
                                            .toDouble(),
                                        itemCount: 5,
                                        itemSize: 16.r,
                                        unratedColor: Colors.white70,
                                        direction: Axis.horizontal,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          size: 13.h,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ),
                                    sizeWidthNormal(width: 5.w),
                                  widget.isOwnerCompany
                                        ? Container()
                                        : InkWell(
                                        onTap: () {
                                          if (widget.tokenUser == null) {
                                            navigatorToPush(
                                                context: context,
                                                pageName: LoginScreen(
                                                  isNeedIconBac: true,
                                                ));
                                          } else {
                                            showRatingAds(
                                                context,
                                                int.parse(widget.dataDetailsProduct
                                                    .ad_id!),double.parse(
                                                widget.dataDetailsProduct.evaluationsAd ??
                                                    '0')
                                                .toDouble());
                                          }
                                        },
                                        child: HomeCubit.get(context).isLoadingEvaluateAds
                                            ? loaderNormal(size: 20.sp)
                                            : textNormal(
                                            text: 'قيّم الإعلان',
                                            fontSize:
                                            AppFontSize.fontSize_11,
                                            color: Colors.yellow)),
                                  ],
                                ),
                              }
                            ],
                          )
                              : Row(
                            children: [
                              Text(
                                'السعر : ',
                                style: themeLite.textTheme.titleSmall!
                                    .copyWith(color: Colors.white),
                              ),
                              if (widget.dataDetailsProduct.finalPrice == null) ...{
                                Text(
                                  "${widget.dataDetailsProduct.price.toString()} درهم ",
                                  style: themeLite.textTheme.titleSmall!
                                      .copyWith(
                                      color:
                                      DIManager.findDep<SharedPrefs>()
                                          .getThemeApp() ==
                                          'd'
                                          ? Colors.green
                                          : Colors.white,
                                      fontWeight: FontWeight.w400),
                                )
                              } else ...{
                                double.parse(widget.dataDetailsProduct.finalPrice.toString())
                                    .toString() ==
                                    double.parse(
                                        widget.dataDetailsProduct.price.toString())
                                        .toString()
                                    ? Text(
                                  "${widget.dataDetailsProduct.price.toString()} درهم ",
                                  style: themeLite.textTheme.titleSmall!
                                      .copyWith(
                                      color: DIManager.findDep<
                                          SharedPrefs>()
                                          .getThemeApp() ==
                                          'd'
                                          ? Colors.green
                                          : Colors.white,
                                      fontWeight: FontWeight.w400),
                                )
                                    : Text(
                                  "${widget.dataDetailsProduct.price.toString()} ",
                                  style: themeLite.textTheme.titleSmall!
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: AppFontSize.fontSize_13,
                                    decoration:
                                    TextDecoration.lineThrough,
                                  ),
                                ),
                                sizeWidthNormal(width: 4.w),
                                double.parse(widget.dataDetailsProduct.finalPrice.toString())
                                    .toString() ==
                                    double.parse(
                                        widget.dataDetailsProduct.price.toString())
                                        .toString()
                                    ? Container()
                                    : Text(
                                  "${double.parse(widget.dataDetailsProduct.finalPrice.toString()).toString()} درهم ",
                                  style: themeLite.textTheme.titleSmall!
                                      .copyWith(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              },
                              if ((widget.dataDetailsProduct.imageNames.isEmpty ||
                                  widget.dataDetailsProduct.imageNames[0] == '' ||
                                  widget.dataDetailsProduct.imageNames == null))
                                ...{}
                              else ...{
                                Spacer(),
                                Row(
                                  children: [
                                    Container(
                                      child: RatingBarIndicator(
                                        rating: double.parse(widget.dataDetailsProduct
                                            ?.evaluationsAd ==
                                            'null' ||
                                            widget.dataDetailsProduct
                                                ?.evaluationsAd ==
                                                null
                                            ? '0'
                                            : widget.dataDetailsProduct.evaluationsAd
                                            .toString())
                                            .toDouble(),
                                        itemCount: 5,
                                        itemSize: 16.r,
                                        unratedColor: Colors.white70,
                                        direction: Axis.horizontal,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          size: 13.h,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ),
                                    sizeWidthNormal(width: 5.w),
                                    widget.isOwnerCompany
                                        ? Container()
                                        : InkWell(
                                        onTap: () {
                                          if (widget.tokenUser == null) {
                                            navigatorToPush(
                                                context: context,
                                                pageName: LoginScreen(
                                                  isNeedIconBac: true,
                                                ));
                                          } else {
                                            showRatingAds(
                                                context,
                                                int.parse(widget.dataDetailsProduct
                                                    .adsId!),double.parse(
                                                widget.dataDetailsProduct.evaluationsAd ??
                                                    '0')
                                                .toDouble());
                                          }
                                        },
                                        child: HomeCubit.get(context).isLoadingEvaluateAds
                                            ? loaderNormal(size: 20.sp)
                                            : textNormal(
                                            text: 'قيّم الإعلان',
                                            fontSize:
                                            AppFontSize.fontSize_11,
                                            color: Colors.yellow)),
                                  ],
                                ),
                              },
                            ],
                          ),
                          // sizeHeightNormal(
                          //   height: 7.h,
                          // ),
                        ],
                        if ((widget.dataDetailsProduct.imageNames.isEmpty ||
                            widget.dataDetailsProduct.imageNames[0] == '' ||
                            widget.dataDetailsProduct.imageNames == null)) ...{
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Container(
                                child: RatingBarIndicator(
                                  rating:
                                  double.parse(widget.dataDetailsProduct.evaluationsAd ?? '0')
                                      .toDouble(),
                                  itemCount: 5,
                                  itemSize: 16.r,
                                  unratedColor: Colors.white70,
                                  direction: Axis.horizontal,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 13.h,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                              sizeWidthNormal(width: 5.w),
                              widget.isOwnerCompany
                                  ? Container()
                                  : InkWell(
                                  onTap: () {
                                    if (widget.tokenUser == null) {
                                      navigatorToPush(
                                          context: context,
                                          pageName: LoginScreen(
                                            isNeedIconBac: true,
                                          ));
                                    } else {
                                      showRatingAds(context,
                                          int.parse(widget.dataDetailsProduct.adsId!),double.parse(
                                              widget.dataDetailsProduct.evaluationsAd ??
                                                  '0')
                                              .toDouble());
                                    }
                                  },
                                  child: HomeCubit.get(context).isLoadingEvaluateAds
                                      ? loaderNormal(size: 20.sp)
                                      : textNormal(
                                      text: 'قيّم الإعلان',
                                      fontSize: AppFontSize.fontSize_11,
                                      color: Colors.yellow)),
                            ],
                          ),
                        },
                        if (widget.isBannerInOut == false) ...[
                          SizedBox(
                            height: 15.h,
                          ),
                          Column(
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: itemButtonContainerProductPage(
                                      text: 'دردشة',status: widget.dataDetailsProduct.status,
                                      isLoading: widget.loadingActiveChats,
                                      onTap: () {
                                        if (DIManager.findDep<SharedPrefs>()
                                            .getStatusUserIsBlocked() ==
                                            0) {
                                          SnackBarHelper.mySnackBarError(
                                              'الحساب محظور لايمكنك الدردشة ..',
                                              context);
                                          return;
                                        }
                                        if (widget.isOwnerCompany) {
                                          showChats(context,
                                              int.parse(widget.dataDetailsProduct.ad_id ?? '0'));
                                        } else {
                                          if (widget.tokenUser == null) {
                                            navigatorToPush(
                                                context: context,
                                                pageName: LoginScreen(
                                                  isNeedIconBac: true,
                                                ));
                                          } else {
                                            if (widget.dataDetailsProduct.activeChat ==
                                                '0') {
                                              showInfoCompany(context, 'الدردشة :',
                                                  'غير مفعلة في هذه الشركة ..');
                                            } else {
                                              HomeCubit.get(context)
                                                  .changeStatusCounterForWhatsappShareChat(
                                                  idAds: int.parse(
                                                      widget.dataDetailsProduct.adsId!.toString()),
                                                  type: 1);

                                              //dataDetailsProduct.description.toString()

                                              String text = cleanHtmlText(widget.dataDetailsProduct.description.toString());
                                              List<String> words = text
                                                  .split(' '); // تقسيم النص إلى كلمات
                                              String firstThreeWords = words
                                                  .take(3)
                                                  .join(
                                                  ' '); // أخذ أول ثلاث كلمات ودمجها

                                              navigatorToPush(
                                                  context: context,
                                                  pageName: ChatMessagesPage(
                                                    dataMessage: ArgumentMessage(
                                                      ad_id: int.parse(
                                                          widget.dataDetailsProduct!.adsId),
                                                      idBannerOrProduct:
                                                      widget.idBannerOrProduct,
                                                      idAdOnwerCompany: widget
                                                          .idAdOnwerCompany
                                                          .toString(),
                                                      // idBannerOrProduct:  int.parse(state.pathParameters['itemId']!),
                                                      isBanner: widget.isBanner,
                                                      categoryId: widget.categoryId,
                                                      isBannerInOut:
                                                      widget.isBannerInOut,
                                                      imageAds: widget.isBanner
                                                          ? (widget.dataDetailsProduct.image
                                                          .toString()
                                                          .contains('http')
                                                          ? widget.dataDetailsProduct
                                                          .image
                                                          .toString()
                                                          : AppEndpoints
                                                          .baseUrlWithoutApi +
                                                          widget.dataDetailsProduct
                                                              .image
                                                              .toString())
                                                          : (widget.dataDetailsProduct
                                                          .imageNames[0]
                                                          .toString()
                                                          .contains('http')
                                                          ? widget.dataDetailsProduct
                                                          .imageNames[0]
                                                          .toString()
                                                          : AppEndpoints
                                                          .baseUrlWithoutApi +
                                                          widget.dataDetailsProduct
                                                              .imageNames[0]
                                                              .toString()),
                                                      nameAds: firstThreeWords,
                                                      nameOwnerAds: widget.dataDetailsProduct
                                                          .company[0].companyName,
                                                      user_id: DIManager.findDep<
                                                          SharedPrefs>()
                                                          .getUserID()
                                                          .toString(),
                                                      user_id_2: int.parse(
                                                          widget.dataDetailsProduct.userId!),
                                                      user_name_person_sender:
                                                      DIManager.findDep<SharedPrefs>().getAccountType() == 'company'
                                                          ? DIManager.findDep<
                                                          SharedPrefs>()
                                                          .getUserNameCompany()
                                                          .toString()
                                                          : DIManager.findDep<
                                                          SharedPrefs>()
                                                          .getUserName()
                                                          .toString(),
                                                      imageUser: DIManager.findDep<
                                                          SharedPrefs>()
                                                          .getImageProfile()
                                                          .toString()
                                                          .contains('http')
                                                          ? DIManager.findDep<
                                                          SharedPrefs>()
                                                          .getImageProfile()
                                                          .toString()
                                                          : AppEndpoints
                                                          .baseUrlWithoutApi +
                                                          DIManager.findDep<
                                                              SharedPrefs>()
                                                              .getImageProfile()
                                                              .toString(),
                                                      imageCompany: widget.dataDetailsProduct
                                                          .company[0].profilePic
                                                          .toString()
                                                          .contains('http')
                                                          ? widget.dataDetailsProduct
                                                          .company[0].profilePic
                                                          .toString()
                                                          : AppEndpoints
                                                          .baseUrlWithoutApi +
                                                          widget.dataDetailsProduct
                                                              .company[0]
                                                              .profilePic
                                                              .toString(),
                                                    ),
                                                  ));
                                            }
                                          }
                                        }
                                      },
                                      imageIcon: ImageConstant.imgChats,
                                      // width: isActiveWhatsapp ? 100.w : 160.w,
                                      width: 100.w,
                                      changeBackGround: widget.isOwnerCompany
                                          ? widget.isChats == true
                                          ? true
                                          : false
                                          : false,
                                    ),
                                  ),

                                  if (widget.isFromStore) ...{
                                    sizeWidthNormal(),
                                    Expanded(
                                        child: BlocConsumer<CartCubit, CartState>(
                                          listener: (context, state) {
                                            if (state is SuccessAddToCartState &&
                                                state.productId ==
                                                    widget.dataDetailsProduct.adsId!.toString()) {
                                              setState(() {
                                                _isAddingToCart = false;
                                              });
                                            }
                                          },
                                          builder: (context, state) {
                                            if (_isAddingToCart) {
                                              return CustomElevatedButton(
                                                  width: 100.w,
                                                  height: 25.h,
                                                  isDisabled: true,
                                                  buttonStyle: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.grey),
                                                      shape: MaterialStateProperty.all<
                                                          OutlinedBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(7.r),
                                                        ),
                                                      )),
                                                  text: "أضف إلى السلة",
                                                  buttonTextStyle: themeLite
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 10.fSize),
                                                  child: LoadingAnimationWidget
                                                      .threeRotatingDots(
                                                    color: Colors.white,
                                                    size: 25,
                                                  ));
                                            }

                                            int productId =
                                            int.parse(widget.dataDetailsProduct.adsId!.toString());
                                            bool isProductInCart =
                                                CartCubit.get(context).dataCart != null &&
                                                    CartCubit.get(context)
                                                        .dataCart!
                                                        .items
                                                        .any((item) =>
                                                    item.productId == productId);

                                            return isProductInCart
                                                ? itemButtonContainer(
                                              onTap: () {
                                                navigatorToPush(
                                                    context: context,
                                                    pageName: CartPage(
                                                      isShowBack: true,
                                                    ));
                                              },
                                              adStatus: widget.dataDetailsProduct.status,
                                              text: 'الذهاب إلى السلة',
                                              width: 100.w,
                                            )
                                                : itemButtonContainer(
                                              onTap: () {
                                                if (DIManager.findDep<SharedPrefs>()
                                                    .getToken() ==
                                                    null) {
                                                  navigatorToPush(
                                                      context: context,
                                                      pageName: LoginScreen());
                                                } else {
                                                  setState(() {
                                                    _isAddingToCart = true;
                                                  });
                                                  CartCubit.get(context).addToCart(
                                                    context,
                                                    productId: widget.dataDetailsProduct.adsId!
                                                        .toString(),
                                                    price: widget.dataDetailsProduct.finalPrice ??
                                                        widget.dataDetailsProduct.price
                                                            .toString(),
                                                    isNeedGetMyCart: true,
                                                  );
                                                }
                                              },
                                              adStatus: widget.dataDetailsProduct.status,
                                              text: 'أضف إلى السلة',
                                              changeBackGround: true,
                                              width: 100.w,
                                            );
                                          },
                                        )),
                                  },

                                  sizeWidthNormal(width: 4.w ),
                                  /// Whatsapp
                                  if (widget.dataDetailsProduct
                                      .company[0].is_have_whatsapp == '1') ...[
                                    widget.isOwnerCompany
                                        ? Expanded(
                                      child: itemButtonContainer(
                                        onTap: () {
                                          showNumberWhatsapp(
                                              context,
                                              int.parse(
                                                  widget.dataDetailsProduct.ad_id ?? '0'));
                                        },
                                        adStatus: '',
                                        text: 'واتساب',
                                        imageIcon: ImageConstant.iconWhatsapp,
                                        changeBackGround:
                                        widget.mobileNumber == 'null' ||
                                            widget.mobileNumber == '000'
                                            ? false
                                            : true,
                                      ),
                                    )
                                        : Expanded(
                                      child: itemButtonContainer(
                                        onTap: () {
                                          if (widget.dataDetailsProduct.mobile == null ||
                                              widget.dataDetailsProduct.mobile ==
                                                  '000' ||widget.dataDetailsProduct.mobile == "null") {
                                            showInfoCompany(
                                                context,
                                                'رقم الواتساب :',
                                                'لايتوفر رقم واتساب للشركة حتى الآن..');
                                          } else {
                                            HomeCubit.get(context)
                                                .changeStatusCounterForWhatsappShareChat(
                                                idAds: int.parse(widget.dataDetailsProduct.adsId!),
                                                type: 0);
                                            final Uri url = Uri.parse(
                                                'https://wa.me/${widget.dataDetailsProduct.mobile}');
                                            launchUrl(url,mode: LaunchMode.externalApplication);
                                          }
                                        },
                                        text: 'واتساب', adStatus: '',
                                        imageIcon: ImageConstant.iconWhatsapp,
                                      ),
                                    ),
                                  ]else...[
                                    Expanded(
                                      child: itemButtonContainer(
                                          onTap: () {

                                            if(widget.isOwnerCompany) {
                                              showInfoCompany(
                                                  context,
                                                  'رقم الواتساب :',
                                                  'لا يوجد اذن لإضافة الواتساب');
                                            } else{
                                              showInfoCompany(
                                                  context,
                                                  'رقم الواتساب :',
                                                  'لايتوفر رقم واتساب للشركة حتى الآن..');}

                                          },
                                          text: 'واتساب', adStatus: '',
                                          imageIcon: ImageConstant.iconWhatsapp,
                                          inactivation: true

                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              !widget.isOwnerCompany
                                  ? Container()
                                  : SizedBox(
                                height: 15.h,
                              ),
                              !widget.isOwnerCompany
                                  ? Container()
                                  : Row(
                                children: [
                                  Expanded(
                                    child: itemButtonContainerProductPage(
                                      width: 100.w,status: widget.dataDetailsProduct.status,
                                      onTap: () {
                                        showDeleteAds(context);
                                      },
                                      isDeleteAds: true,
                                      text: 'حذف',
                                      imageIcon: ImageConstant.iconDelete,
                                    ),
                                  ),
                                  sizeWidthNormal(),
                                  Expanded(
                                    child: itemButtonContainerProductPage(
                                      width: 150.w,
                                      onTap: () {
                                          BlocProvider.of<HomeCubit>(context).changeShowEditAds(!BlocProvider.of<HomeCubit>(context).isShowEditAds);
                                        // showBottomSheet(context);
                                      },
                                      status: widget.dataDetailsProduct.status,
                                      text: 'تعديل',
                                      imageIcon: ImageConstant.imgEdit,
                                      changeBackGround:
                                      BlocProvider.of<HomeCubit>(context).isShowEditAds ? true : false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ] else ...[
                          Column(
                            children: [
                              !widget.isOwnerCompany
                                  ? Container()
                                  : SizedBox(
                                height: 15.h,
                              ),
                             !widget.isOwnerCompany
                                  ? Container()
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  itemButtonContainerProductPage(
                                    onTap: () {
                                      showDeleteAds(context);
                                    },
                                    width: 100.w,
                                    isDeleteAds: true,
                                    status: widget.dataDetailsProduct.status,
                                    text: 'حذف',
                                    imageIcon: ImageConstant.iconDelete,
                                  ),
                                  itemButtonContainerProductPage(
                                    onTap: () {
                                      BlocProvider.of<HomeCubit>(context).changeShowEditAds(!BlocProvider.of<HomeCubit>(context).isShowEditAds);
                                    },
                                    status: widget.dataDetailsProduct.status,
                                    text: 'تعديل',
                                    width: 100.w,
                                    isDeleteAds: true,
                                    imageIcon: ImageConstant.imgEdit,
                                    changeBackGround: BlocProvider.of<HomeCubit>(context).isShowEditAds ? true : false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  sizeHeightNormal(),
                ],
              ),
            ),
          ),
        ),
        sizeHeightNormal(),
        ( !widget.isOwnerCompany||widget.dataDetailsProduct.status == '3'
        )
            ? Container()
            :
        EditAdWidget(
          dataDetailsProduct: widget.dataDetailsProduct,
          idBannerOrProduct: widget.idBannerOrProduct,
          isBannerInOut: widget.isBannerInOut,
          // isEditAds: isEditAds,
          type: widget.type,
        ),
      ],
    );
  }

  // bool isEditAds = false;
  bool isLoadingShareAds = false;
  Future<void> shareAds({
    required String nameAds,
    required String descriptionAds,
    required bool isBanner,
    required int idAdsAndBanner,
    required int idAdsProduct,
    required String idCompany,
    required String categoryId,
    required String imageUrl,
  }) async {
    try {
      setState(() {
        isLoadingShareAds = true;
      });

      String descriptionAdsUrl = 'الوصف: $descriptionAds\n';
      String urlShare =
          '${AppEndpoints.deepLinksUrl}/details/$idAdsAndBanner/$isBanner/$idCompany/$idAdsProduct/0/$categoryId';
      String textToShare = descriptionAdsUrl + urlShare;

      // التحقق من وجود صورة صحيحة
      if (imageUrl.isNotEmpty &&
          (imageUrl.endsWith('.jpg') ||
              imageUrl.endsWith('.jpeg') ||
              imageUrl.endsWith('.png') ||
              imageUrl.endsWith('.webp'))) {
        try {
          String filename = basename(imageUrl);
          Dio dio = Dio();
          Response response = await dio.get(
            imageUrl,
            options: Options(responseType: ResponseType.bytes),
          );

          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          File file = File('$tempPath/$filename.jpg');
          file.createSync();
          file.writeAsBytesSync(response.data);

          if (file.existsSync()) {
            await Share.shareXFiles([XFile(file.path)], text: textToShare);
          } else {
            // في حال لم تنجح تحميل الصورة
            await Share.share(textToShare);
          }
        } catch (e) {
          print("Image download failed: $e");
          await Share.share(textToShare); // مشاركة النص فقط
        }
      } else {
        // إذا لم تكن هناك صورة أو الرابط غير صحيح
        await Share.share(textToShare);
      }

      setState(() {
        isLoadingShareAds = false;
      });
    } catch (e) {
      setState(() {
        isLoadingShareAds = false;
      });
      print("Error in Share Ads : $e");
    }
  }



  void showRatingAds(BuildContext context, adsId,double? ratingValue) {
    HomeCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = ratingValue??0.0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: appTheme.buttonColor,
                title: textNormal(
                    text: 'قيّم الإعلان',
                    color: Colors.white,
                    fontSize: AppFontSize.fontSize_16),
                content: RatingBar(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  onRatingUpdate: (value) {
                    rating = value;
                  },
                  ratingWidget: RatingWidget(
                    full: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.sp,
                    ),
                    half: Icon(Icons.star_half, color: Colors.amber, size: 20.sp),
                    empty:
                    Icon(Icons.star_border, color: Colors.amber, size: 20.sp),
                  ),
                ),
                actions: [
                  InkWell(
                    child: textNormal(
                      text: 'إلغاء',
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  sizeWidthNormal(width: 2.w),
                  InkWell(
                    child: textNormal(text: 'تأكيّد'),
                    onTap: () async {
                      // Save the rating                        // and close the dialog box
                      Navigator.of(context).pop();

                      cubit.evaluateAds(
                          adsId: int.parse(adsId.toString()), value: rating);
                    },
                  ),
                ],
              );
            });
      },
    );
  }


  void showChats(BuildContext context, int adsId) {
    HomeCubit cubit = BlocProvider.of(context);
    String status = !widget.isChats ? 'تفعيل' : 'إيقاف';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0.0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey2,
                child: AlertDialog(
                  backgroundColor: appTheme.buttonColor,
                  title: Row(
                    children: [


                      Text(
                        'هل تريد $status الدردشة ؟',
                        style: themeLite.textTheme.titleSmall,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close,
                          color:Colors.white,),
                      ),

                    ],
                  ),

                  content: Container(
                    height: 80.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // cubit.changeVariable(isChangeChats: true);
                            cubit.activeChats(adsId: adsId);
                            Navigator.of(context).pop();
                          },
                          child: widget.loadingActiveChats
                              ? loaderNormal()
                              : Center(
                              child: Container(
                                width: 160.h,
                                height: 40.h,
                                decoration: AppDecoration.outlineSelectedLite
                                    .copyWith(
                                    borderRadius:
                                    BorderRadius.circular(30.h)),
                                child: Center(
                                  child:  textNormal(text: 'نعم'),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void showDeleteAds(BuildContext context) {
    HomeCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey2,
                child: AlertDialog(
                  backgroundColor: appTheme.buttonColor,


                  title: Row(
                    children: [

                      Text(
                        'هل أنت متأكد من حذف الإعلان ؟',
                        style: themeLite.textTheme.titleSmall,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close,
                          color:Colors.white,),
                      ),

                    ],
                  ),
                  content: Container(
                    height: 40.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                              child: Container(
                                width: 90.h,
                                height: 40.h,
                                decoration: AppDecoration.outlineSelectedLite.copyWith(
                                    borderRadius: BorderRadius.circular(30.h)),
                                child: Center(
                                  child: textNormal(text: 'إلغاء'),
                                ),
                              )),
                        ),
                        sizeWidthNormal(),
                        InkWell(
                          onTap: () {
                            // cubit.changeVariable(isChangeChats: true);
                            cubit.deleteAds(
                                adsId: widget.idBannerOrProduct!, type: widget.type);
                            Navigator.of(context).pop();
                          },
                          child: Center(
                              child: Container(
                                width: 90.h,
                                height: 40.h,
                                decoration: AppDecoration.outlineSelectedLite.copyWith(
                                    borderRadius: BorderRadius.circular(30.h)),
                                child: Center(
                                  child: textNormal(text: 'حذف'),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }


  TextEditingController? mobileNoController = TextEditingController();

  final FocusNode _thirdFocusNode1 = FocusNode();
  void showNumberWhatsapp(BuildContext context, adsId,) {
    HomeCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0.0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              String myString = widget.mobileNumber;
              String newString =
              widget.mobileNumber.length >= 11  && widget.mobileNumber.contains('971')? myString.substring(3) : '';
              return Form(
                key: _formKey2,
                child: AlertDialog(
                  backgroundColor: appTheme.buttonColor,
                  // title: Text(
                  //             'اختر طريقة تمميز إعلانك',
                  //             style: themeLite.textTheme.titleSmall,
                  //           ),

                  title: Row(
                    children: [

                      Text(
                        'رقم الواتساب',
                        style: themeLite.textTheme.titleSmall,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close,
                          color:Colors.white,),
                      ),

                    ],
                  ),
                  content: CustomTextFormField(
                    width: 208.h,
                    controller: mobileNoController,
                    fillColor: appTheme.whiteA700,
                    focusNode: _thirdFocusNode1,
                    hintText: (widget.mobileNumber == '000' || widget.mobileNumber == 'null')
                        ? "504501535"
                        : newString,
                    autofocus: false,
                    isMobile: true,
                    // alignment: Alignment.center,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.phone,
                    // focusNode: focusNode,

                    validator: (text) {
                      // if (text == null || text.isEmpty) {
                      //   return AppLocalizations.of(context)!.field_is_empty;
                      // }
                      if (text!.length > 10 || text.length < 9) {
                        return 'يرجى التأكد من الرقم';
                      }

                      return null;
                    },

                    textStyle: themeLite.textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.w300),

                    contentPadding: EdgeInsets.only(
                        left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        if (widget.mobileNumber == '000' || widget.mobileNumber == 'null') {
                          if (_formKey2.currentState!.validate()) {
                            widget.mobileNumber = '971${mobileNoController!.text}';
                            cubit.changeVariable(isChangeMobile: true);
                            cubit.editWhatsappMobile(
                                adsId: adsId, mobileWhatsapp: widget.mobileNumber);
                            Navigator.pop(context);
                          }
                        } else {
                          widget.mobileNumber = '';
                          mobileNoController!.text = '';
                          cubit.changeVariable(isChangeMobile: true);
                          cubit.editWhatsappMobile(
                              adsId: adsId, mobileWhatsapp: '000');
                          Navigator.pop(context);
                        }
                      },
                      child: Center(
                          child: Container(
                            width: 120.h,
                            height: 40.h,
                            decoration: AppDecoration.outlineSelectedLite
                                .copyWith(borderRadius: BorderRadius.circular(30.h)),
                            child: Center(
                              child: widget.mobileNumber == '000' || widget.mobileNumber == 'null'
                                  ? textNormal(
                                text: 'حفظ',
                              )
                                  : textNormal(text: 'إيقاف الواتساب'),
                            ),
                          )),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
