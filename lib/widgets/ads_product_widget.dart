import 'package:html_unescape/html_unescape.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/company/company_details_page.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../core/di/di_manager.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../core/utils/image_constant.dart';
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

  bool get _hasImage =>
      !(widget.dataProductItem!.imageNames.isEmpty ||
          widget.dataProductItem!.imageNames[0] == null ||
          widget.dataProductItem!.imageNames[0] == '');

  bool get _hasPrice {
    final price = widget.dataProductItem.price.toString();
    return price != '0.0' &&
        price != '0' &&
        price != '0.00' &&
        price != 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isFromDetailsProfile ? 0 : 12.w,
        vertical: widget.isFromDetailsProfile ? 0 : 6.h,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: LbeenaColors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (!widget.isStopNavigation &&
                          widget.dataProductItem?.company.isNotEmpty == true) {
                        navigatorToPush(
                            context: context,
                            pageName: CompanyDetailsPage(
                                idCompany:
                                    widget.dataProductItem!.company[0].id));
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: LbeenaColors.orange, width: 1.5),
                      ),
                      child: widget.dataProductItem?.company.isEmpty
                          ? const SizedBox.shrink()
                          : widget.dataProductItem?.company[0].profilePic
                                      .toString() ==
                                  'null'
                              ? CustomImageView(
                                  imagePath: ImageConstant.imgPerson,
                                  height: 38,
                                  width: 38,
                                  radius: BorderRadiusStyle.circleBorder20,
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  placeHolder: ImageConstant.imgPerson,
                                )
                              : CustomImageView(
                                  imagePath: widget
                                          .dataProductItem!.company[0].profilePic
                                          .toString()
                                          .contains('http')
                                      ? widget.dataProductItem!.company[0]
                                          .profilePic
                                          .toString()
                                      : AppEndpoints.baseUrlWithoutApi +
                                          widget.dataProductItem!.company[0]
                                              .profilePic
                                              .toString(),
                                  height: 38,
                                  width: 38,
                                  radius: BorderRadiusStyle.circleBorder20,
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  placeHolder: ImageConstant.imgPerson,
                                ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textNormal(
                            text: widget.dataProductItem!.company.isEmpty
                                ? ''
                                : widget.dataProductItem!.company[0]
                                        .companyName ??
                                    '',
                            fontSize: AppFontSize.fontSize_14,
                            fontWeight: FontWeight.w800,
                            color: LbeenaColors.black),
                        textNormal(
                            text: widget.dataProductItem!.acceptDate != null
                                ? getComparedTime(
                                        widget.dataProductItem?.acceptDate ??
                                            DateTime.now())
                                    .toString()
                                : '',
                            fontSize: AppFontSize.fontSize_11,
                            fontWeight: FontWeight.w500,
                            color: LbeenaColors.muted),
                      ],
                    ),
                  ),
                  if (widget.dataProductItem!.company.isNotEmpty &&
                      widget.dataProductItem!.company[0].account_type ==
                          'company') ...{
                    CustomImageView(
                      imagePath: ImageConstant.companiesIcon,
                      height: 16.h,
                      width: 16.h,
                      color: LbeenaColors.teal,
                    ),
                    sizeWidthNormal(width: 6.w),
                  },
                  if (widget.dataProductItem.isHave.toString() == '1')
                    CustomImageView(
                      imagePath: ImageConstant.pinIconNew1,
                      width: 18.w,
                      height: 18.w,
                    ),
                ],
              ),
            ),
            if (!widget.isVideo && widget.dataProductItem?.description != null)
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
                child: Text(
                  cleanHtmlText(widget.dataProductItem!.description),
                  maxLines: _hasImage ? 3 : 5,
                  overflow: TextOverflow.ellipsis,
                  style: themeLite.textTheme.bodySmall!.copyWith(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    color: LbeenaColors.black.withValues(alpha: 0.78),
                    height: 1.45,
                  ),
                ),
              )
            else if (widget.isVideo)
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
                child: Text(
                  widget.dataProductItem!.videoName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: themeLite.textTheme.bodySmall!.copyWith(
                    fontFamily: 'Cairo',
                    color: LbeenaColors.black,
                  ),
                ),
              ),
            if (_hasImage)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: widget.isVideo
                          ? AspectRatio(
                              aspectRatio: 1080 / 1350,
                              child: imageFromUrlVideo(
                                link: widget.dataProductItem!.videoLink
                                    .toString(),
                                onTap: () {},
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: 1080 / 1350,
                              child: CustomImageView(
                                imagePath: widget
                                        .dataProductItem!.imageNames[0]
                                        .toString()
                                        .contains('http')
                                    ? widget.dataProductItem!.imageNames[0]
                                    : AppEndpoints.baseUrlWithoutApi +
                                        widget.dataProductItem!.imageNames[0],
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                radius: BorderRadius.circular(14.r),
                              ),
                            ),
                    ),
                    if (_hasPrice)
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: _priceBadge(),
                      ),
                  ],
                ),
              )
            else if (_hasPrice)
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 4.h),
                child: _priceBadge(),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Row(
                children: [
                  if ((widget.dataProductItem!.categoryName ?? '').isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: LbeenaColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: textNormal(
                        text: widget.dataProductItem!.categoryName ?? '',
                        fontSize: AppFontSize.fontSize_10,
                        color: LbeenaColors.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const Spacer(),
                  if (widget.dataProductItem!.city_name.toString() != 'null')
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: LbeenaColors.orange,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          widget.dataProductItem!.city_name.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: themeLite.textTheme.labelMedium!.copyWith(
                            color: LbeenaColors.muted,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
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
  }

  Widget _priceBadge() {
    final hasDiscount = widget.dataProductItem.finalPrice != null &&
        double.parse(widget.dataProductItem.finalPrice.toString()).toString() !=
            double.parse(widget.dataProductItem.price.toString()).toString();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: LbeenaColors.orange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LbeenaColors.orange.withValues(alpha: 0.28),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.dataProductItem.finalPrice == null || !hasDiscount)
            Text(
              '${widget.dataProductItem.price} درهم',
              style: themeLite.textTheme.titleSmall!.copyWith(
                color: LbeenaColors.white,
                fontFamily: 'Cairo',
                fontSize: AppFontSize.fontSize_13,
                fontWeight: FontWeight.w800,
              ),
            )
          else ...[
            Text(
              '${widget.dataProductItem.price}',
              style: themeLite.textTheme.titleSmall!.copyWith(
                color: LbeenaColors.white.withValues(alpha: 0.8),
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                fontSize: AppFontSize.fontSize_11,
                decoration: TextDecoration.lineThrough,
                decorationColor: LbeenaColors.white,
              ),
            ),
            sizeWidthNormal(width: 4.w),
            Text(
              '${double.parse(widget.dataProductItem.finalPrice.toString())} درهم',
              style: themeLite.textTheme.titleSmall!.copyWith(
                color: LbeenaColors.white,
                fontFamily: 'Cairo',
                fontSize: AppFontSize.fontSize_13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String getComparedTime(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    final List prefix = [
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
  String formattedDate =
      DateFormat('MMM dd, yyyy hh:mm a').format(dateTimeString);
  return formattedDate;
}
