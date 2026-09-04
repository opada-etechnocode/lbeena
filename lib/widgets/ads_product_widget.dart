import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:syrians_in_uae/core/constants/app_colors.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/company/company_details_page.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../core/di/di_manager.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../core/utils/image_constant.dart';
import '../ui/screens/details_product/details_product.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/lbeena_colors.dart';
import '../ui/theme/theme_helper.dart';
import 'custom_image_view.dart';

// ignore: must_be_immutable
class AdsProductWidget extends StatefulWidget {
  AdsProductWidget(
      {Key? key, this.dataProductItem,
        this.isFromEvaluation = false,
        this.isStopNavigation = false,
        this.isFromDetailsProfile = false,
      this.isVideo =false})
      : super(
          key: key,
        );
  dynamic dataProductItem;
  bool isFromEvaluation = false;
  bool isFromDetailsProfile = false;
  bool isStopNavigation = false;
  bool isVideo = false;

  @override
  State<AdsProductWidget> createState() => _AdsProductWidgetState();
}

class _AdsProductWidgetState extends State<AdsProductWidget> {
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();
  final unescape = HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    // print(widget.dataProductItem!.company[0].id);
    String? color = widget
        .dataProductItem.background_color
        ?.replaceRange(0, 1, '0xff');
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:widget.isFromDetailsProfile?0: 20,vertical:widget.isFromDetailsProfile?0: 5),
      child: Neumorphic(
        style: getNeumorphicStyle().copyWith(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18.r)),
          shadowLightColor:purpleShadowColor.withOpacity(1),
          shadowDarkColor: purpleShadowColor.withOpacity(0.4),
          color: appTheme.lightBlue100,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            // height: 182.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color:widget
                    .dataProductItem.background_color == null || widget
                    .dataProductItem.background_color == "null"?appTheme.lightBlue100 :Color((int.parse(color!))),
                borderRadius: BorderRadius.circular(1.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.all(10.sp
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(bottom: 4.h),
                          child: Container(
                            height: 30.fSize,
                            width: 30.fSize,
                            decoration: AppDecoration.outlineWhiteA700,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 30.fSize, width: 30.fSize,
                                  decoration: AppDecoration.outlineCircular3.copyWith(color: Colors.white),
                                  // color: AppColorsController().defaultPrimaryColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    if(!widget.isStopNavigation){
                                      navigatorToPush(
                                          context: context,
                                          pageName: CompanyDetailsPage(
                                              idCompany: widget.dataProductItem!
                                                  .company[0].id));
                                    }

                                  },
                                  child:widget.dataProductItem?.company.isEmpty ?Container(): widget.dataProductItem?.company[0].profilePic.toString() == 'null'
                                      ? CustomImageView(
                                    imagePath:ImageConstant.imgPerson,
                                    height: 24.h,
                                    width: 24.h,
                                    radius: BorderRadiusStyle.circleBorder20,
                                    alignment: Alignment.center,
                                    // fit: BoxFit.cover,
                                    color: appTheme.greenColor,
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
                                    height: 30.fSize,
                                    width: 30.fSize,
                                    radius: BorderRadiusStyle.circleBorder20,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    placeHolder: ImageConstant.imgPerson,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            textNormal(
                                text: widget.dataProductItem!.company.isEmpty ?'': widget.dataProductItem!.company[0].companyName ?? '',
                                fontSize: AppFontSize.fontSize_15,
                                fontWeight: FontWeight.bold),
                            // SizedBox(
                            //   height: 5.sp,
                            // ),s
                            textNormal(
                                text: widget.dataProductItem!.acceptDate != null?  getComparedTime(widget.dataProductItem?.acceptDate ??
                                    DateTime.now())
                                    .toString() :'',
                                // color: AppColorsController().black900,
                                fontSize: AppFontSize.fontSize_11,
                                fontWeight: FontWeight.w300),
                          ],
                        ),
                        Spacer(),
                        if(widget.dataProductItem!.company.isNotEmpty && widget.dataProductItem!.company[0].account_type =='company')...{
                          CustomImageView(
                            imagePath: ImageConstant.companiesIcon,
                            height:  18.h,
                            width:  18.h,
                            color: appTheme.greenColor,
                          ),
                          sizeWidthNormal()
                        },
                        widget.dataProductItem.isHave.toString() == '1'
                            ?
                        // Stack(
                        //       alignment: Alignment.center,
                        //       children: [
                        //         Icon(
                        //           Icons.star,
                        //           color: Colors.black,
                        //           size: 20.sp,
                        //         ),
                        //         Icon(
                        //           Icons.star,
                        //           color: Colors.amber,
                        //           size: 15.sp,
                        //         ),
                        //       ],
                        //     )
                        //
                        CustomImageView(
                          imagePath: ImageConstant.pinIconNew1,
                          width: 20.w,
                          height: 20.w,
                        )
                            : Container(),
                      ],
                    ),
                      // SizedBox(
                      //   height: 8.h,
                      // ),


                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin:( widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')? EdgeInsets.only(top: 5.h):EdgeInsets.symmetric(vertical: 10.h),
                        child:  !widget.isVideo
                            ?widget.dataProductItem?.description==null?Container(): Text( cleanHtmlText( widget.dataProductItem!.description),
                                maxLines: widget.dataProductItem!.imageNames.isEmpty||widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == ''?5:4,
                                overflow: TextOverflow.ellipsis,
                                style: themeLite.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w400
                                ),
                              )
                            : Text(
                                widget.dataProductItem!.videoName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: themeLite.textTheme.bodySmall,
                              ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          if(widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')...{
                            Container()
                          }else...{
                            !widget.isVideo?   AspectRatio(
                              aspectRatio: 1080 / 1350,
                              child: Container(
                                height: 250.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(2.r),
                                        topRight: Radius.circular(2.r)
                                    )),
                                child: CustomImageView(
                                  imagePath: widget.dataProductItem!.imageNames[0]
                                      .toString()
                                      .contains('http')
                                      ? widget.dataProductItem!.imageNames[0]
                                      : AppEndpoints.baseUrlWithoutApi +
                                      widget.dataProductItem!.imageNames[0],
                                  // imagePath: '${ImageConstant.imagePath}/1.PNG',
                                  height: 130.fSize,
                                  width: 180.w,
                                  fit: BoxFit.cover,
                                  radius: BorderRadius.circular(10.r),
                                  // alignment: Alignment.center,
                                ),
                              ),
                            ):
                            AspectRatio(
                              aspectRatio: 1080 / 1350,
                              child: Container(
                                height: 120.h,
                                width: 180.w,
                                child: imageFromUrlVideo(
                                    link:widget.dataProductItem!.videoLink.toString()
                                    ,
                                    onTap: (){
                                      // navigatorToPush(
                                      //     context: context,
                                      //     pageName: UrlWebViewPage(
                                      //       titleAppBer: video!.videoName.toString(),
                                      //       urlPage: video!.videoLink.toString(),
                                      //     ));
                                    }
                                ),
                              ),
                            ),
                          },
                          widget.dataProductItem.price.toString() == '0.0' ||
                              widget.dataProductItem.price.toString() == '0' ||
                              widget.dataProductItem.price.toString() == '0.00' ||
                              widget.dataProductItem.price.toString() == 'null'
                              ? Container()
                              : Container(
                            // width:widget.dataProductItem.price.toString().length >6?200.w: 120.w,
                            decoration: ( widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')?null: AppDecoration.outlineButton.copyWith(
                              borderRadius: BorderRadius.circular(2.r),
                              color: LbeenaColors.white.withOpacity(0.92),
                              boxShadow: [
                              ],
                            ),
                                child: Padding(
                                                          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
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
                                              : Colors.black, fontSize: AppFontSize.fontSize_14,
                                          fontWeight: FontWeight.w400),
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
                                              : Colors.black,fontSize: AppFontSize.fontSize_14,
                                          fontWeight: FontWeight.w400),
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
                                            : Colors.indigo,
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppFontSize.fontSize_14,
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
                                            : Colors.black, fontSize: AppFontSize.fontSize_14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  },


                                ],
                                                          ),
                                                        ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),



                Container(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                    child: Row(
                      children: [

                        Spacer(),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 13.w),
                          child: textNormal(text: widget.dataProductItem!.categoryName ?? '',
                              fontSize: AppFontSize.fontSize_10,color: appTheme.black900,
                              fontWeight: FontWeight.w500),
                        ),

                        widget.dataProductItem!.city_name.toString() == "null"?Container():   Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // sizeWidthNormal(width: 10.w),
                            CustomImageView(
                              imagePath: ImageConstant.imgLinkedin,
                              height: 13.h,
                              width: 10.w,
                              color:   appTheme.black900,
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(
                                left: 4.w, right: 4.w,
                                // bottom: 10.v,
                              ),
                            ),

                            Container(
                              // width:  widget.dataProductItem!.city_name.toString().length> 6?70.w:30.w,
                              child: Text(
                                widget.dataProductItem!.city_name.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: themeLite.textTheme.labelMedium!.copyWith(color: appTheme.black900,fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                )
                // sizeHeightNormal(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
