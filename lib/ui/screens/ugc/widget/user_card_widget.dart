import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/ugc/ugc_users_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../../widget/url_webview.dart';
import '../../company/widget/following_users_page.dart';

class UserCardWidget extends StatefulWidget {
  UserCardWidget({super.key, required this.data});

  UgcUsersData data;

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  //  color: widget.data.gender == 'male'
  //               ? Colors.lightBlue.withOpacity(.6)
  //               : Colors.pinkAccent.withOpacity(.6),
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 350.w,
      decoration:
          AppDecoration.itemIcon.copyWith(color: appTheme.backgroundUGC),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            userMetricsCard(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileOverviewCompany(
                    titleTop: '${widget.data.followersCount ?? 0}',
                    colorBackGround: appTheme.white2,
                    titleBottom: 'متابع',
                    onTap: () {
                      navigatorToPush(
                          context: context,
                          pageName: FollowingUsersPage(
                            titleAppBar: 'متابع',
                            isFollowers: true,
                            userId: widget.data.userId!,
                          ));
                    }),
                profileOverviewCompany(
                    titleTop: '${widget.data.followingCount ?? 0}',
                    titleBottom: 'يتابع',
                    colorBackGround: appTheme.white2,
                    onTap: () {
                      navigatorToPush(
                          context: context,
                          pageName: FollowingUsersPage(
                            titleAppBar: 'يتابع',
                            isFollowers: false,
                            userId: widget.data.userId!,
                          ));
                    }),
                profileOverviewCompany(
                    titleTop: '${widget.data.adsCount ?? '0'}',
                    titleBottom: 'إعلانات',
                    colorBackGround: appTheme.white2,
                    onTap: () {}),
                profileOverviewCompany(
                    titleTop: '${widget.data.postsCount ?? '0'}',
                    titleBottom: 'منشورات',
                    colorBackGround: appTheme.white2,
                    onTap: () {}),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal:widget.data.gender.toString().toLowerCase() =='female'? 5:3, vertical:widget.data.gender.toString().toLowerCase() =='female'? 5:3),
                    decoration: AppDecoration.outlineButtonLite.copyWith(
                      color: appTheme.whiteA700,
                      border: Border.all(
                        color:  widget.data.gender.toString().toLowerCase() =='female'? Colors.red:Colors.blue,),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.2,
                          blurRadius: 3,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                  child: CustomImageView(
                    imagePath: widget.data.gender.toString().toLowerCase() =='female'?ImageConstant.femaleIcon:ImageConstant.maleIcon,
                    color: widget.data.gender.toString().toLowerCase() =='female'? Colors.red:Colors.blue,
                  ),),
                  sizeWidthNormal(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: AppDecoration.outlineButtonLite.copyWith(
                      color: appTheme.whiteA700,
                      border: Border.all(color: appTheme.greenColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.2,
                          blurRadius: 3,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.locationIcon,
                        ),
                        sizeWidthNormal(width: 5),
                        textNormal(
                            text: widget.data.cityName ?? '',
                            fontSize: AppFontSize.fontSize_10,
                            fontWeight: FontWeight.bold,
                            color: appTheme.greenColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // _buildProfileCompletionCircle(),
            userRatingAndBusinessName(context),
            SizedBox(height: 4),
            userEngagementInfo(context),
          ],
        ),
      ),
    );
  }

  Widget userMetricsCard(
    context,
  ) {
    double completionPercentage = _calculateProfileCompletion();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 65,
          height: 85,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: completionPercentage / 100,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completionPercentage >= 90
                          ? Colors.green
                          : completionPercentage >= 70
                              ? Colors.blue
                              : Colors.orange,
                    ),
                  ),
                ),
                Container(
                  width: 55,
                  height: 55,
                  // color: Colors.green,
                  decoration: AppDecoration.outlineCircular4,
                  // child: Image.asset(
                  //     ImageConstant.imgLogoWhite13,),
                  child: CustomImageView(
                    imagePath: widget.data.profilePic.toString() == 'null'
                        ? ImageConstant.imgPerson
                        : widget.data.profilePic.toString().contains('http')
                            ? widget.data.profilePic.toString()
                            : AppEndpoints.baseUrlWithoutApi +
                                widget.data.profilePic.toString(),
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    radius: BorderRadius.circular(30),
                    fit: BoxFit.cover,
                    color: widget.data.profilePic.toString() == 'null'
                        ? appTheme.greenColor
                        : null,
                    placeHolder: ImageConstant.imgPerson,
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 0,
                  child: Container(
                    decoration: AppDecoration.outlineCircular3.copyWith(
                        borderRadius: BorderRadius.all(Radius.circular(66)),
                        boxShadow: []),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${completionPercentage.round()}%',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // textNormal(text:  widget.data.hasMoreThan3000.toString()),
        sizeWidthNormal(),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.data.userName.toString() ?? '',
                style: themeLite.textTheme.titleSmall!
                    .copyWith(fontSize: 13.fSize),
              ),
              Row(
                children: [
                  widget.data.categoryName == null
                      ? Container()
                      : textNormal(
                          text: widget.data.categoryName ?? '',
                          fontSize: AppFontSize.fontSize_10,
                          color: Colors.grey),
                  // widget.data.categoryName == null
                  //     ? Container()
                  //     : textNormal(
                  //     text: ' ,',
                  //     fontSize: AppFontSize.fontSize_10,
                  //     color: appTheme.greenColor),
                  // widget.data.cityName == null
                  //     ? Container()
                  //     : textNormal(
                  //     text: widget.data.cityName ?? '',
                  //     fontSize: AppFontSize.fontSize_10,
                  //     color: appTheme.greenColor),
                  sizeWidthNormal(),
                  Container(
                    child: RatingBarIndicator(
                      rating:
                          double.parse(widget.data.rating ?? '0').toDouble(),
                      itemCount: 5,
                      itemSize: 20,
                      unratedColor: Color(0xffc3c3c3),
                      direction: Axis.horizontal,
                      itemBuilder: (context, index) => CustomImageView(
                        imagePath: ImageConstant.starIcon,
                        width: 20,
                        height: 20,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: InkWell(
            onTap: () {
              shareCompany(
                idCompany: widget.data.userId.toString(),
                imageUrl: widget.data.profilePic != null
                    ? (widget.data.profilePic.toString().contains('http')
                        ? widget.data.profilePic.toString()
                        : AppEndpoints.baseUrlWithoutApi +
                            widget.data.profilePic.toString())
                    : 'null',
                nameCompany: widget.data.userName.toString() ?? '',
                accountType: widget.data.accountType.toString(),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration:
                      AppDecoration.itemIcon.copyWith(color: appTheme.white2),
                  width: 35,
                  height: 35,
                ),
                CustomImageView(
                  imagePath: ImageConstant.shareIcon,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                  color: Colors.grey,
                  // color: appTheme.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //      Padding(

  bool isLoadingShareAds = false;

  Widget _buildProfileCompletionCircle() {
    // حساب نسبة الإكتمال
    double completionPercentage = _calculateProfileCompletion();

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: CircularProgressIndicator(
              value: completionPercentage / 100,
              strokeWidth: 3,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                completionPercentage >= 90
                    ? Colors.green
                    : completionPercentage >= 70
                        ? Colors.blue
                        : Colors.orange,
              ),
            ),
          ),
          Text(
            '${completionPercentage.round()}%',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProfileCompletion() {
    double completion = 0;

    // 40% إذا كانت الصورة موجودة
    if (widget.data.profilePic != null && widget.data.profilePic!.isNotEmpty) {
      completion += 40;
    }

    // حساب نسبة الروابط (60% موزعة على الروابط)
    int linkCount = widget.data.links.length ?? 0;
    double linksPercentage = (linkCount / 4) * 60; // 4 روابط = 100%

    // لا تتجاوز النسبة 60% للروابط
    completion += linksPercentage.clamp(0, 60);

    // لا تتجاوز النسبة 100%
    return completion.clamp(0, 100);
  }

  Future<void> shareCompany({
    required String nameCompany,
    required String idCompany,
    required String imageUrl,
    required String accountType,
  }) async {
    try {
      setState(() {
        isLoadingShareAds = true;
      });
      String nameAdsUrl = accountType == 'individual'
          ? 'اسم المستخدم: $nameCompany\n'
          : 'اسم الشركة: $nameCompany\n';
      String urlShare = accountType == 'individual'
          ? '${AppEndpoints.deepLinksUrl}/user/$idCompany'
          : '${AppEndpoints.deepLinksUrl}/company/$idCompany';
      String url = imageUrl;
      if (imageUrl != 'null') {
        String filename = basename(url);
        Dio dio = Dio();
        Response response = await dio.get(url,
            options: Options(responseType: ResponseType.bytes));
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/$filename.jpg');
        file.createSync();
        file.writeAsBytesSync(response.data);
        print(file.existsSync());
        if (file.existsSync() == true) {
          await Share.shareXFiles([XFile(file.path)],
              text: nameAdsUrl + urlShare);
        }
      } else {
        await Share.share(nameAdsUrl + urlShare);
      }

      setState(() {
        isLoadingShareAds = false;
      });
      // print('ssssssssssssssssss');
    } catch (e) {
      setState(() {
        isLoadingShareAds = false;
      });
      print("Error in Share Ads : $e");
    }
  }

  Widget userRatingAndBusinessName(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [],
        ),
        Container(),
      ],
    );
  }

  bool isOwnerAccount() {
    return DIManager.findDep<SharedPrefs>().getUserID() ==
            widget.data.userId.toString()
        ? true
        : false;
  }

  Widget descUser() {
    return widget.data.note == null
        ? Container()
        : textNormal(
            text: widget.data.note ?? " ",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            fontSize: AppFontSize.fontSize_10,
            color: appTheme.deepPurpleA10001,
          );
  }

  Widget userEngagementInfo(context) {
    print('170.w : ${170.sp}');
    print('widget : ${MediaQuery.sizeOf(context).width}');
    print('widget : ${MediaQuery.sizeOf(context).width * 0.5}');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            sizeHeightNormal(
                height: 5
            ),
            textNormal(
              text: 'رقم العضوية: ${widget.data.membershipNumber.toString()}',
              fontWeight: FontWeight.w400,

              color: appTheme.greenColor,
            ),
            sizeHeightNormal(
              height: 5
            ),
            textNormal(
                text:
                    'تاريخ العضوية: ${formatDateWithArabicMonth(widget.data.createdAt!)}',
                color: Color(0xff8B8B8B),
                fontWeight: FontWeight.w400),
            sizeHeightNormal(
                height: 5
            ),
            descUser(),

            containerLinks(links: widget.data.links),
            sizeHeightNormal(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.data.hasMoreThan3000.toString() == '1') ...{
              // SizedBox(width: 10.w,),

              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: AppDecoration.outlineButtonLite.copyWith(
                    color: appTheme.whiteA700,
                    border: Border.all(color: appTheme.greenColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.2,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: textNormal(
                        text: '3K Followers+',
                        fontSize: 12,
                        color: appTheme.greenColor),
                ),
              ),
            } else ...{
              Container(
                width: 90,
                height: 10,
              )
            }
          ],
        ),
      ],
    );
  }
}
