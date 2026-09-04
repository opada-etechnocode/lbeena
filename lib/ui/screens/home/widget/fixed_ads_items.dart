import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:syrians_in_uae/core/constants/app_colors.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/company/company_details_page.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

import '../../../theme/theme_helper.dart';

// ignore: must_be_immutable
class FixedAdsItems extends StatefulWidget {
  FixedAdsItems(
      {Key? key, this.dataProductItem,
        this.isFromEvaluation = false,
        this.isStopNavigation = false,
        this.isVideo =false})
      : super(
    key: key,
  );
  dynamic dataProductItem;
  bool isFromEvaluation = false;
  bool isStopNavigation = false;
  bool isVideo = false;

  @override
  State<FixedAdsItems> createState() => _FixedAdsItemsState();
}

class _FixedAdsItemsState extends State<FixedAdsItems> {
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();
  final unescape = HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    // print(widget.dataProductItem!.company[0].id);
    String? color = widget
        .dataProductItem.background_color
        ?.replaceRange(0, 1, '0xff');
    return Padding(
      padding:  EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          // height: 182.h,

          width: 200,
          decoration: BoxDecoration(
              color:widget
                  .dataProductItem.background_color == null || widget
                  .dataProductItem.background_color == "null"?appTheme.backgroundContainer :Color((int.parse(color!))),
              boxShadow: [
                BoxShadow(
                  color: appTheme.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding:  EdgeInsets.all(8
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// information user
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(bottom: 4.h),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: AppDecoration.outlineWhiteA700,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 30, width: 30,
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
                                    height: 24,
                                    width: 24,
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
                                    height: 30,
                                    width: 30,
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
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:100,
                              child: textNormal(
                                // text: '21321312321321321321321312321312321312321',
                                  text: widget.dataProductItem!.company.isEmpty ?'': widget.dataProductItem!.company[0].companyName ?? '',
                                  fontSize: AppFontSize.fontSize_12,
                                  fontWeight: FontWeight.bold),
                            ),
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
                            width: 15,
                            height:  15,
                            color: appTheme.greenColor,
                          ),
                          sizeWidthNormal()
                        },
                        widget.dataProductItem.isHave.toString() == '1'
                            ?Icon(Icons.star, color: Colors.amber, size: 15,)
                            : Container(),
                      ],
                    ),

      sizeHeightNormal(height: 5),

                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        if(widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')...{
                          Container()
                        }else...{
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: CustomImageView(
                              imagePath: widget.dataProductItem!.imageNames[0]
                                  .toString()
                                  .contains('http')
                                  ? widget.dataProductItem!.imageNames[0]
                                  : AppEndpoints.baseUrlWithoutApi +
                                  widget.dataProductItem!.imageNames[0],
                              // imagePath: '${ImageConstant.imagePath}/1.PNG',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              radius: BorderRadius.circular(10),
                              // alignment: Alignment.center,
                            ),
                          )
                        },
                        widget.dataProductItem.price.toString() == '0.0' ||
                            widget.dataProductItem.price.toString() == '0' ||
                            widget.dataProductItem.price.toString() == '0.00' ||
                            widget.dataProductItem.price.toString() == 'null'
                            ? Container()
                            : Container(
                          // width:widget.dataProductItem.price.toString().length >6?200.w: 120.w,
                          decoration: ( widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')?null: AppDecoration.outlineButton.copyWith(
                            borderRadius: BorderRadius.circular(2),
                            color: LbeenaColors.white.withOpacity(0.92),
                            boxShadow: [
                            ],
                          ),
                          child: Padding(
                            padding:( widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')? EdgeInsets.zero:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
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
                                  sizeWidthNormal(width: 4),
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  // margin:( widget.dataProductItem!.imageNames.isEmpty|| widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == '')? EdgeInsets.only(top: 5.h):EdgeInsets.symmetric(vertical: 5.h),
                  child:  widget.dataProductItem?.description==null?Container(): Text( cleanHtmlText( widget.dataProductItem!.description),
                    maxLines: widget.dataProductItem!.imageNames.isEmpty||widget.dataProductItem!.imageNames[0] == null || widget.dataProductItem!.imageNames[0] == ''?8:2,
                    overflow: TextOverflow.ellipsis,
                    style: themeLite.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),

            Spacer(),

                Container(
                  width: double.infinity,
                  child: Row(
                    children: [


                      widget.dataProductItem!.city_name.toString() == "null"?Container():   Expanded(
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // sizeWidthNormal(width: 10.w),
                            CustomImageView(
                              imagePath: ImageConstant.imgLinkedin,
                              height: 13,
                              width: 10,
                              color:   appTheme.black900,
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(
                                left: 4, right: 4,
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
                      ),

                      Spacer(),
                      textNormal(text: widget.dataProductItem!.categoryName ?? '',
                          fontSize: AppFontSize.fontSize_10,color: appTheme.black900,
                          fontWeight: FontWeight.w500),

                      // Spacer(),
                      // textNormal(
                      //     text: widget.dataProductItem!.acceptDate != null?  getComparedTime(widget.dataProductItem?.acceptDate ??
                      //         DateTime.now())
                      //         .toString() :'',
                      //     // color: AppColorsController().black900,
                      //     fontSize: AppFontSize.fontSize_11,
                      //     fontWeight: FontWeight.w300),
                      // sizeWidthNormal()
                    ],
                  ),
                ),
                sizeHeightNormal(height: 5),
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
