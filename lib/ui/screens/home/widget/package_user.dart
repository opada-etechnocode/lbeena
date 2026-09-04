import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/home_page/packages_user_model.dart';
import '../../../../widgets/banner_item_shimmer.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../company/widget/following_users_page.dart';
import '../cubit/status.dart';

class PackageUserWidget extends StatefulWidget {
  const PackageUserWidget({super.key});

  @override
  State<PackageUserWidget> createState() => _PackageUserWidgetState();
}

class _PackageUserWidgetState extends State<PackageUserWidget> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getPackagesUser();
    super.initState();
  }
  PackagesUserModel? packagesUserModel;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20),
      child: BlocConsumer<HomeCubit, HomeStates>(

          listener: (context,state){
            if(state is SuccessPackagesUserState ){
              packagesUserModel=  state.packagesUserModel;
            }
            if(state is SuccessPayPackagesUserState){
              SnackBarHelper.mySnackBarSuccess(state.packagesUserModel.message, context);
              BlocProvider.of<HomeCubit>(context).getPackagesUser();
            }

            if(state is ErrorPayPackagesUserState){
              if(DIManager.findDep<SharedPrefs>().getToken()  != null){
                SnackBarHelper.mySnackBarError(state.error, context);
              }

            }
            // if(state is ErrorPackagesUserState){
            //   SnackBarHelper.mySnackBarError(state.error, context);
            // }

          },
        builder: (context,state){
            if(state is LoadingPackagesUserState){
              return Padding(
                padding:  EdgeInsets.only(top: 0),
                child: BannerItemShimmer(),
              );

            }  if(state is ErrorPackagesUserState){
              return Container();
            }


              return packagesUserModel==null ? Container(): Padding(
                padding:  EdgeInsets.only(top: 0),
                child: _buildPackageItem(context,packagesUserModel!.package!,state),
              );

        },),
    );
  }

  /// Section Widget
  Widget _buildPackageItem(
      BuildContext context, Package packageCompanyModel,state) {
    String colorPackage = packageCompanyModel.colorPackage!.substring(1);
    colorPackage = '0xFF$colorPackage';
    print(colorPackage);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child:  Container(
        height:isTypeIpad(context)?220.h: 180.h,
        decoration: AppDecoration.gradientPackage.copyWith(
          // color: Color(int.parse(colorPackage)),
            color: Color(int.parse(colorPackage)),
            border: Border.all(color: Color(int.parse(colorPackage))),
            // gradient: LinearGradient(
            //   begin: Alignment(0.97, 0.66),
            //   end: Alignment(0.60, 0.83),
            //   colors: [
            //     appTheme.whiteA700,
            //     Color(int.parse(colorPackage)),
            //   ],
            // ),
            boxShadow: [
            ],
            borderRadius: BorderRadius.circular(20.r)),
        child: Stack(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgPackageAccount,

              height: double.infinity,
              alignment: Alignment.center,
              width: double.infinity,

              fit: BoxFit.fill,
              // radius: BorderRadius.circular(15.r),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Padding(
                  padding: EdgeInsets.only(right:isTypeIpad(context)?120.w: 43.w,top: 0.h),
                  child: Row(
                    children: [
                      textNormal(
                        text: 'بطاقة عضوية',
                        color:Colors.black,
                        fontSize: AppFontSize.fontSize_18,fontWeight: FontWeight.w700,
                      ),
                      sizeWidthNormal(width: 30.w),
                      packageCompanyModel.freeAdsQty ==0? CustomElevatedButton(
                          width: 80.w,height: 30.h,buttonTextStyle: themeLite.textTheme.titleSmall!.copyWith(fontSize: 10.fSize),
                          onPressed: (){
                            if(state is! LoadingPayPackagesUserState){

                              BlocProvider.of<HomeCubit>(context).payPackagesUser();
                            }
                          },
                          text: 'تجديد',
                          child: (state is LoadingPayPackagesUserState)?loaderNormal(
                              size: 10,color: Colors.black
                          ): null):Container(),
                    ],
                  ),
                ),
                sizeWidthNormal(width:   packageCompanyModel.freeAdsQty ==0?40.w:80.w),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Container(
                    width: 280.w,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        profileOverview(
                            isFromPackage: true,
                            titleTop: '${packagesUserModel?.followersCount ?? 0}',titleBottom:  'المتابعين',onTap: (){
                          navigatorToPush(
                              context: context,
                              pageName: FollowingUsersPage(
                                titleAppBar: 'المتابعين',
                                isFollowers: true,
                                userId:int.parse(DIManager.findDep<SharedPrefs>().getUserID().toString()),

                              ));
                        }),
                        profileOverview( isFromPackage: true,titleTop: '${packagesUserModel?.followingCount ?? 0}',titleBottom:  'المتابعون',onTap: (){
                          navigatorToPush(context: context, pageName: FollowingUsersPage(
                            titleAppBar: 'المتابعون',
                            isFollowers: false,
                            userId:int.parse(DIManager.findDep<SharedPrefs>().getUserID().toString()),
                          ));
                        }),
                        profileOverview( isFromPackage: true,titleTop: packagesUserModel?.adsProductCount ??'0',titleBottom:  'الإعلانات',onTap: (){}),
                        profileOverview( isFromPackage: true,titleTop: packagesUserModel?.posts ??'0',titleBottom:  'منشورات',onTap: (){}),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 14.h),
                  child: Center(
                    child: Container(
                      width: 250.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileOverviewNumber(
                            titleTop: 'رقم العضوية:'
                            ,titleBottom:    DIManager.findDep<SharedPrefs>().getMembershipNumber().toString(),
                          ),
                          profileOverviewNumber(
                            titleTop: 'عدد النقاط:'
                            ,titleBottom:  packageCompanyModel.pointCount.toString(),
                          ),
                          profileOverviewNumber(
                            titleTop:'الإعلانات المتبقية:'
                            ,titleBottom:  packageCompanyModel.freeAdsQty.toString(),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
                packageCompanyModel.text_package == null ||  packageCompanyModel.text_package ==''?Container(): Padding(
                  padding:  EdgeInsets.only(top: 5.h),
                  child: Center(
                    child: textNormal(
                        text: '>> ${packageCompanyModel.text_package!} <<',
                        color: Colors.black, fontSize: AppFontSize.fontSize_9,fontWeight: FontWeight.w400),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
