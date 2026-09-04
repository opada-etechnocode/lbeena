import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../auth/login/login_screen.dart';
import '../../cart/cart_page.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../../company/company_details_page.dart';

// ignore: must_be_immutable
class CardAdsStoreWidget extends StatefulWidget {
  CardAdsStoreWidget(
      {Key? key, this.dataProductItem, this.isFromEvaluation = false,
        this.width})
      : super(
    key: key,
  );
  dynamic dataProductItem;
  bool isFromEvaluation = false;
  double? width;

  @override
  State<CardAdsStoreWidget> createState() => _CardAdsStoreWidgetState();
}

class _CardAdsStoreWidgetState extends State<CardAdsStoreWidget> {
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        // height: 182.h,
        width: widget.width??185.w,
        decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(
              //   color: appTheme.lightBlue100,
              //   spreadRadius: 2,
              //   blurRadius: 6,
              //   offset: Offset(
              //     0,
              //     0,
              //   )
              // ),
            ],
            // border: Border.all(color: appTheme.lightBlue200),
            color: appTheme.whiteA700,
            borderRadius: BorderRadius.circular(7.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          // alignment: Alignment.bottomLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 140.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.r),
                              topRight: Radius.circular(7.r))),
                      child: CustomImageView(
                        imagePath: widget.dataProductItem!.imageNames[0]
                            .toString()
                            .contains('http')
                            ? widget.dataProductItem!.imageNames[0]
                            :
                        AppEndpoints.baseUrlWithoutApi +
                            widget.dataProductItem!.imageNames[0],
                        // imagePath: '${ImageConstant.imagePath}/1.PNG',
                        height: 120.h,
                        width: 180.w,
                        fit: BoxFit.cover,
                        radius: BorderRadius.only(
                            topLeft: Radius.circular(7.r),
                            topRight: Radius.circular(7.r)),
                        // alignment: Alignment.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 33.h, left: 3.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.h,
                            decoration: AppDecoration.outlineWhiteA700,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 40.h, width: 40.h,
                                  decoration: AppDecoration.outlineCircular3.copyWith(color: Colors.white),
                                  // color: AppColorsController().defaultPrimaryColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    // print('Id Company: ${widget.dataProductItem!.company[0].id}');
                                    userId ==
                                        widget.dataProductItem!.company[0].id
                                            .toString()
                                        ? null
                                        : navigatorToPush(
                                        context: context,
                                        pageName: CompanyDetailsPage(
                                            idCompany: widget.dataProductItem!
                                                .company[0].id));
                                  },
                                  child: widget.dataProductItem!.company == null
                                      ? CustomImageView(
                                    imagePath: widget.dataProductItem!.company[0]
                                        .profilePic
                                        .toString().contains('http')?widget.dataProductItem!.company[0]
                                        .profilePic
                                        .toString(): AppEndpoints.baseUrlWithoutApi +
                                        widget.dataProductItem!.company[0]
                                            .profilePic
                                            .toString(),
                                    height: 37.h,
                                    width: 37.h,
                                    radius: BorderRadiusStyle.circleBorder20,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    placeHolder: ImageConstant.imgPerson,
                                  )
                                      : CustomImageView(
                                    imagePath: widget.dataProductItem!.company[0]
                                        .profilePic
                                        .toString().contains('http')?widget.dataProductItem!.company[0]
                                        .profilePic
                                        .toString(): AppEndpoints.baseUrlWithoutApi +
                                        widget.dataProductItem!.company[0]
                                            .profilePic
                                            .toString(),
                                    height: 37.h,
                                    width: 37.h,
                                    radius: BorderRadiusStyle.circleBorder20,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    placeHolder: ImageConstant.imgPerson,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          widget.dataProductItem.price.toString() == '0.0' ||
                              widget.dataProductItem.price.toString() == '0' ||
                              widget.dataProductItem.price.toString() == '0.00' ||
                              widget.dataProductItem.price.toString() == 'null'
                              ? Container()
                              : Padding(
                                padding:  EdgeInsets.only(bottom: 5.h),
                                child: Container(
                                                            decoration: AppDecoration.cardPrice.copyWith(
                                                            ),
                                  child: Padding(
                                    padding:  EdgeInsets.all(2.h),
                                    child: Row(
                                      children: [

                                        if (widget.dataProductItem.finalPrice == null) ...{
                                          Text(
                                            "${widget.dataProductItem.price.toString()} درهم ",
                                            style: themeLite.textTheme.titleSmall!
                                                .copyWith(
                                                color:
                                                DIManager.findDep<SharedPrefs>()
                                                    .getThemeApp() ==
                                                    'd'
                                                    ? Colors.white
                                                    : Colors.black, fontSize: AppFontSize.fontSize_12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        } else ...{
                                          double.parse(widget.dataProductItem.finalPrice.toString())
                                              .toString() ==
                                              double.parse(
                                                  widget.dataProductItem.price.toString())
                                                  .toString()
                                              ? Text(
                                            "${widget.dataProductItem.price.toString()} درهم ",
                                            style: themeLite.textTheme.titleSmall!
                                                .copyWith(
                                                color: DIManager.findDep<
                                                    SharedPrefs>()
                                                    .getThemeApp() ==
                                                    'd'
                                                    ? Colors.white
                                                    : Colors.black,fontSize: AppFontSize.fontSize_12,
                                                fontWeight: FontWeight.bold),
                                          )
                                              : Text(
                                            "${widget.dataProductItem.price.toString()} ",
                                            style: themeLite.textTheme.titleSmall!
                                                .copyWith(
                                              color:  DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getThemeApp() ==
                                                  'd'
                                                  ?Colors.orangeAccent
                                                  : Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: AppFontSize.fontSize_12,
                                              decoration:
                                              TextDecoration.lineThrough,
                                              decorationColor: DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getThemeApp() ==
                                                  'd'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          sizeWidthNormal(width: 4.w),
                                          double.parse(widget.dataProductItem.finalPrice.toString())
                                              .toString() ==
                                              double.parse(
                                                  widget.dataProductItem.price.toString())
                                                  .toString()
                                              ? Container()
                                              : Text(
                                            "${double.parse(widget.dataProductItem.finalPrice.toString()).toString()} درهم ",
                                            style: themeLite.textTheme.titleSmall!
                                                .copyWith(
                                              color: DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getThemeApp() ==
                                                  'd'
                                                  ? Colors.white
                                                  : Colors.black, fontSize: AppFontSize.fontSize_12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        },

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                    widget.dataProductItem.isHave.toString() == '1'
                        ? Positioned(
                      right:widget.width !=null? 125.w: 140.w,
                      bottom: isIpad(context)?80.h: 100.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 20.sp,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    )
                        : Container(),
                  ],
                ),
              sizeHeightNormal(height: 2.h),
                Container(
                  width: 150.w,
                  margin: EdgeInsets.only(
                    left: 13.w, right: 13.w,
                    // bottom: 25.v,
                  ),
                  child:  Text(
                    widget.dataProductItem!.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: themeLite.textTheme.bodySmall,
                  ),
                ),
              ],
            ),

            Center(
              child: textNormal(
                  text: widget.dataProductItem!.acceptDate != null
                      ? formatDateTime(widget.dataProductItem!.acceptDate ??
                      DateTime.now())
                      .toString()
                      : "",
                  fontSize: AppFontSize.fontSize_10,
                  fontWeight: FontWeight.w200),
            ),

            Spacer(),
            Center(
              child: BlocConsumer<CartCubit, CartState>(
                listener: (context, state) {
                  if (state is SuccessAddToCartState &&
                      state.productId == widget.dataProductItem.adsId.toString()) {
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
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.r),
                              ),
                            )),
                            text: "أضف إلى السلة",
                            buttonTextStyle: themeLite.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontSize: 12.fSize),
                            child: LoadingAnimationWidget.threeRotatingDots(
                              color: Colors.white,
                              size: 25,
                                ));
                        }

                        int productId = int.parse(widget.dataProductItem.adsId!.toString());
                  bool isProductInCart = CartCubit.get(context).dataCart != null &&
                  CartCubit.get(context).dataCart!.items.any((item) =>
                  item.productId == productId);

                  return isProductInCart
                  ? itemButtonContainer(
                  onTap: () {
                  navigatorToPush(context: context, pageName: CartPage(isShowBack: true,));
                  },
                  adStatus: widget.dataProductItem.status,
                  text: 'الذهاب إلى السلة',
                  width: 100.w,
                  )
                      : itemButtonContainer(
                  onTap: () {
                    if(DIManager.findDep<SharedPrefs>().getToken() ==null){

                      navigatorToPush(context: context, pageName: LoginScreen());
                    }else{

                      setState(() {
                        _isAddingToCart = true;
                      });
                      CartCubit.get(context).addToCart(
                        context,
                        productId: widget.dataProductItem.adsId!.toString(),
                        price: widget.dataProductItem.finalPrice ??
                            widget.dataProductItem.price.toString(),
                        isNeedGetMyCart: true,
                      );
                    }

                  },
                  adStatus: widget.dataProductItem.status,
                  text: 'أضف إلى السلة',
                  changeBackGround: true,
                  width: 100.w,
                  );
                },
              ),
            ),
            sizeHeightNormal(height: 5.h),
          ],
        ),
      ),
    );
  }
  bool _isAddingToCart = false;

  String getComparedTime(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    final List prefix = [
      // translate("just now"),
      // translate("second(s)"),
      // translate("minute(s)"),
      // translate("hour(s)"),
      // translate("day(s)"),
      // translate("month(s)"),
      // translate("year(s)")
      'الآن',
      'ثواني',
      'دقائق',
      'ساعات',
      'أيام',
      'أشهر',
      'سنوات',
    ];
    if (difference.inDays == 0) {
      if (difference.inMinutes == 0) {
        if (difference.inSeconds < 20) {
          return (prefix[0]);
        } else {
          return ("${difference.inSeconds} ${prefix[1]}");
        }
      } else {
        if (difference.inMinutes > 59) {
          return ("${(difference.inMinutes / 60).floor()} ${prefix[3]}");
        } else {
          return ("${difference.inMinutes} ${prefix[2]}");
        }
      }
    } else {
      if (difference.inDays > 30) {
        if (((difference.inDays) / 30).floor() > 12) {
          return ("${((difference.inDays / 30) / 12).floor()} ${prefix[6]}");
        } else {
          return ("${(difference.inDays / 30).floor()} ${prefix[5]}");
        }
      } else {
        return ("${difference.inDays} ${prefix[4]}");
      }
    }
  }
}

String formatDateTime(DateTime dateTimeString) {
  // DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate =
  DateFormat('MMM dd, yyyy hh:mm a').format(dateTimeString);
  return formattedDate;
}
