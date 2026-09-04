import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';

import '../../../../../core/constants/app_font.dart';
import '../../../../../core/di/di_manager.dart';
import '../../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../../core/utils/endpoints.dart';
import '../../../../../core/utils/image_constant.dart';
import '../../../../../data/models/profile_company/profile_company_model.dart';
import '../../../../../widgets/components.dart';
import '../../../../../widgets/custom_image_view.dart';
import '../../../../../widgets/loader_for_page.dart';
import '../../../../../widgets/user_image_profile.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/theme_helper.dart';
import '../../../profile/cubit/cubit.dart';
import '../../info_company.dart';
import '../following_users_page.dart';

class UserMetricsCard extends StatefulWidget {
  UserMetricsCard({
    super.key,
    required this.companyInformation,
    required this.imageCompany,
    required this.isOwnerAccount,
    required this.followersCount,
    required this.followingCount,
    required this.adsCount,
    required this.postCount,
    required this.idCompany,
    required this.links,
    required this.ugcList,
  });

  List<DataCompany> companyInformation;
  List<Ugc> ugcList = [];
  List links;
  String? imageCompany;
  bool isOwnerAccount;
  int followersCount;
  int followingCount;
  int postCount;
  int adsCount;
  int idCompany;

  @override
  State<UserMetricsCard> createState() => _UserMetricsCardState();
}

class _UserMetricsCardState extends State<UserMetricsCard> {



  double _calculateProfileCompletion() {
    double completion = 0;

    if (widget.imageCompany.toString() != "null") {
      completion += 40;
    }

    if(widget.isOwnerAccount){
      if(DIManager.findDep<SharedPrefs>().getAccountType() ==
          'individual'){
        int linkCount = widget.ugcList.isEmpty ? 0:  widget.ugcList[0].links?.length??0;
        double linksPercentage = (linkCount / 4) * 60; // 4 روابط = 100%

        // لا تتجاوز النسبة 60% للروابط
        completion += linksPercentage.clamp(0, 60);

      }else{
        int linkCount = widget.links.length;
        double linksPercentage = (linkCount / 5) * 60; // 4 روابط = 100%

        // لا تتجاوز النسبة 60% للروابط
        completion += linksPercentage.clamp(0, 60);

      }

    }else{


      if(widget.companyInformation[0].account_type ==
          'individual'){
        int linkCount = widget.ugcList.isEmpty ? 0:  widget.ugcList[0].links?.length??0;
        double linksPercentage = (linkCount / 4) * 60; // 4 روابط = 100%

        // لا تتجاوز النسبة 60% للروابط
        completion += linksPercentage.clamp(0, 60);

      }else{
        int linkCount = widget.links.length;
        double linksPercentage = (linkCount / 5) * 60; // 4 روابط = 100%

        // لا تتجاوز النسبة 60% للروابط
        completion += linksPercentage.clamp(0, 60);

      }


    }

    // لا تتجاوز النسبة 100%
    return completion.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    double completionPercentage = _calculateProfileCompletion();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: ((widget.isOwnerAccount) &&  ( widget.ugcList.isEmpty &&  DIManager.findDep<SharedPrefs>().getAccountType() == 'individual')) ?1:
          ( widget.ugcList.isEmpty &&  widget.companyInformation[0].account_type == 'individual')?1:2,
            child: Stack(
              // alignment: Alignment.topLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if(widget.isOwnerAccount)...{
                        ( widget.ugcList.isEmpty &&  DIManager.findDep<SharedPrefs>().getAccountType() == 'individual')   ?Container():   SizedBox(
                          width: 58.sp,
                          height: 58.sp,
                          child: CircularProgressIndicator(
                            value: completionPercentage / 100,
                            strokeWidth: 1.4,
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
                      }else...{
                        ( widget.ugcList.isEmpty &&  widget.companyInformation[0].account_type == 'individual')   ?Container():   SizedBox(
                          width: 58.sp,
                          height: 58.sp,
                          child: CircularProgressIndicator(
                            value: completionPercentage / 100,
                            strokeWidth: 1.4,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              completionPercentage >= 90
                                  ? appTheme.greenColor
                                  : completionPercentage >= 70
                                  ? Colors.blue
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      },


                      UserImageProfile(
                          imageUrl:  widget.imageCompany.toString(),
                      height:60.sp,
                      width: 60.sp,),
                      if(widget.isOwnerAccount)...{
                        ( widget.ugcList.isEmpty &&  DIManager.findDep<SharedPrefs>().getAccountType() == 'individual')   ?Container():   Positioned(
                          right: 2,
                          bottom: 5,
                          child: Container(
                            decoration: AppDecoration.outlineCircular3.copyWith(borderRadius:BorderRadius.all(Radius.circular(66.r)),   boxShadow: [])  ,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '${completionPercentage.round()}%',
                                style: TextStyle(
                                  fontSize: 7.fSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      }else...{
                        ( widget.ugcList.isEmpty &&  widget.companyInformation[0].account_type == 'individual')   ?Container():   Positioned(
                          right: 2,
                          bottom: 5,
                          child: Container(
                            decoration: AppDecoration.outlineCircular3.copyWith(borderRadius:BorderRadius.all(Radius.circular(66.r)),   boxShadow: [])  ,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '${completionPercentage.round()}%',
                                style: TextStyle(
                                  fontSize: 7.fSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      },

                    ],
                  ),
                ),

                widget.isOwnerAccount
                    ? Positioned(
                  top: -5,
                      right: ((widget.isOwnerAccount) &&  ( widget.ugcList.isEmpty &&  DIManager.findDep<SharedPrefs>().getAccountType() == 'individual')) ?10: isTypeIpad(context)?50: 36,
                      child: IconButton(
                          onPressed: () {
                            ProfileCubit.get(context).loadImages();
                          },
                          icon: Icon(
                            Icons.camera_alt,
                                        size: 20.fSize,
                            color: appTheme.deepPurpleA10001,
                          )),
                    )
                    : Container(),
              ],
            ),
          ),
          Expanded(flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sizeHeightNormal(
                  height: 10
                ),
                Container(
                  width: 220.w,
                  child: Text(
                    widget.companyInformation?[0].companyName.toString() ?? '',
                    style: themeLite.textTheme.titleSmall!
                        .copyWith(fontSize: 15),
                  ),
                ),
                sizeHeightNormal(height: 5),
                widget.isOwnerAccount
                    ? Container(
                  child: RatingBarIndicator(
                    rating: double.parse(widget.companyInformation?[0].rating ?? '0')
                        .toDouble(),
                    itemCount: 5,
                    itemSize: 20,
                    unratedColor: Color(0xffc3c3c3),
                    direction: Axis.horizontal,
                    itemBuilder: (context, _) => CustomImageView(
                      imagePath: ImageConstant.starIcon,
                      width: 20,
                      height: 20,
                      color: Colors.yellow,
                    ),
                  ),
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    BlocConsumer<ProfileCubit,ProfileStates>(builder: (context,state){
                      return InkWell(
                          onTap: () {
                            showRatingAds(context, widget.idCompany,double.parse(widget.companyInformation?[0].rating ?? '0')
                                .toDouble(),);
                          },
                          child: state is LoadingEvaluateCompanyState
                              ? loaderNormal(size: 13)
                              : textNormal(
                              text: 'قيم الآن',
                              fontSize: AppFontSize.fontSize_12,color: Colors.grey,));
                    }, listener: (context,state){
                      if(state is SuccessEvaluateCompanyState){
                        SnackBarHelper.mySnackBarSuccess('تم تقييم الشركة بنجاح', context);
                      }else if(state is ErrorEvaluateCompanyState){
                        SnackBarHelper.mySnackBarError( state.error,context);
                      }
                    } ),

                    sizeWidthNormal(width: 5.w),
                    Container(
                      child: RatingBarIndicator(
                        rating:
                        double.parse(widget.companyInformation?[0].rating ?? '0')
                            .toDouble(),
                        itemCount: 5,
                        itemSize: 20,
                        unratedColor: Color(0xffc3c3c3),
                        direction: Axis.horizontal,
                        itemBuilder: (context, index) =>  CustomImageView(
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
          // Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10, right: 1.w),
            child: PopupMenuButton(
              padding: EdgeInsets.zero,
              color: appTheme.lightBlueBottomNavigatorBar,
              child: Icon(
                Icons.more_vert,
                color: appTheme.greenColor,
                size: 25.fSize,
              ),
              // Use a specific widget
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'share',
                  child: textNormal(text: 'مشاركة', fontSize: 13.fSize),
                ),
              ],
              onSelected: (value) {
                if (value == "share") {
                  shareCompany(
                    idCompany: widget.idCompany.toString(),
                    accountType: widget.companyInformation[0].account_type.toString(),
                    imageUrl: widget.imageCompany.toString() != 'null'
                        ? (widget.imageCompany.toString().contains('http')
                            ? widget.imageCompany.toString()
                            : AppEndpoints.baseUrlWithoutApi +
                                widget.imageCompany.toString())
                        : 'null',
                    nameCompany:
                        widget.companyInformation?[0].companyName.toString() ??
                            '',
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void showRatingAds(BuildContext context, companyId ,double? ratingOld) {
    ProfileCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = ratingOld?? 0.0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: appTheme.buttonColor,
                title: textNormal(
                    text: 'قيّم الشركة',
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
                      size: AppFontSize.fontSize_20,
                    ),
                    half: Icon(Icons.star_half, // لن تُستخدم لأن allowHalfRating = false
                        color: Colors.amber, size: AppFontSize.fontSize_20),
                    empty: Icon(Icons.star_border,
                        color: Colors.amber, size: AppFontSize.fontSize_20),
                  ),
                ),

                actions: [
                  InkWell(
                    child: textNormal(
                      text: AppLocalizations.of(context)!.cancel,
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

                      cubit.evaluateCompany(
                          companyId: int.parse(companyId.toString()),
                          value: rating);
                    },
                  ),
                ],
              );
            });
      },
    );
  }

  bool isLoadingShareAds = false;

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
      String nameAdsUrl = accountType == 'individual' ? 'اسم المستخدم: $nameCompany\n':'اسم الشركة: $nameCompany\n';
      String urlShare = accountType == 'individual' ?  '${AppEndpoints.deepLinksUrl}/user/$idCompany':  '${AppEndpoints.deepLinksUrl}/company/$idCompany';
      String url = imageUrl;
      print(imageUrl);
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
}
