import 'dart:io';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/profile_company/information_company.dart';
import 'package:syrians_in_uae/data/models/profile_company/profile_company_model.dart';
import 'package:syrians_in_uae/ui/screens/company/info_company.dart';
import 'package:syrians_in_uae/ui/screens/company/package_company.dart';
import 'package:syrians_in_uae/ui/screens/company/widget/following_users_page.dart';
import 'package:syrians_in_uae/ui/screens/company/widget/widgets_company_details/error_page.dart';
import 'package:syrians_in_uae/ui/screens/company/widget/widgets_company_details/user_metrics_card.dart';
import 'package:syrians_in_uae/ui/screens/details_product/details_product.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/widgets/company_info_shimmer.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../data/models/home_page/banner_product_model.dart';
import '../../../core/utils/endpoints.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../auth/login/model_home_page.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/ads_product_widget.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../community/list_coummunity.dart';
import '../profile/profile_page.dart';
import 'edit_company.dart';


class CompanyDetailsPage extends StatefulWidget {
  CompanyDetailsPage({
    super.key,
    required this.idCompany,
  });

  int idCompany;

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  bool isPressing2 = true;
  String? accountType;
  String createdAtTime = '';
  String joinedAtTime = '';
  bool loadingShimmer = true;
  bool isPressingAdsArchived = false;
  int typeAds = 2;
  String? imageCompany;
  String? descriptionCompany;
  XFile? fileLicense;
  String? statusCompany = '';
  bool isReadAll = false;
  int? isFollowUser;
  int? followingCount;
  int? followersCount;
  ProfileCompanyModel? profileCompanyModel;
  ProfileInformationCompanyModel? profileInformationCompanyModel;
  List<DataCompany>? companyInformation;
  List<DataProductBannerModel> adsProductPending = [];
  List<DataProductBannerModel> adsProductActive = [];
  List<DataProductBannerModel> adsProductExpired = [];
  List<DataProductBannerModel> adsProductUnacceptable = [];
  List<CommunityModelDatum>? communityPostModel = [];
  String? userNameCompany =
      DIManager.findDep<SharedPrefs>().getUserNameCompany();
  String? mobileNumber = DIManager.findDep<SharedPrefs>().getMobileNumber();
  String? ratingUser = DIManager.findDep<SharedPrefs>().getRatingUser();
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();
  String? idCompany = DIManager.findDep<SharedPrefs>().getUserID();
  int? adsCount;
  int? postCount;
  List<Ugc> ugcList = [];
  HomePageLoginModel? homePageData;

  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printInFirst();
    return BlocProvider(
      create: (context) {
        if (isOwnerAccount()) {
          return ProfileCubit()
            ..getInformationCompanyAbout()
            ..getInformationCompanyForAdvertisersAdmin()
            // ..changeAdsFromExpired()
            ..getPostUser();
        } else {

          if( DIManager.findDep<SharedPrefs>().getUserID().toString() !='null'){
            return ProfileCubit()
              ..isFollowThisUser(userId: widget.idCompany)
              ..getInfoMyCompany(idCompany: widget.idCompany);
          }else{
            return ProfileCubit()
              // ..getDescriptionCompany(idCompany: widget.idCompany)
              ..getInfoMyCompany(idCompany: widget.idCompany);
          }

        }
      },
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) => listenerBloc(context, state),
        builder: (context, state) => screenPage(context, state),
      ),
    );
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isShowAllDescUser = false;

  bool isOwnerAccount() {
    return userId == widget.idCompany.toString() ? true : false;
  }

  void listenerBloc(context, state) {
    /// Following
    if (state is SuccessIsFollowingUserState) {
      isFollowUser = state.isFollowingModel?.isFollowing;
    }

    if (state is SuccessFollowingUserState) {
      isFollowUser = 1;
      followersCount = followersCount! + 1;
    }

    if (state is SuccessUnFollowingUserState) {
      isFollowUser = 0;
      followersCount = followersCount! - 1;
    }
    if (state is SuccessGetStatusUserState) {
      DIManager.findDep<SharedPrefs>().setToken(state.statusUserResult.token);
      DIManager.findDep<SharedPrefs>()
          .setStatusUser(state.statusUserResult.statusUser);
      statusCompany = state.statusUserResult.statusUser;
      DIManager.findDep<SharedPrefs>()
          .setAccountType(state.statusUserResult.accountType);

      DIManager.findDep<SharedPrefs>()
          .setStatusUGC(state.statusUserResult.is_ugc ?? false);
    }
    if (state is SuccessGetPostUserState) {
      communityPostModel = state.data.data!;
      postCount = state.data.data!.length;
    }
    if (state is SuccessCompanyInformationState) {


      handleCompanyData(state, context);
    }

    if (state is SuccessCompanyDescriptionState) {
      descriptionCompany =
          state.profileInformationCompanyModel.data!.description;
    }
    if (state is SuccessCompanyInformationAboutState) {
      profileInformationCompanyModel = state.profileInformationCompanyModel;
      accountType =
          state.profileInformationCompanyModel.data!.user!.account_type;
    }

    if (state is SuccessLoadFileProfileState) {
      fileLicense = state.fileLicense;
      ProfileCubit.get(context).editImageProfile(
        image: File(fileLicense!.path),
      );
    }

    if (state is SuccessEditImageProfileState) {
      imageCompany = state.editInformationCompanyModel!.data!.profilePic;
      DIManager.findDep<SharedPrefs>().setImageProfile(imageCompany);
    }

    if (state is ErrorEditImageProfileState) {
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }

    if (state is SuccessEvaluateCompanyState) {
      if( DIManager.findDep<SharedPrefs>().getUserID().toString() !='null'){
        ProfileCubit.get(context).isFollowThisUser(userId: widget.idCompany);
      }
      ProfileCubit.get(context).getInfoMyCompany(idCompany: widget.idCompany,
      isLoading: false);
      SnackBarHelper.mySnackBarSuccess('تم تقييم الشركة بنجاح', context);
    }
    if (state is ErrorEvaluateCompanyState) {
      SnackBarHelper.mySnackBarError(
          'فشل تقييم الشركة الرجاء المحاولة مرة أخرى ..', context);
    }
    if (state is LoadingCompanyInformationState) {
      loadingShimmer = true;
    }
    if (state is LoadingPackageCompanyState) {
      loadingShimmer = true;
    }
    if (state is LoadingCompanyInformationAboutState) {
      loadingShimmer = true;
    }
    if(state is SuccessEditSocialMediaCompanyListState){
      isEditAds = false;
      linksCompany=    controllers
          .map((controller) => controller.text)
          .where((text) => text.isNotEmpty)
          .toList();
      SnackBarHelper.mySnackBarSuccess(state.data!.message.toString(), context);
    }
    if(state is ErrorEditSocialMediaCompanyListState){
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }
  }

  Widget screenPage(context, state) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: (isOwnerAccount())
            ? appBarNormalWithIcon(
                text: DIManager.findDep<SharedPrefs>().getAccountType() ==
                        'individual'
                    ? 'ملف شخصي'
                    : 'ملف الشركة',
                context: context,
                isShowBack: true,

        )
            : appBarNormalWithIcon(
                text: accountType == 'individual'
                    ? 'ملف شخصي'
                    : accountType == 'company'
                        ? 'ملف الشركة'
                        : '',
                context: context,
                isShowBack: true),
        body: Column(
          children: [
            sizeHeightNormal(),
            Expanded(
              flex: 2,
              child: SmartRefreshWidget(
                  onRefresh: () {
                    if( DIManager.findDep<SharedPrefs>().getUserID().toString() !='null'){
                      ProfileCubit.get(context).getStatusUser();
                    }
                    if (isOwnerAccount()) {
                      ProfileCubit.get(context).getPackageCompany();
                      ProfileCubit.get(context).getInformationCompanyForAdvertisersAdmin();
                      ProfileCubit.get(context).getInformationCompanyAbout();
                      ProfileCubit.get(context).getPostUser();
                    } else {
                      if( DIManager.findDep<SharedPrefs>().getUserID().toString() !='null'){
                        ProfileCubit.get(context).isFollowThisUser(userId: widget.idCompany);
                      }
                      ProfileCubit.get(context).getInfoMyCompany(idCompany: widget.idCompany);
                      // ProfileCubit.get(context).getDescriptionCompany(idCompany: widget.idCompany);
                    }
                    _refreshController.refreshCompleted();
                  },
                  controller: _refreshController,
                  enablePullUp: false,
                  onLoading: () {},
                  child: SingleChildScrollView(
                    // physics: BouncingScrollPhysics(),
                    child: state is ErrorCompanyInformationState
                        ? ErrorCompanyDetailsPage()
                        : loadingShimmer
                            ? CompanyInformationShimmer()
                            : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoadingShareAds) ...{loadingButton()},

                                    Container(
                                      // width: 350.w,
                                      decoration: AppDecoration.profileUi,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            userMetricsCard(),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                profileOverviewCompany(
                                                    titleTop: '${followersCount ?? 0}',
                                                    titleBottom: 'متابع',
                                                    onTap: () {
                                                      navigatorToPush(
                                                          context: context,
                                                          pageName: FollowingUsersPage(
                                                            titleAppBar: 'متابع',
                                                            isFollowers: true,
                                                            userId: widget.idCompany,
                                                          ));
                                                    }),
                                                profileOverviewCompany(
                                                    titleTop: '${followingCount ?? 0}',
                                                    titleBottom: 'يتابع',
                                                    onTap: () {
                                                      navigatorToPush(
                                                          context: context,
                                                          pageName: FollowingUsersPage(
                                                            titleAppBar: 'يتابع',
                                                            isFollowers: false,
                                                            userId: widget.idCompany,
                                                          ));
                                                    }),
                                                profileOverviewCompany(
                                                    titleTop: '${adsCount ?? '0'}',
                                                    titleBottom: 'إعلانات',
                                                    onTap: () {}),
                                                profileOverviewCompany(
                                                    titleTop: '${postCount ?? '0'}',
                                                    titleBottom: 'منشورات',
                                                    onTap: () {}),
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            if (isOwnerAccount() &&  DIManager.findDep<SharedPrefs>().getAccountType() =='company') ...{
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isEditAds = !isEditAds;

                                                    });
                                                  },
                                                  child: textNormal(
                                                      text: companyInformation![0]
                                                              .links
                                                              .isNotEmpty
                                                          ? 'تعديل روابط شركتك'
                                                          : 'أضف روابط لشركتك',
                                                      fontSize:
                                                          AppFontSize.fontSize_10,
                                                      color: appTheme.greenColor,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              editAdsAnimations(context, state),
                                            },

                                            SizedBox(height: 4.h),
                                            userRatingAndBusinessName(
                                                context, state),
                                            SizedBox(height: 4.h),
                                            userEngagementInfo(context),
                                                userButton(context, state),
                                          ],
                                        ),
                                      ),
                                    ),

                                    sizeHeightNormal(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [

                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isPressing2 = true;
                                                    typeAds =2;
                                                    // isCompany = false;
                                                  });
                                                },
                                                child: Container(

                                                  decoration: !isPressing2
                                                      ? BoxDecoration(
                                                    color: appTheme.white,
                                                    borderRadius: BorderRadius.circular(8)
                                                  )
                                                      : BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: appTheme
                                                          .deepPurpleA10001,
                                                  ),
                                                  child:     Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Center(
                                                      child: textNormal(
                                                        text:   'إعلانات',
                                                        color: isPressing2
                                                            ? Colors
                                                            .white
                                                            : Colors
                                                            .grey,

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isPressing2 = false;
                                                    typeAds = 5;
                                                    // isCompany = true;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: isPressing2
                                                      ? BoxDecoration(
                                                    color: appTheme.white,  borderRadius: BorderRadius.circular(8)
                                                  )
                                                      : BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),

                                                      color: appTheme
                                                          .deepPurpleA10001,
                                                   ),
                                                  child:   Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Center(
                                                      child: textNormal(
                                                      text:   'منشورات',
                                                        color: !isPressing2
                                                            ? Colors
                                                            .white
                                                            : Colors
                                                            .grey,

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizeHeightNormal(height:  isOwnerAccount() && isPressing2? 20:5),
                                        isOwnerAccount() && isPressing2
                                            ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                buttonChoose(indexTypeAds: 2,title: 'فعالة'),
                                                buttonChoose(indexTypeAds: 1,title: 'مرفوضة'),
                                                buttonChoose(indexTypeAds: 3,title: 'قيد الانتظار'),
                                                buttonChoose(indexTypeAds: 4,title: 'منتهية الصلاحية'),
                                              ],
                                            )
                                            : Container(),
                                        sizeHeightNormal(
                                            height: AppHeightAndWidthSize
                                                .heightSize_10),


                                        if (typeAds == 5) ...{
                                          ListCommunity(
                                            communityPostModel:
                                                communityPostModel!,
                                            page: 1,
                                            isFromUserPage: true,
                                            isStopNavigation: true,
                                            company: '1',
                                          )
                                        }
                                      ],
                                    ),
                                    if (isOwnerAccount()) ...{
                                    if (typeAds == 1) ...{
                                      _buildAdsItems(
                                          context, adsProductUnacceptable),
                                      } else if (typeAds == 2) ...{
                                      _buildAdsItems(
                                          context, adsProductActive),
                                      } else if (typeAds == 3) ...{
                                      _buildAdsItems(
                                          context, adsProductPending),
                                      } else if (typeAds == 4) ...{
                                      _buildAdsItems(
                                          context, adsProductExpired),
                                      },
                                    } else ...{
                                      isPressing2
                                          ? _buildAdsItems(
                                              context,
                                              profileCompanyModel!
                                                  .data!.adsProduct)
                                          : ListCommunity(
                                              communityPostModel:
                                                  communityPostModel!,
                                              page: 1,
                                              isFromUserPage: true,
                                              isStopNavigation: true,
                                            ),
                                    },
                                  ],
                                ),
                            ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonChoose({required int indexTypeAds,required String title}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            typeAds = indexTypeAds;
          });
        },
        child: Container(
          // height: 50,
          decoration: typeAds != indexTypeAds
              ? BoxDecoration(
            color: appTheme.scaffoldBackgroundColor100,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(
                color: Colors
                    .grey),
          )
              : BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(
                  color: appTheme.greenColor),
              color: appTheme.scaffoldBackgroundColor100,
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
            child: Text(title,
              style: themeLite
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                  color: typeAds == indexTypeAds?appTheme.greenColor: Colors
                      .grey,
                  fontSize:
                  AppFontSize
                      .fontSize_12,
                  fontWeight:
                  FontWeight
                      .w400),
            ),
          ),
        ),
      ),
    );
  }
  Widget userMetricsCard() {
    return UserMetricsCard(
      adsCount: adsCount ?? 0,
      companyInformation: companyInformation ?? [],
      followersCount: followersCount ?? 0,
      followingCount: followingCount ?? 0,
      idCompany: widget.idCompany,
      imageCompany: imageCompany,
      isOwnerAccount: isOwnerAccount(),
      postCount: postCount ?? 0,
      ugcList:ugcList,
      links: linksCompany,
    );
  }

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> companyLinks = [
    "",
    "",
    "",
    "",
    "",
  ];
  List linksCompany=[];
  List<TextEditingController> controllers =
      List.generate(5, (index) => TextEditingController());
  List<FocusNode> focusNode = List.generate(5, (index) => FocusNode());
  final predefinedLabels = [
    "رابط الفيسبوك ..",
    "رابط إنستغرام ..",
    "رابط تيك توك ..",
    "رابط موقعك على خرائط Google ..",
    "رابط موقعك الإلكتروني ..",
  ];

  String? findLinkByKeyword(List<LinkSocialMedia> links, String keyword) {
    return links.firstWhere(
          (link) => link.url?.toLowerCase().contains(keyword.toLowerCase()) ?? false,
      orElse: () => LinkSocialMedia(id: null, name: null, url: null),
    ).url;
  }

  String? findWebsiteLink(List<LinkSocialMedia> links, List<String> usedKeywords) {
    return links.firstWhere(
          (link) {
        final url = link.url?.toLowerCase() ?? '';
        return !usedKeywords.any((keyword) => url.contains(keyword));
      },
      orElse: () => LinkSocialMedia(id: null, name: null, url: null),
    ).url;
  }



  Widget editAdsAnimations(BuildContext context, state) {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:BoxDecoration(
          color: appTheme.greenColor,
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          border: Border.all(    color: Color(0xffc3ccd1)),
        ),
        child: AnimatedCrossFade(
          firstChild: Container(

          ),
          secondChild: Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: companyLinks.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: CustomTextFormField(
                        onChanged: (value) {
                          companyLinks[index] = value;
                        },
                        height: 40.h,
                        focusNode: focusNode[index],
                        controller: controllers[index],
                        hintText: predefinedLabels[index],
                        hintStyle: themeLite.textTheme.bodyMedium!
                            .copyWith(color: Colors.grey, fontSize: 12.fSize),
                        borderDecoration: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },

                ),
                sizeHeightNormal(height: 5.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomElevatedButton(
                    text: companyInformation![0]
                        .links
                        .isNotEmpty? "تعديل": 'أضف',
                    height: 30.h,
                    width: 70.w,
                    onPressed: () {
                      // الحصول على كل النصوص من الكونترولرز
                      final texts = controllers.map((controller) => controller.text.trim()).toList();

                      // إذا كل العناصر كانت فاضية (linksCompany كانت فاضية وكل النصوص فاضية)
                      final allEmpty = linksCompany.isEmpty && texts.every((text) => text.isEmpty);

                      if (allEmpty) {
                        SnackBarHelper.mySnackBarError('يجب ملء حقل واحد على الأقل', context);
                        return;
                      }

                      // إرسال القيم المعبّية فقط
                      ProfileCubit.get(context).editSocialMediaCompanyList(
                        socialMediaCompanyList: texts.where((text) => text.isNotEmpty).toList(),
                      );
                    },

                    buttonTextStyle: themeLite.textTheme.bodySmall,
                    child: state is LoadingEditSocialMediaCompanyListState
                        ? LoadingAnimationWidget.threeRotatingDots(
                      // color:  appTheme.white,
                      color:  appTheme.greenColor,
                      size: 35,
                    )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          duration: Duration(milliseconds: 400),
          crossFadeState:
              isEditAds ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  bool isEditAds = false;

  Widget userRatingAndBusinessName(context, state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ugcList!.isNotEmpty
                ? Row(
                    children: [
                      ugcList![0].category_name == null
                          ? Container()
                          : textNormal(
                              text: ugcList![0].category_name ?? '',
                              fontSize: AppFontSize.fontSize_10,
                              color: appTheme.greenColor),
                      ugcList![0].city_name == null
                          ? Container()
                          : textNormal(
                              text: ' ,',
                              fontSize: AppFontSize.fontSize_10,
                              color: appTheme.greenColor),
                      ugcList![0].city_name == null
                          ? Container()
                          : textNormal(
                              text: ugcList![0].city_name ?? '',
                              fontSize: AppFontSize.fontSize_10,
                              color: appTheme.greenColor),
                    ],
                  )
                : Container(),


          ],
        ),
        Container(),
      ],
    );
  }

  Widget userEngagementInfo(context) {
    return ugcList.isNotEmpty && ugcList[0].links!.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  isOwnerAccount()?   textNormal(
                      text:'رقم العضوية: ${ DIManager.findDep<SharedPrefs>().getMembershipNumber().toString()}',

                      color:appTheme.greenColor,
                      fontWeight: FontWeight.w400)
                      : textNormal(text:'رقم العضوية: ${companyInformation![0].membershipNumber.toString()}',

                      color:appTheme.greenColor,
                      fontWeight: FontWeight.w400
                  ),
                  textNormal(text:'تاريخ العضوية: $createdAtTime',
                      color:Color(0xff8B8B8B),
                      fontWeight: FontWeight.w400),


                ],
              ),
              if (isOwnerAccount() &&
                  DIManager.findDep<SharedPrefs>().getAccountType() ==
                      'individual') ...{descUser()},
              accountType == 'individual' ? descUser() : Container(),
              if (isOwnerAccount()) ...{
                statusCompany == '0'
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: textNormal(
                          text: 'الشركة قيد انتظار الموافقة',
                          color: Colors.orange,
                          fontSize: AppFontSize.fontSize_10,
                        ),
                      )
                    : statusCompany == '1'
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: textNormal(
                              text: 'الشركة فعالة',
                              color: Colors.green,
                              fontSize: AppFontSize.fontSize_10,
                            ),
                          )
                        : statusCompany == '2'
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    textNormal(
                                        text: 'الشركة مرفوضة',
                                        color: Colors.red,
                                        fontSize: AppFontSize.fontSize_10,
                                        fontWeight: FontWeight.w600),
                                    sizeWidthNormal(),
                                    InkWell(
                                      onTap: () {
                                        showAboutCompany(
                                            context,
                                            companyInformation![0].note ??
                                                'تواصل مع الدعم لمعرفة السبب ..',
                                            'سبب الرفض');
                                      },
                                      child: textNormal(
                                          text: 'انقر هنا',
                                          color: Colors.red,
                                          fontSize: AppFontSize.fontSize_10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
              },
              SizedBox(height: 5,),
              containerLinks(links: ugcList![0].links!),

            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isOwnerAccount()?   textNormal(
                  text:'رقم العضوية: ${ DIManager.findDep<SharedPrefs>().getMembershipNumber().toString()}',

                  color:appTheme.greenColor,
                  fontWeight: FontWeight.w400)
                  : textNormal(text:'رقم العضوية: ${companyInformation![0].membershipNumber.toString()}',

                  color:appTheme.greenColor,
                  fontWeight: FontWeight.w400
              ),
              textNormal(text:'تاريخ العضوية: $createdAtTime',
                  color:Color(0xff8B8B8B),
                  fontWeight: FontWeight.w400),
              if (isOwnerAccount() &&
                  DIManager.findDep<SharedPrefs>().getAccountType() ==
                      'individual') ...{descUser()},
              accountType == 'individual' ? descUser() : Container(),
              Row(
                children: [
                  companyInformation?[0].business_activities_name == null
                      ? Container()
                      : textNormal(
                          text:
                              companyInformation?[0].business_activities_name ??
                                  '',
                          fontSize: AppFontSize.fontSize_10,
                          color: appTheme.greenColor),
                  sizeWidthNormal(width: 4.w),
                  if (isOwnerAccount()) ...{
                    statusCompany == '0'
                        ? textNormal(
                            text: 'الشركة قيد انتظار الموافقة',
                            color: Colors.orange,
                            fontSize: AppFontSize.fontSize_10,
                          )
                        : statusCompany == '1'
                            ? textNormal(
                                text: 'الشركة فعالة',
                                color: Colors.green,
                                fontSize: AppFontSize.fontSize_10,
                              )
                            : statusCompany == '2'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textNormal(
                                          text: 'الشركة مرفوضة',
                                          color: Colors.red,
                                          fontSize: AppFontSize.fontSize_10,
                                          fontWeight: FontWeight.w600),
                                      sizeWidthNormal(),
                                      InkWell(
                                        onTap: () {
                                          showAboutCompany(
                                              context,
                                              companyInformation![0].note ??
                                                  'تواصل مع الدعم لمعرفة السبب ..',
                                              'سبب الرفض');
                                        },
                                        child: textNormal(
                                            text: 'انقر هنا',
                                            color: Colors.red,
                                            fontSize: AppFontSize.fontSize_10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : Container(),
                  },
                ],
              ),
              Container(),
            ],
          );
  }

  Widget descUser() {
    return companyInformation![0].desc_user == null
        ? Container()
        : Row(
            children: [
              Expanded(
                child: Text(
                  overflow: isShowAllDescUser
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  companyInformation![0].desc_user ?? " ",
                ),
              ),
              isShowAllDescUser
                  ? Container()
                  : companyInformation![0].desc_user.toString().length >=60?  InkWell(
                      onTap: () {
                        setState(() {
                          isShowAllDescUser = !isShowAllDescUser;
                        });
                      },
                      child: textNormal(
                          overflow: TextOverflow.ellipsis,
                          text: 'قراءة المزيد',
                          color: Colors.blue,
                          fontSize: 10.fSize,
                          fontWeight: FontWeight.w200),
                    ):Container(),
            ],
          );
  }

  Widget userButton(context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        sizeHeightNormal(height: 5.h),
        linksCompany.isEmpty?Container():  iconsSocialMedia(),

        if (isOwnerAccount()) ...{
          sizeHeightNormal(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                text: 'تعديل',
                onTap: () {
                  if (DIManager.findDep<SharedPrefs>().getAccountType() !=
                      'individual') {
                    if (statusCompany == '1') {
                      navigatorToPush(
                          context: context,
                          pageName: EditCompanyPage(
                            informationCompany:
                                profileInformationCompanyModel,
                            mobileNumber: mobileNumber,
                            companyData: companyData,
                          ));
                    } else if (statusCompany == '0') {
                      SnackBarHelper.mySnackBarPending(
                          'حساب شركتك قيد المراجعة يرجى الانتظار ..',
                          context);
                    }
                  } else {
                    navigatorToPush(
                        context: context,
                        pageName: ProfilePage(
                          ugcList: ugcList,
                          dateHomePage: homePageData!,
                        ));
                  }
                },
              ),
              if (DIManager.findDep<SharedPrefs>().getAccountType() !=
                  'individual') ...{
                SizedBox(
                  width: 15,
                ),
                _buildButton(
                  text: 'عن الشركة',
                  onTap: () {
                    isOwnerAccount()
                        ? navigatorToPush(
                            context: context,
                            pageName: InformationCompanyPage(
                              informationCompany:
                                  profileInformationCompanyModel,
                              createAt: createdAtTime,
                              joinAt: joinedAtTime,
                            ))
                        : showAboutCompany(context, descriptionCompany, null);
                  },
                ),
              },
              SizedBox(
                width: 15,
              ),
              _buildButton(
                text: 'بطاقة العضوية',
                isChangeColor: true,
                onTap: () {
                  if (DIManager.findDep<SharedPrefs>().getAccountType() !=
                      'individual') {
                    if (statusCompany == '1') {
                      navigatorToPush(
                          context: context, pageName: PackageCompanyPage());
                    } else if (statusCompany == '0') {
                      SnackBarHelper.mySnackBarPending(
                          'حساب شركتك قيد المراجعة يرجى الانتظار ..',
                          context);
                    } else if (statusCompany == '2') {
                      SnackBarHelper.mySnackBarError(
                          ' تم رفض حسابك الرجاء مراجعة الدعم ..', context);
                    }
                  } else {
                    navigatorToPush(
                        context: context, pageName: PackageCompanyPage());
                  }
                },
              ),
            ],
          ),
        } else ...{
          sizeHeightNormal(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (accountType != 'individual') ...{
                _buildButton(
                  text: 'عن الشركة',
                  onTap: () {
                    isOwnerAccount()
                        ? navigatorToPush(
                            context: context,
                            pageName: InformationCompanyPage(
                              informationCompany:
                                  profileInformationCompanyModel,
                              createAt: createdAtTime,
                              joinAt: joinedAtTime,
                            ))
                        : showAboutCompany(context, descriptionCompany, null);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              },

              isFollowUser != null
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          if (isFollowUser == 1) {
                            ProfileCubit.get(context)
                                .unFollowThisUser(userId: widget.idCompany);
                          }

                          if (isFollowUser == 0) {
                            ProfileCubit.get(context)
                                .followThisUser(userId: widget.idCompany);
                          }
                        },
                        child: Container(
                          height: 38.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                              color: appTheme.greenColor,
                              borderRadius: BorderRadius.circular(16.h)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (state is LoadingUnFollowingUserState ||
                                      state is LoadingFollowingUserState)
                                  ? loadingButton()
                                  : Text(
                                      isFollowUser == 1
                                          ? 'إلغاء المتابعة'
                                          : 'متابعة',
                                      style: themeLite.textTheme.titleSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        },
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildButton({
    required void Function() onTap,
    required String text,
    bool isChangeColor = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 38.h,
          width: 120.h,
          decoration: BoxDecoration(
              color: isChangeColor?appTheme.backgroundContainer: appTheme.greenColor,
              border: isChangeColor?Border.all(color: appTheme.greenColor):null,
              borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Text(
              text,
              style:
                  themeLite.textTheme.titleSmall!.copyWith(color: isChangeColor?appTheme.greenColor: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void clearLists() {
    adsProductPending = [];
    adsProductActive = [];
    adsProductUnacceptable = [];
    adsProductExpired = [];
  }

  void filterAdsByStatus(state) {
    for (int i = 0;
        i < state.profileCompanyModel.data!.adsProduct.length;
        i++) {
      if (state.profileCompanyModel.data!.adsProduct[i].paymentStatus ==
              'unpaid' &&
          state.profileCompanyModel.data!.adsProduct[i].status == '0') {
      } else if (state.profileCompanyModel.data!.adsProduct[i].status == '1') {
        adsProductActive.add(state.profileCompanyModel.data!.adsProduct[i]);
      } else if (state.profileCompanyModel.data!.adsProduct[i].status == '2') {
        adsProductUnacceptable
            .add(state.profileCompanyModel.data!.adsProduct[i]);
      } else if (state.profileCompanyModel.data!.adsProduct[i].status == '0') {
        adsProductPending.add(state.profileCompanyModel.data!.adsProduct[i]);
      } else if (state.profileCompanyModel.data!.adsProduct[i].status == '3') {
        adsProductExpired.add(state.profileCompanyModel.data!.adsProduct[i]);
      }
    }
  }


  void convertCompanyDates(state) {
    String createdAt =
        state.profileCompanyModel.data!.company[0].createdAt.toString();
    String joinedAt =
        state.profileCompanyModel.data!.company[0].joinedAt == null
            ? "2000-05-09T16:54:17.000000Z"
            : state.profileCompanyModel.data!.company[0].joinedAt.toString();
    DateTime createdAtDateTime = DateTime.parse(createdAt);
    DateTime joinedAtDateTime = DateTime.parse(joinedAt);
    createdAtTime = formatDateWithArabicMonth(createdAtDateTime);
    joinedAtTime = DateFormat('yyyy-MM-dd').format(joinedAtDateTime);
  }


  void updateCompanyInfo(SuccessCompanyInformationState state) {
    profileCompanyModel = state.profileCompanyModel;
    companyInformation = state.profileCompanyModel.data!.company;
    ugcList = state.profileCompanyModel.data!.company[0].ugc ?? [];
    followersCount = state.profileCompanyModel.data!.company[0].followers_count;
    followingCount = state.profileCompanyModel.data!.company[0].following_count;
    imageCompany = profileCompanyModel!.data!.company[0].profilePic.toString();
    accountType = profileCompanyModel!.data!.company[0].account_type;

    if (isOwnerAccount()) {
      DIManager.findDep<SharedPrefs>().setImageProfile(imageCompany);
    }

    if (!isOwnerAccount()) {
      communityPostModel = state.profileCompanyModel.data!.posts;
      postCount = state.profileCompanyModel.data!.posts.length;
      adsCount = state.profileCompanyModel.data!.adsProduct.length;
    }
  }

  void handleCompanyData(SuccessCompanyInformationState state, context) {
    updateCompanyInfo(state);
    if( DIManager.findDep<SharedPrefs>().getUserID().toString() !='null'){
      ProfileCubit.get(context).getStatusUser();

    }

    if( state.profileCompanyModel.data!.company[0].account_type != 'individual' && !isOwnerAccount()  ) {
      ProfileCubit.get(context).getDescriptionCompany(idCompany: widget.idCompany);
    }
    clearLists();
    filterAdsByStatus(state);
    convertCompanyDates(state);
    if (isOwnerAccount()) {
      adsCount = state.profileCompanyModel.data!.adsProduct.length;
    }
    if (state.profileCompanyModel.data!.company[0].links.isNotEmpty) {
      List<LinkSocialMedia> links =
          state.profileCompanyModel.data!.company[0].links;

      final keywords = ['facebook', 'instagram', 'tiktok', 'google'];

      controllers = List.generate(5, (index) {
        if (index < 4) {
          String? url = findLinkByKeyword(links, keywords[index]);
          return TextEditingController(text: url ?? "");
        } else {
          String? url = findWebsiteLink(links, keywords);
          return TextEditingController(text: url ?? "");
        }
      });
      linksCompany= controllers
          .map((controller) => controller.text)
          .where((text) => text.isNotEmpty)
          .toList();
      focusNode = List.generate(
        5,
            (index) => FocusNode(),
      );
    }

    companyData = state.profileCompanyModel.data!.company[0];
    loadingShimmer = false;
  }

  DataCompany? companyData ;
  void printInFirst() {
    print(
        'AllCompanyPage: ___________idCompany: {$idCompany}__________________________');
    print(
        'AllCompanyPage: package:syrians_in_uae/ui/screens/company/company_details_page.dart');
    print(
        'AllCompanyPage: ____________idCompany: {$idCompany}____________________________');
    print(
        'AllCompanyPage: ____________idCompany: {$userId}____________________________');
  }

  List<String> iconsSocial=[
    ImageConstant.facebookIcon,
    ImageConstant.instagramIcon,
    ImageConstant.tiktokIcon,
    ImageConstant.gpsIcon,
    ImageConstant.webIcon,

  ];

  Widget iconsSocialMedia() {
    List<String> linksCompany = controllers.map((c) => c.text.trim()).toList();
    return SizedBox(
      height: 35.h,
      width: 200.w,
      child: ListView.builder(
        itemCount: iconsSocial.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final hasLink = linksCompany.length > index && linksCompany[index].isNotEmpty;
          final iconColor = hasLink ? appTheme.greenColor : Colors.grey;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.7.w),
            child: InkWell(

              onTap: hasLink
                  ? () async {
                final url = linksCompany[index];
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              }
                  : null,
              child: CustomImageView(
                imagePath: iconsSocial[index],
                height: 25.h,
                width: 25.h,
                color: iconColor,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildAdsItems(
      BuildContext context, List<DataProductBannerModel> adsProduct) {
    return Column(
      children: [
        adsProduct.isEmpty
            ? Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: Center(
                  child: textNormal(
                      text: AppLocalizations.of(context)!.dont_have_product),
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: adsProduct.length,
                  itemBuilder: (context, index) {
                    // if(adsProduct[index].paymentStatus)
                    if (isOwnerAccount()) {
                      return InkWell(
                        onTap: () {
                          navigatorToPush(
                              context: context,
                              pageName: DetailsProduct(
                                idBannerOrProduct: int.parse(
                                  adsProduct[index].adsId!,
                                ),
                                categoryId:
                                    adsProduct[index].categoryId!.toString(),
                                idAds: adsProduct[index].adsId!.toString(),
                                adsName: adsProduct[index].name,
                                detailsProduct: adsProduct[index],
                                idAdOnwerCompany:
                                    int.parse(adsProduct[index].userId!),
                              ));
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            AdsProductWidget(
                              dataProductItem: adsProduct[index],
                              isStopNavigation: true,
                              isFromDetailsProfile: true,
                            ),
                            isOwnerAccount()
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.h,
                                        left: 3.w,
                                        right: 3.w,
                                        bottom: 5.h),
                                    child: adsProduct[index].paymentStatus ==
                                                'unpaid' &&
                                            adsProduct[index].status == '0'
                                        ? Container(
                                            decoration: AppDecoration.fillWhiteA
                                                .copyWith(
                                                    color: Colors.yellow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r)),
                                            width: 50.w,
                                            height: 20.w,
                                            child: Center(
                                              child: textNormal(
                                                  color: Colors.black,
                                                  text: "غير مدفوع",
                                                  fontSize:
                                                      AppFontSize.fontSize_8),
                                            ),
                                          )
                                        : Container(
                                            decoration: AppDecoration.fillWhiteA
                                                .copyWith(
                                                    color: adsProduct[index]
                                                                .status ==
                                                            '0'
                                                        ? Colors.yellow
                                                        : adsProduct[index]
                                                                    .status ==
                                                                '1'
                                                            ? Colors.green
                                                            : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r)),
                                            width: 50.w,
                                            height: 20.w,
                                            child: Center(
                                              child: textNormal(
                                                  color: adsProduct[index]
                                                              .status ==
                                                          '0'
                                                      ? Colors.black
                                                      : Colors.white,
                                                  text: adsProduct[index]
                                                              .status ==
                                                          '0'
                                                      ? 'قيد الانتظار'
                                                      : adsProduct[index]
                                                                  .status ==
                                                              '1'
                                                          ? 'فعال'
                                                          : adsProduct[index]
                                                                      .status ==
                                                                  '2'
                                                              ? 'مرفوض'
                                                              : "منتهي الصلاحية",
                                                  fontSize:
                                                      AppFontSize.fontSize_8),
                                            ),
                                          ),
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          navigatorToPush(
                              context: context,
                              pageName: DetailsProduct(
                                idBannerOrProduct: int.parse(
                                  adsProduct[index].adsId!,
                                ),
                                categoryId: adsProduct[index].categoryId!,
                                idAds: adsProduct[index].adsId!.toString(),
                                adsName: adsProduct[index].name,
                                detailsProduct: adsProduct[index],
                                idAdOnwerCompany:
                                    int.parse(adsProduct[index].userId!),
                              ));
                        },
                        child: AdsProductWidget(
                          dataProductItem: adsProduct[index],
                          isStopNavigation: true,
                          isFromDetailsProfile: true,
                        ),
                      );
                    }
                  },
                ),
              ),
      ],
    );
  }


  bool isLoadingShareAds = false;

  Future<void> shareCompany({
    required String nameCompany,
    required String idCompany,
    required String imageUrl,
  }) async {
    try {
      setState(() {
        isLoadingShareAds = true;
      });
      String nameAdsUrl = 'اسم الشركة: $nameCompany\n';
      String urlShare = '${AppEndpoints.deepLinksUrl}/company/$idCompany';
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

  bool isShowAll = false;


  void showAboutCompany(
      BuildContext context, String? descriptionCompany, String? error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0.0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: appTheme.buttonColor,
            title: Text(
              error ?? 'عن الشركة :',
              style: themeLite.textTheme.titleSmall
                  ?.copyWith(color: appTheme.whiteA700),
            ),
            content: isShowAll
                ? textNormal(
                    overflow: isShowAll
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    text: descriptionCompany ?? "",
                    // text: "asldkjaskljdklasjdlkasjkldjlsakjdljasldkjsakldjklasjdkljasjdlksajlkdjsakljdkljsalkdjskaljalksjdlkjaslkdjlasdjsaklj ",

                    color: appTheme.whiteA700)
                : Container(
                    // height: 200.v,
                    child: descriptionCompany == null
                        ? textNormal(
                            text: 'لايتوفر وصف للشركة حتى الآن..',
                            color: appTheme.whiteA700)
                        : Row(
                            children: [
                              Expanded(
                                child: textNormal(
                                    overflow: isShowAll
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    text: descriptionCompany ?? " ",
                                    // text: "asldkjaskljdklasjdlkasjkldjlsakjdljasldkjsakldjklasjdkljasjdlksajlkdjsakljdkljsalkdjskaljalksjdlkjaslkdjlasdjsaklj ",
                                    color: appTheme.whiteA700),
                              ),
                              isShowAll
                                  ? Container()
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          isShowAll = !isShowAll;
                                        });
                                      },
                                      child: textNormal(
                                          overflow: TextOverflow.ellipsis,
                                          text: 'قراءة المزيد',
                                          color: appTheme.blue100),
                                    ),
                            ],
                          ),
                  ),
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    isShowAll = false;
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
}
