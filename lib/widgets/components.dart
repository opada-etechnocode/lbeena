import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/home_page/banner_product_model.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/app_bar/appbar_screens.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/top_curved_item.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:syrians_in_uae/widgets/view_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_font.dart';
import '../core/di/di_manager.dart';
import '../core/helper/snack_bar_helper.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../core/utils/endpoints.dart';
import '../core/utils/image_constant.dart';
import '../data/models/company/activity_company_model.dart';
import '../data/models/company/company_model.dart';
// import '../l10n/app_localizations.dart';
import '../ui/screens/auth/login/login_screen.dart';
import '../ui/theme/lbeena_colors.dart';
import '../ui/screens/auth/login/model_home_page.dart';
import '../ui/screens/company/company_details_page.dart';
import '../ui/screens/details_product/details_product.dart';
import '../ui/screens/news/components/news_card.dart';
import '../ui/screens/news/news_list_screen.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/lbeena_colors.dart';
import 'ads_product_widget.dart';
import 'custom_elevated_button.dart';

import 'dart:ui' as ui;

import 'custom_text_form_field.dart';
import 'package:rxdart/rxdart.dart';

Future<Object?> navigatorToPush({required context, required pageName}) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => pageName));
}

Widget checkBoxIcon(
    {required void Function()? onPressed,
    required String text,
    required bool isChecked}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: textNormal(
      text: text,
      fontSize: AppFontSize.fontSize_11,
    ),
  );
}

String colorWithoutHashtag(String colors) {
  return colors.replaceAll('#', '');
}

Widget buildTimerWidget({
  required String nameDate,
  required String name,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 6.w),
    child: Column(
      children: [
        Container(
          width: 25.w,
          height: 25.h,
          decoration: AppDecoration.outlineTimer,
          child: Center(
            child: textNormal(
                text: nameDate,
                color: appTheme.black900,
                fontSize: AppFontSize.fontSize_10),
          ),
        ),
        sizeHeightNormal(height: 5.h),
        textNormal(text: name, fontSize: AppFontSize.fontSize_10),
      ],
    ),
  );
}


String getComparedTimeTow(DateTime finishedAt, String createdAd) {
  print(createdAd);
  print(finishedAt);
  Duration difference =
  DateTime.parse(finishedAt.toString()).difference(DateTime.now());
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
        // return ("${(difference.inDays / 30).floor()} ${prefix[5]}");
        return ("${difference.inDays} ${prefix[4]}");
      }
    } else {
      return ("${difference.inDays} ${prefix[4]}");
    }
  }
}

String getComparedTime(
    DateTime dateTime,
    ) {
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

  // حساب الفرق بين التاريخ الحالي والتاريخ المُدخل
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
    if (difference.inDays < 365) {
      if (difference.inDays < 30) {
        return ("${difference.inDays} ${prefix[4]}");
      } else {
        if (difference.inDays > 30 && difference.inDays < 365) {
          return ("${(difference.inDays / 30).floor()} ${prefix[5]}");
        }
      }
    } else {
      // إذا كانت الفترة أكثر من سنة
      final date = DateTime.now().add(difference);
      return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
    }
  }

  // Ensure a return value if no condition is met (though unlikely)
  return ''; // You can change this to throw an exception if necessary
}
String cleanHtmlText(String htmlText) {
  // أولاً نفك ترميز الرموز الخاصة
  final unescape = HtmlUnescape();
  String decoded = unescape.convert(htmlText);

  // ثم نزيل وسوم HTML
  final RegExp tagRegExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  return decoded.replaceAll(tagRegExp, '').trim();
}


String generateCoupon({int length = 7}) {
  final random = Random();
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // يمكنك إضافة المزيد من الرموز حسب الحاجة
  String coupon = '';

  for (int i = 0; i < length; i++) {
    coupon += characters[random.nextInt(characters.length)];
  }

  return coupon;
}

Widget itemButtonContainerProductPage({
  required String text,
  required String imageIcon,
  required void Function()? onTap,
  double? width,
  bool changeBackGround = false,
  bool isDeleteAds = false,
  bool inactivation = false,
  bool isLoading = false,
  required String status  ,
}) {
  return (status == '3' && !isDeleteAds) || inactivation
      ? Container(
    height: 38.h,
    width: width ?? 100.w,
    decoration: AppDecoration.outlineButtonLite
        .copyWith(color: Colors.grey, boxShadow: []),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textNormal(text: text),
        SizedBox(
          width: 8.w,
        ),
        CustomImageView(
          imagePath: imageIcon,
          color: Colors.white,
          height: 24.h,
          width: 24.h,
        ),
        // iconSvg(iconSvg: imageIcon),
      ],
    ),
  )
      : InkWell(
    onTap: isLoading ? () {} : onTap,
    child: Container(
      height: 30.h,
      width: width ?? 100.w,
      decoration: AppDecoration.itemCartNew.copyWith(
          color: changeBackGround ? Colors.green : appTheme.whiteA700,
          boxShadow: []),
      child: isLoading
          ? LoadingAnimationWidget.fourRotatingDots(
          color: Colors.black, size: 20.sp)
          : Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textNormal(text: text, fontSize: 10.fSize),
          SizedBox(
            width: 8.w,
          ),
          CustomImageView(
            imagePath: imageIcon,
            color: changeBackGround
                ? Colors.white70
                : appTheme.deepPurpleA100,
            height: 15.h,
            width: 15.h,
          ),
          // iconSvg(iconSvg: imageIcon),
        ],
      ),
    ),
  );
}

Future<void> showChoiceDialog(
  BuildContext context, {
  required Function()? onTapGallery,
  required Function()? onTapCamera,
}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  onTap: onTapGallery,
                  title: textNormal(text:'Gallery'),
                  leading: Icon(
                    Icons.image_sharp,
                    color: AppColorsController().primaryColor,
                  ),
                ),
                Divider(
                  height: 1,
                  color: AppColorsController().primaryColor,
                ),
                ListTile(
                  onTap: onTapCamera,
                  title: textNormal(text:'Camera'),
                  leading: Icon(
                    Icons.camera,
                    color: AppColorsController().primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

bool isURLValid(String url) {
  final RegExp urlRegExp = RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
  return urlRegExp.hasMatch(url);
}

Future<Object?> navigatorToPushReplacementUntilAddAds(
    {required context, required Widget pageName}) {
  return Navigator.of(context, rootNavigator: true)
      .pushReplacement(MaterialPageRoute(builder: (context) => pageName));
}

DateTime parseDateTime(String dateTimeString) {
  final dateFormat = DateFormat("MMMM d, yyyy 'at' hh:mm:ss a 'UTC'XXX");
  return dateFormat.parse(dateTimeString, true).toLocal();
}

String formatDate(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate(); // تحويل Timestamp إلى DateTime
  final outputFormat = DateFormat("yyyy-MM-dd");
  return outputFormat.format(dateTime);
}

navigatorToPushReplacementUntil(
    {required BuildContext context,
    required String location,
    Object? extra}) async {
  return   context.pushReplacement(location,extra:extra );
}

Future<Object?> navigatorToPushReplacement(
    {required context, required pageName}) {
  return Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => pageName),
  );
}


Future<Object?> navigatorToPushAndRemoveUntil({
  required BuildContext context,
  required Widget pageName,
}) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => pageName),
        (route) => false,
  );
}

Future<void> setDataHomePage(HomePageLoginModel model) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString('homePageData', jsonString);
    print('Save Data Success');
  } catch (error,stack) {
    print('Error Save Data');
    print(error.toString());

    print(stack.toString());
    // يمكنك إعادة إلقاء الخطأ إذا كنت تريد معالجته في مكان آخر
    // throw error;
  }
}

Future<HomePageLoginModel?> getDataHomePage() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('homePageData');
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return HomePageLoginModel.fromJson(jsonMap);
  } catch (error,stack) {
    print('Error Loading Data');
    print(error.toString());
    print(stack.toString());
    return null;
    // أو يمكنك إعادة إلقاء الخطأ إذا كنت تريد معالجته في مكان آخر
    // throw error;
  }
}


Future<void> setDataCompany(ActivityCompanyModel model) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString('ActivityCompany', jsonString);
    print('Save Data Success');
  } catch (error,stack) {
    print('Error Save Data');
    print(error.toString());

    print(stack.toString());
    // يمكنك إعادة إلقاء الخطأ إذا كنت تريد معالجته في مكان آخر
    // throw error;
  }
}

Future<ActivityCompanyModel?> getCompaniesData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('ActivityCompany');
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return ActivityCompanyModel.fromJson(jsonMap);
  } catch (error,stack) {
    print('Error Loading Data');
    print(error.toString());
    print(stack.toString());
    return null;
  }
}
Widget iconSvg({
  required String iconSvg,
  double? width,
  double? height,
}) {
  return CustomImageView(
    imagePath: iconSvg,
    color: appTheme.deepPurpleA100,
  );
}

Widget iconPng({required String iconPng, double? height, double? width}) {
  return Container(
    height: height ?? 24.h,
    width: width ?? 24.h,
    // padding: EdgeInsets.symmetric(vertical: 14),
    child: Image.asset(
      iconPng,
      height: 20.h,
      width: 20.h,
    ),
  );
}

bool isIpad(context) {
  return MediaQuery.of(context).size.width > 650;
}

Widget buildCategory({
  required void Function() onTap,
  String? imagePath,
  FaIconData? icon,
  required String text,
  Color? color,
  bool isScrollerCard = false,
}) {
  final accent = color ?? LbeenaColors.teal;
  final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  if (isScrollerCard) {
    return SizedBox(
      width: 78,
      height: 112,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: LbeenaColors.fieldBorder),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: LbeenaColors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: CustomImageView(
                    imagePath: imagePath,
                    height: 72,
                    width: 78,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                          color: appTheme.black900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: isDark ? LbeenaColors.cardDark : LbeenaColors.iconTile,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: icon != null
                ? FaIcon(icon, size: 24, color: accent)
                : CustomImageView(
                    imagePath: imagePath,
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                    color: accent,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: appTheme.black900,
          ),
        ),
      ],
    ),
  );
}

Widget textNormal({
  required String text,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  TextOverflow? overflow,
  TextBaseline? textBaseline,
  TextAlign? textAlign,
  int? maxLines,
  TextDecoration? decoration, // إضافة هذا المتغير لتحديد الزخرفة
}) {
  // String displayText = text.length > 20 ? '${text.substring(0, 20)}...' : text;

  return Text(
    text,
    style: themeLite.textTheme.titleSmall!.copyWith(
      fontSize: fontSize ?? AppFontSize.fontSize_14,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? appTheme.black900,
      overflow: overflow,
      textBaseline: textBaseline,
      decoration: decoration ?? TextDecoration.none,
      // تحديد الزخرفة هنا
      decorationColor: Colors.blue,
    ), textAlign: textAlign,
    maxLines: maxLines,
  );
}

String formatDateWithArabicMonth(DateTime date) {
  // أسماء الأشهر بالعربي
  final monthsAr = [
    "كانون الثاني",
    "شباط",
    "آذار",
    "نيسان",
    "أيار",
    "حزيران",
    "تموز",
    "آب",
    "أيلول",
    "تشرين الأول",
    "تشرين الثاني",
    "كانون الأول"
  ];

  final day = DateFormat('d').format(date);      // اليوم بالرقم
  final year = DateFormat('yyyy').format(date);  // السنة بالرقم
  final month = monthsAr[date.month - 1];        // الشهر بالعربي

  return "$day $month $year";
}

String convertDateTime({
  required String dataTimeValue
}){
  DateTime dataTimeValueNew = DateTime.parse(dataTimeValue);
  return DateFormat('yyyy-MM-dd').format(dataTimeValueNew);
}
Widget textNormalGoldenPrice({
  required String text,
  double? fontSize,
  double? horizontal,
  FontWeight? fontWeight,
  Color? color,
  Color? colorBackGround,
  TextOverflow? overflow,
  TextBaseline? textBaseline,
  int? maxLines,
  TextAlign? textAlign,
  TextDecoration? decoration, // إضافة هذا المتغير لتحديد الزخرفة
}) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 2,horizontal: 2),
    child: Container(
      width: 100.w,
      height: 22.h,
      decoration: AppDecoration.itemCart.copyWith(
        borderRadius: BorderRadius.all(Radius.circular(2.r)),
        color: colorBackGround?? Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),

      child: Center(
        child: Text(
          text,
          style: themeLite.textTheme.titleSmall!.copyWith(
              fontSize: fontSize ?? AppFontSize.fontSize_10,
              fontWeight: fontWeight ?? FontWeight.w700,
              color: color ?? Colors.black,
              overflow: overflow,
              textBaseline: textBaseline,

              decoration: decoration ?? TextDecoration.none, // تحديد الزخرفة هنا
              decorationColor: Colors.blue
          ),textAlign: textAlign,
          maxLines: maxLines,
        ),
      ),
    ),
  );
}
bool isArabic(String text) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  return arabicRegex.hasMatch(text);
}

bool isEnglish(String text) {
  final englishRegex = RegExp(r'[a-zA-Z]');
  return englishRegex.hasMatch(text);
}

Widget textNormalTitleCompany(
    {required String text,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color}) {
  return Text(
     text,overflow: TextOverflow.ellipsis,
    style: themeLite.textTheme.titleSmall!.copyWith(
      fontSize: fontSize ?? AppFontSize.fontSize_12,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? appTheme.whiteA700,

    ),
  );
}

Widget sizeHeightNormal({double? height}) {
  return SizedBox(
    height: height ?? 10,
  );
}

Widget appBarNormal(
  context, {
  required String text,
  bool isNotNeedBackArrow = false,
  bool isFromStack = false,
}) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      CustomImageView(
        height: 100.h,
        width: double.maxFinite,
        imagePath: ImageConstant.imgAppBarMain,
        fit: BoxFit.cover,
        color: appTheme.lightBlueBottomNavigatorBar,
        placeHolder: ImageConstant.imgAppBarMain,
      ),
      Positioned(
        right: !isFromStack ? null : 50.w,
        child: Padding(
          padding: EdgeInsets.only(top: 25.h),
          child: Container(
            width: 260.w,
            child: Center(
              child: Text(
                text,
                style: themeLite.textTheme.titleLarge!.copyWith(
                  color: LbeenaColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      isNotNeedBackArrow
          ? Container()
          : Positioned(
              right: 8.h,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: LbeenaColors.white,
                    )),
              ),
            )
    ],
  );
}

Widget sizeWidthNormal({double? width}) {
  return SizedBox(
    width: width ?? 10,
  );
}

bool isPDF(String url) {
  return url.toLowerCase().endsWith('.pdf');
}

Widget suffix({
  required context,
  required String content,
}) {
  return Tooltip(
    message: content,
    textStyle: TextStyle(color: appTheme.white),
    padding: EdgeInsets.all(15.sp),
    showDuration: const Duration(seconds: 10),
    decoration: ShapeDecoration(
      color: appTheme.tooltip.withOpacity(.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
    // textStyle: const TextStyle(color: Colors.white),
    preferBelow: false,
    verticalOffset: 20,

    child: IconButton(
      icon: Icon(
        Icons.info,
        size: 30.fSize,
        color: appTheme.black900.withOpacity(.8),
      ),
      onPressed: null,
    ),
  );
}

Widget point() {
  return Container(
      width: 18.h, height: 18.h, decoration: AppDecoration.pointChoose);
}

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget containerLinks({
  required List<String> links,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 0, right: 0,top: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: links.map((link) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: InkWell(
            onTap: () {
              if (link.contains('http')) {
                launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse('https://$link'), mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: AppDecoration.outlineButtonLite.copyWith(
                color: appTheme.whiteA700,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.2,
                    blurRadius: 3,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(
                  getIcon(link),
                  size: 20,
                  color: appTheme.greenColor,
                  // color: getColor(link),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
/// Section Widget
Widget buildUaeNumber(BuildContext context) {
  var lang = Localizations.localeOf(context).languageCode;

  return CustomTextFormField(
    width: MediaQuery.of(context).size.width * 0.22,
    readOnly: true,
    hintText: lang == 'en' ? "+971" : "971+",
    // filled: true,

    suffix: Padding(
      padding: const EdgeInsets.only(left: 6),
      child: CustomImageView(
        imagePath: ImageConstant.imgTelevision,
        height: 16.fSize,
        width: 23.fSize,
      ),
    ),
    suffixConstraints: BoxConstraints(
      maxHeight: 48.fSize,
    ),
    prefixConstraints:BoxConstraints(
      maxHeight: 48.fSize,
    ),
  );
}

FaIconData getIcon(String url) {
  if (url.contains("facebook")) {
    return FontAwesomeIcons.facebook;
  } else if (url.contains("instagram")) {
    return FontAwesomeIcons.instagram;
  } else if (url.contains("tiktok")) {
    return FontAwesomeIcons.tiktok;
  } else if (url.contains("snapchat")) {
    return FontAwesomeIcons.snapchat;
  } else if (url.contains("youtube")) {
    return FontAwesomeIcons.youtube;
  } else {
    return FontAwesomeIcons.link;
  }
}

Color getColor(String url) {
  if (url.contains("facebook")) {
    return Colors.blue; // لون فيسبوك
  } else if (url.contains("instagram")) {
    return Colors.purpleAccent; // لون إنستغرام
  } else if (url.contains("tiktok")) {
    return appTheme.black900; // لون تيك توك
  } else if (url.contains("snapchat")) {
    return Colors.yellow; // لون سناب شات
  } else if (url.contains("youtube")) {
    return Colors.red; // لون يوتيوب
  } else {
    return appTheme.black900; // لون افتراضي
  }
}

Widget versionAppWidget() {
  return Directionality(
    textDirection: ui.TextDirection.ltr,
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textNormal(
                text: 'Copyright © 2024 ',
                color: Colors.grey,
                fontSize: AppFontSize.fontSize_12,
                fontWeight: FontWeight.w500),
            // InkWell(
            //     onTap: () {
            //       launchURL('https://alkhaaldi.ae/');
            //     },
            //     child: textNormal(text: 'Alkhaaldi.ae', color:  appTheme.deepPurpleA100, fontSize: AppFontSize.fontSize_12, fontWeight: FontWeight.w500)),
            // textNormal(text: ' and ', color: Colors.grey, fontSize: AppFontSize.fontSize_12, fontWeight: FontWeight.w500),
            // InkWell(
            //     onTap: () {
            //       launchURL('https://www.etechnocode.com/');
            //     },
            //     child: textNormal(text: 'TechnoCode L.L.C.', color:  appTheme.deepPurpleA100, fontSize: AppFontSize.fontSize_12, fontWeight: FontWeight.w500)),
          ],
        ),
        textNormal(
            text: 'All rights reserved powered by',
            color: Colors.grey,
            fontSize: AppFontSize.fontSize_12,
            fontWeight: FontWeight.w500),
        textNormal(
            text: 'Lbeena',
            color: Colors.grey,
            fontSize: AppFontSize.fontSize_12,
            fontWeight: FontWeight.w500),
        textNormal(
            text: 'Version 1.4.3',
            color: Colors.grey,
            fontSize: AppFontSize.fontSize_12,
            fontWeight: FontWeight.w500),
      ],
    ),
  );
}

Widget buildGoToLogin(context) {
  return Padding(
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.2),
    child: Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textNormal(
          text: AppLocalizations.of(context)!.login_in_app,
        ),
        sizeHeightNormal(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: CustomElevatedButton(
            text: AppLocalizations.of(context)!.login_in_app,
            height: 48.h,
            borderRadius: 14.r,
            backgroundButtonColor: LbeenaColors.orange,
            buttonTextStyle: themeLite.textTheme.titleMedium!.copyWith(
              color: LbeenaColors.white,
              fontWeight: FontWeight.w800,
            ),
            buttonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return LbeenaColors.orangeDeep;
                }
                return LbeenaColors.orange;
              }),
              foregroundColor: WidgetStateProperty.all(LbeenaColors.white),
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
            onPressed: () {
              navigatorToPush(
                  context: context,
                  pageName: LoginScreen(
                    isNeedIconBac: true,
                  ));
            },
          ),
        ),
      ],
    )),
  );
}

// PreferredSizeWidget appBarNormalScreens({
//   required String text,double size =90,
//   bool isHaveSearch  =false,
//   bool isHaveOneIcons  =false,
//   void Function()? onPressed,
//   void Function()? onPressed2,
//   String? imagePath
// }){
//   return PreferredSize(
//     preferredSize:  Size.fromHeight(size, ),
//
//     child:
//     TopCurvedCirculartItem(
//     title:text,
//     isHaveIcons:isHaveSearch ,
//       isHaveOneIcons:isHaveOneIcons ,
//     onPressed2: onPressed2,
//     imagePath: imagePath,
//     onPressed: onPressed,
//     ),
//   );
// }

PreferredSizeWidget appBarNormalWithIcon(
    {required String text,
    double size = 90,
    bool isHaveSearch = false,
    bool isShowBack = false,
    bool isHaveOneIcons = false,
    bool isFromDetailsProfile = false,
    void Function()? onPressed,
    void Function()? onPressed2,
    String? imagePath,
    required context}) {
  return AppBarScreens(
    context,
    title: text,
    isHaveIcons: isHaveSearch,
    isFromDetailsProfile: isFromDetailsProfile,
    isHaveOneIcons: isHaveOneIcons,
    isShowBack: isShowBack,
    onPressed2: onPressed2,
    imagePath: imagePath,
    onPressed: onPressed,
  );
}

/// Section Widget
Widget buildTextFormFieldItem(
  BuildContext context, {
  required TextEditingController controller,
  required String hintText,
  required TextInputType? textInputType,
  required String? icon,
  required FocusNode focusNode,
  required Null Function(dynamic)? onChangedButton,
  String? Function(String?)? validator,
  int? maxLength,
}) {
  var lang = Localizations.localeOf(context).languageCode;
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 15.h,
      // vertical: 9.v,
    ),
    decoration: AppDecoration.outlineCyan.copyWith(
      borderRadius: BorderRadiusStyle.circleBorder24,
    ),
    child: CustomTextFormField(
      width: 308.h,
      focusNode: focusNode,
      // textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      controller: controller,
      hintText: hintText,
      maxLength: maxLength,
      // alignment: Alignment.center,
      // textInputAction: TextInputAction.done,
      textInputType: textInputType,
      validator: validator ??
          (text) {
            if (text == null || text.isEmpty) {
              return AppLocalizations.of(context)!.field_is_empty;
            }
            return null;
          },
      onChanged: onChangedButton,
      autofocus: false,
      contentPadding:
          EdgeInsets.only(left: 25.w, top: 10.h, bottom: 10.h, right: 25.w),
    ),
  );
}

extension toStringWithoutNull on String {
  String? convertResponse(){
    return this == 'null' ? null :this;
  }
}

String getNewsLineText(
    {required List<String> breakingNewsList, bool isTitleOne = false}) {
  String text = "";

  for (int i = 0; i < 2; i++) {
    text += (" • ${breakingNewsList[0]} ${breakingNewsList[1]}");
  }

  return text;
}

/// Section Widget
Widget buildAdsRandom(BuildContext context,
    {String? text, List<DataProductBannerModel>? adsRandom}) {
  return Column(
    children: [
      adsRandom!.isEmpty
          ? Container()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 0, bottom: 5, right: 3.w),
                  child: Text(
                    text.toString(),
                    style: themeLite.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
      ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   // mainAxisExtent:isIpad(context) ?  270.h: 222.h,
        //   mainAxisExtent: isIpad(context) ? 270.h : 222.h,
        //   // mainAxisExtent: MediaQuery.of(context).size.width * 0.27,
        //   crossAxisCount: 1,
        //   mainAxisSpacing: 5.h,
        //   crossAxisSpacing: 5.h,
        // ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: adsRandom.length,
        itemBuilder: (context, index) {

          return GestureDetector(
              onTap: () {
                navigatorToPush(
                    context: context,
                    pageName: DetailsProduct(
                      detailsProduct: adsRandom[index],
                      categoryId: adsRandom[index].categoryId.toString(),
                      adsName: adsRandom[index].name,
                      idAds: adsRandom[index].adsId.toString(),
                      idBannerOrProduct: int.parse(adsRandom[index].adsId!),
                      idAdOnwerCompany: int.parse(adsRandom[index].userId!),
                    ));
              },
              child: AdsProductWidget(
                dataProductItem: adsRandom[index],
              ));
        },
      ),
    ],
  );
}

Widget itemButtonNavigatorBar({
  required Function() onTap,
  required int index,
  required int selectScreen,
  required String imagePath,
  required String title,
}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: imagePath,
          height: selectScreen == index ? 30.fSize : 25.fSize,
          width: selectScreen == index ? 30.fSize : 25.fSize,
          color: selectScreen == index
              ? appTheme.activeButtonNavigatorBarIcon
              : appTheme.buttonNavigatorBarIcon,
        ),
        Container(
          // width: 40.h,
          margin: EdgeInsets.only(
            bottom: 10.h,
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeLite.textTheme.labelSmall,
          ),
        ),
      ],
    ),
  );
}

/// Section Widget
Widget buildCompanyAdvertisers(BuildContext context, {DataCompany? company}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: company!.data.isEmpty
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 1.w),
                      child: Text(
                        AppLocalizations.of(context)!.top_companies,
                        style: themeLite.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(height: 9.h),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 35.fSize,
                        crossAxisCount: 3,
                        // mainAxisSpacing: 0.2.fSize,
                        // crossAxisSpacing: 0.5.fSize,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: company!.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            navigatorToPush(
                                context: context,
                                pageName: CompanyDetailsPage(
                                  idCompany: company.data[index].id!,
                                ));
                          },
                          child: ViewCompanyItemWidget(
                            company: company.data[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
      ),
      sizeHeightNormal(height: 15.h),
    ],
  );
}

Widget buildAdsItems(
  BuildContext context, {
  Ads? adsProduct,
  String? text,
}) {

  return adsProduct?.data == null
      ? Container()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            adsProduct!.data.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 6.w, bottom: 5.h, top: 5.h, right: 6.w),
                    child: Text(
                      text.toString(),
                      style: themeLite.textTheme.titleMedium,
                    ),
                  )
                : Container(),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: adsProduct.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      navigatorToPush(
                          context: context,
                          pageName: DetailsProduct(
                            detailsProduct: adsProduct.data[index],
                            categoryId:
                                adsProduct.data[index].categoryId.toString(),
                            adsName: adsProduct.data[index].name,
                            idAds: adsProduct.data[index].adsId.toString(),
                            idBannerOrProduct:
                                int.parse(adsProduct.data[index].adsId!),
                            idAdOnwerCompany:
                                int.parse(adsProduct.data[index].userId!),
                          ));
                    },
                    child: AdsProductWidget(
                      dataProductItem: adsProduct.data[index],
                    ));
              },
            ),
            adsProduct.data.isNotEmpty
                ? sizeHeightNormal(height: 10.h)
                : Container(),
          ],
        );
}

Widget buildNewsAds(context, {NewsDatum? adsNewsModel}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        adsNewsModel != null
            ? Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 0, bottom: 8.h,top: 5.h),
                  child: Row(
                    children: [
                      Text(
                        'من قسم الأخبار',
                        style: themeLite.textTheme.titleMedium,
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          navigatorToPush(
                              context: context, pageName: NewsListScreen());
                        },
                        child: Text('عرض الكل',
                            style: themeLite.textTheme.titleMedium!.copyWith(
                                color: appTheme.deepPurpleA10001,
                                fontSize: 14.sp)),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        adsNewsModel == null
            ? Container()
            : NewsCard(
                news: adsNewsModel,
                isCardInHomePage: true,
              ),
        adsNewsModel == null
            ? Container()
            : sizeHeightNormal(height: 10.h),
      ],
    ),
  );
}
Widget itemButtonContainer({
  required String text,
  required String adStatus,
  String? imageIcon,
  required void Function()? onTap,
  double? width,
  bool changeBackGround = false,
  bool isDeleteAds = false,
  bool inactivation = false,
}) {
  return (adStatus == '3' && !isDeleteAds) || inactivation
      ? Container(
    height: 25.h,
    width: width ?? 180.w,
    decoration: AppDecoration.itemCartNew.copyWith(
      color: Colors.grey,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textNormal(text: text,fontSize: 10.fSize),
        SizedBox(
          width: 8.w,
        ),
        imageIcon==null?Container():     CustomImageView(
          imagePath: imageIcon,
          color: Colors.white,
          height: 15.h,
          width: 15.h,
        ),
        // iconSvg(iconSvg: imageIcon),
      ],
    ),
  )
      : InkWell(
    onTap: onTap,
    child: Container(
      height: 30.h,
      width: width ?? 180.w,
      decoration: AppDecoration.itemCartNew.copyWith(
        color: changeBackGround ? Colors.green : Colors.grey[200],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textNormal(text: text,fontSize: 10.fSize,color: Colors.black),
          imageIcon==null?Container():     SizedBox(
            width: 8.w,
          ),
          imageIcon==null?Container():        CustomImageView(
            imagePath: imageIcon,
            color: changeBackGround
                ? Colors.white70
                : appTheme.deepPurpleA100,
            height: 15.h,
            width: 15.h,
          ),
          // iconSvg(iconSvg: imageIcon),
        ],
      ),
    ),
  );
}

Widget buildBannerItem(
    BuildContext context, DataProductBannerModel dataBanner,{double? horizontal }) {
  return GestureDetector(
    onTap: () {
      if (dataBanner.inOut == '1') {
        if (dataBanner.url.toString().contains('http')) {
          launchUrl(Uri.parse(dataBanner.url.toString()));
        } else {
          launchUrl(Uri.parse('https://' + dataBanner.url.toString()),mode: LaunchMode.externalApplication);
        }
      } else {
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
      }
    },
    child: Container(
      // width: 360.w,
      height: 140.h,
      margin: EdgeInsets.symmetric(horizontal: horizontal ??0),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadius.circular(16.r),
        color: appTheme.lightBlue100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CustomImageView(
          imagePath: dataBanner.image.toString().contains('http')
              ? dataBanner.image.toString()
              : AppEndpoints.baseUrlWithoutApi + dataBanner.image.toString(),
          width: double.infinity, // تأكد من استخدام المساحة بالكامل
          height: double.infinity,
          alignment: Alignment.center,
          fit: BoxFit.cover, // غيّر إلى cover للحفاظ على النسبة
        ),
      ),
    ),
  );
}

Widget bannerItem(image){
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 12.h),
    child: Container(
      // width: 360.w,
      height: 140.h,
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder7,
        color: appTheme.lightBlue100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.r),
        child: CustomImageView(
          imagePath:image,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}

 permissionPhoto({
  required bool isCamera,
  required BuildContext context,
}) async {

    bool shouldOpenSettings = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الإذن مطلوب'),
        content: Text(
            'يجب منح إذن الوصول إلى ${isCamera ? "الكاميرا" : "معرض الصور"} لاستخدام هذه الميزة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('فتح الإعدادات'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings) {
      await openAppSettings();
    }


}

Widget loadingButton({Color? color}) {
  return LoadingAnimationWidget.threeRotatingDots(
    color:color?? Colors.white,
    size: 35,
  );
}

Widget profileOverviewCompany(
    {required String titleTop,
      required String titleBottom,
      Color? colorBackGround,
      bool isFromPackage = false,
      required void Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color:colorBackGround?? appTheme.backgroundContainer,
          borderRadius: BorderRadius.circular(25)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textNormal(
                  text: titleTop,
                  color:  appTheme.black900,
                  fontSize: 12,fontWeight: FontWeight.w400),
              SizedBox(width: 5,),
              textNormal(
                  text: titleBottom,
                  color:  appTheme.black900,
                  fontSize: 12,fontWeight: FontWeight.w400),
            ]),
      ),
    ),
  );
}

Widget profileOverview(
    {required String titleTop,
    required String titleBottom,
    bool isFromPackage = false,
    required void Function()? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textNormal(
                text: titleTop,
                color: isFromPackage ? Colors.black : Colors.grey,
                fontSize: 12.fSize,fontWeight: FontWeight.w400),
            textNormal(
                text: titleBottom,
                color: isFromPackage ? Colors.black : Colors.grey,
                fontSize: 12.fSize,fontWeight: FontWeight.w400),
          ]),
    ),
  );
}


Widget profileOverviewNumber(
    {required String titleTop,
      required String titleBottom,}) {
  return Expanded(
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textNormal(
              text: titleTop,
              color: Colors.black ,
              fontSize: 9.sp,fontWeight: FontWeight.w700),
          textNormal(
              text: titleBottom,
              color: appTheme.greenColor,
              fontSize: 15.sp,fontWeight: FontWeight.bold),
        ]),
  );
}

Widget imageFromUrlVideo(
    {required String link, required void Function()? onTap}) {
  return link.contains('youtube') || link.contains('youtu.be')
      ? InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnyLinkPreview(
                link: link.contains('youtube') && link.contains('watch')
                    ? convertToShortUrl(link)
                    : link,
                displayDirection: UIDirection.uiDirectionVertical,
                bodyMaxLines: 1,
                bodyTextOverflow: TextOverflow.ellipsis,
                cache: Duration(days: 7),
                urlLaunchMode: LaunchMode.externalApplication,
                borderRadius: 12,
                onTap: onTap, // This disables tap event
              ),
              CustomImageView(
                imagePath: ImageConstant.videoICon,
                color: Colors.red,
                placeHolder: ImageConstant.imageNotFound,
              ),
            ],
          ),
        )
      : AnyLinkPreview(
          link: link.contains('youtube') && link.contains('watch')
              ? convertToShortUrl(link)
              : link,
          displayDirection: UIDirection.uiDirectionVertical,
          bodyMaxLines: 1,
          bodyTextOverflow: TextOverflow.ellipsis,
          cache: Duration(days: 7),
          urlLaunchMode: LaunchMode.externalApplication,
          borderRadius: 12,
          onTap: onTap, // This disables tap event
        );
}

String convertToShortUrl(String longUrl) {
  // تعبير عادي لاستخراج معرّف الفيديو
  final regex = RegExp(r'v=([^&]+)');
  final match = regex.firstMatch(longUrl);
  if (match != null) {
    final videoId = match.group(1);
    // بناء الرابط القصير
    return 'https://youtu.be/$videoId';
  } else {
    // إذا لم يتم العثور على معرّف الفيديو
    return longUrl;
  }
}

bool isTypeIpad(context) {
  return MediaQuery.of(context).size.width > 650;
}

void showInfoCompany(BuildContext context, text1, text2) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      double rating = 0.0;
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: appTheme.buttonColor,
              title: textNormal(text: text1, color: Colors.white),
              content: Container(
                // height: 200.v,
                  child: textNormal(
                    // text: 'لايتوفر رقم واتس اب للشركة حتى الآن..',
                      text: text2,
                      color: Colors.white)),
              actions: [
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Center(
                      child: Container(
                        width: 80.h,
                        height: 40.h,
                        decoration: AppDecoration.outlineSelectedLite
                            .copyWith(borderRadius: BorderRadius.circular(30.h)),
                        child: Center(
                          child: textNormal(text: 'الغاء'),
                        ),
                      )),
                ),
              ],
            );
          });
    },
  );
}

void copyToClipboard(String text, context) {
  Clipboard.setData(ClipboardData(text: text));
  SnackBarHelper.mySnackBarSuccess('تم نسخ الكود', context);
}

///
// تمييز اعلان
// void showAdsSpecialFeatures(BuildContext context,
//     List<dynamic>? adsSpecialFeatures, String isHave, adsId) {
//   HomeCubit cubit = BlocProvider.of(context);
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       double rating = 0.0;
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             backgroundColor: appTheme.buttonColor,
//             content: Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.height * 0.2,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: adsSpecialFeatures?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding:
//                     EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.h),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedAdsSpecialFeatures = index;
//                           priceAdsSpecialFeatures = double.parse(
//                               adsSpecialFeatures![index].price.toString());
//                         });
//                       },
//                       child: Container(
//                         height: 40.h,
//                         width: 100.h,
//                         decoration: AppDecoration.outlineButtonLite.copyWith(
//                           borderRadius: BorderRadius.circular(60.sp),
//                           boxShadow: [],
//                         ),
//                         child: Row(
//                           children: [
//                             sizeWidthNormal(),
//                             selectedAdsSpecialFeatures == index
//                                 ? CustomImageView(
//                               imagePath: ImageConstant.imgTrue,
//                               width: 15.h,
//                               height: 15.h,
//                               color: appTheme.deepPurpleA100,
//                             )
//                                 : Container(),
//                             sizeWidthNormal(),
//                             textNormal(
//                               text: adsSpecialFeatures?[index]
//                                   .featureName
//                                   .toString() ??
//                                   '',
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             actions: [
//               if (isHave == '1') ...[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectedAdsSpecialFeatures = -1;
//                           priceAdsSpecialFeatures = 0.0;
//                           cubit.changeVariable(isChangeVar: true);
//
//                           /// تمميز
//                           cubit.addAdsSpecialFeatures(
//                             adsId: adsId,
//                             idAdsSpecialFeature: -1,
//                             isHave: 0,
//                           );
//
//                           Navigator.of(context).pop();
//                         });
//                       },
//                       child: Center(
//                         child: Container(
//                           width: 110.h,
//                           height: 40.h,
//                           decoration:
//                           AppDecoration.outlineSelectedLite.copyWith(
//                             borderRadius: BorderRadius.circular(30.h),
//                           ),
//                           child: Center(
//                             child: textNormal(text: 'إيقاف التمييز'),
//                           ),
//                         ),
//                       ),
//                     ),
//                     sizeWidthNormal(),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           if (selectedAdsSpecialFeatures == -1) {
//                             SnackBarHelper.mySnackBarError(
//                                 'الرجاء اختيار خطة تمييز', context);
//                             return;
//                           }
//                           if (selectedAdsSpecialFeatures != -1) {
//                             idSelectedAdsSpecialFeatures = int.parse(
//                               adsSpecialFeatures![selectedAdsSpecialFeatures!]
//                                   .id!
//                                   .toString(),
//                             );
//                             cubit.changeVariable(isChangeVar: true);
//                             // cubit.addAdsSpecialFeatures(
//                             //   adsId: adsId,
//                             //   idAdsSpecialFeature:
//                             //       idSelectedAdsSpecialFeatures!,
//                             //   isHave: 1,
//                             // );
//
//                             showPay(context);
//                           }
//                           Navigator.of(context).pop();
//                         });
//                       },
//                       child: Center(
//                         child: Container(
//                           width: 80.h,
//                           height: 40.h,
//                           decoration:
//                           AppDecoration.outlineSelectedLite.copyWith(
//                             borderRadius: BorderRadius.circular(30.h),
//                           ),
//                           child: Center(
//                             child: textNormal(
//                                 text: '${priceAdsSpecialFeatures}تمييز '),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ] else ...[
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       Navigator.of(context).pop();
//                       if (selectedAdsSpecialFeatures != -1) {
//                         idSelectedAdsSpecialFeatures = int.parse(
//                           adsSpecialFeatures![selectedAdsSpecialFeatures!]
//                               .id!
//                               .toString(),
//                         );
//                         cubit.changeVariable(isChangeVar: true);
//                         cubit.addAdsSpecialFeatures(
//                           adsId: adsId,
//                           idAdsSpecialFeature: idSelectedAdsSpecialFeatures!,
//                           isHave: 1,
//                         );
//                         // showPay(context);
//                       }
//                     });
//                   },
//                   child: Center(
//                     child: Container(
//                       width: 120.h,
//                       height: 40.h,
//                       decoration: AppDecoration.outlineSelectedLite.copyWith(
//                         borderRadius: BorderRadius.circular(30.h),
//                       ),
//                       child: Center(
//                         child: textNormal(text: 'تمييز '),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           );
//         },
//       );
//     },
//   );
// }
//
// void showEditAds(
//     BuildContext context,
//     ) {
//   HomeCubit cubit = BlocProvider.of(context);
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       double rating = 0.0;
//       return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Form(
//               key: _formKey2,
//               child: AlertDialog(
//                 backgroundColor: appTheme.buttonColor,
//                 // title: Text(
//                 //             'اختر طريقة تمميز إعلانك',
//                 //             style: themeLite.textTheme.titleSmall,
//                 //           ),
//                 content: Container(),
//               ),
//             );
//           });
//     },
//   );
// }
