import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:html_unescape/html_unescape.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/ad_details_for_owner.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/ad_not_found.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/body_favorite_and_eyes_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/company_info_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/delete_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/details_ad_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/error_ad_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/related_ads_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/terms_conditions_questions_widget.dart';
import 'package:syrians_in_uae/ui/screens/details_product/widgets/timer_counter_widget.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/ui/widget/url_webview.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/details_product_shimmer.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:dio/dio.dart';
import 'dart:ui' as ui;

// import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scratcher/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/add_ads/add_ads_model.dart';
import '../../../data/models/add_ads/ads_special_features_model.dart';
import '../../../data/models/home_page/banner_product_model.dart';
import '../../../widgets/ads_product_shimmer.dart';
import '../../../widgets/ads_product_widget.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../theme/theme_text_form_field.dart';
import '../Notification/Notification.dart';
import '../auth/login/model_home_page.dart';

class DetailsProduct extends StatefulWidget {
  DetailsProduct(
      {super.key,
      this.detailsProduct,
      this.detailsProductFromBanner,
      required this.idAdOnwerCompany,
      required this.idBannerOrProduct,
      this.adsName,
      required this.categoryId,
      required this.idAds,
      this.isBanner = false,
      this.isFromStore = false,
      this.isBannerInOut = false});

  DataProductBannerModel? detailsProduct;
  DataProductBannerModel? detailsProductFromBanner;
  bool isBanner = false;
  bool isFromStore = false;
  String? adsName;
  String? categoryId;
  int? idBannerOrProduct;
  int? idAdOnwerCompany;
  bool isBannerInOut = false;
  String? idAds;

  @override
  State<DetailsProduct> createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct>
    with SingleTickerProviderStateMixin {
  String? appUserId = DIManager.findDep<SharedPrefs>().getUserID();
  String? tokenUser = DIManager.findDep<SharedPrefs>().getToken();
  TextEditingController? mobileNoController = TextEditingController();
  TextEditingController? couponDateController = TextEditingController();
  final FocusNode _thirdFocusNode1 = FocusNode();
  dynamic dataDetailsProduct;
  final PageController _pageViewController =
      PageController(initialPage: 0); // set the initial page you want to show
  int _activePage = 0;
  int showAds = 0;
  bool isFavoriteAd = false;
  bool isChats = false;
  bool loadingActiveChats = false;
  int? counterFavorite;
  String isHaveAds = '0';
  int clicks = 0;
  bool isAdsSpecialFeatures = true;
  String type = '';
  String clicksShare = '0';
  String clicksWhatsapp = '0';
  String clicksChat = '0';
  bool loadingClick = true;
  double priceBanner = 0.0;
  double priceAds = 0.0;
  bool isLoadingRelated = true;
  List<DatumAdsSpecialFeatures>? adsSpecialFeaturesModel;
  int? selectedAdsSpecialFeatures = -1;
  int? idSelectedAdsSpecialFeatures;
  bool isSpecial = false;
  double priceAdsSpecialFeatures = 0.0;
  List<DataProductBannerModel> relatedAds = [];
  DateTime? targetDate;
  Duration remainingTime = Duration();
  Timer? timer;

  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  void dispose() {
    // controllerNameAds!.dispose();
    mobileNoController!.dispose();
    timer?.cancel();

    super.dispose();
  }
  HomePageLoginModel? homePageData;
  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }
  void startCountdown() {
    // حساب الفرق الأولي
    calculateRemainingTime();

    // تحديث العدّاد كل ثانية
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        calculateRemainingTime();
      });
    });
  }

  void calculateRemainingTime() {
    final now = DateTime.now();
    if (targetDate != null) {
      remainingTime = targetDate!.difference(now);

      // إذا انتهى الوقت المتبقي
      if (remainingTime.isNegative) {
        timer?.cancel();
      }
    }
  }

  String originalDate({
    required String originalDateString,
    required String daysDateString,
  }) {
    DateTime originalDate = DateTime.parse(originalDateString);
    return daysDateString == ''
        ? originalDate.add(Duration(days: int.parse('0'))).toString()
        : originalDate
            .add(Duration(days: int.parse(daysDateString ?? '0')))
            .toString();
  }

  final unescape = HtmlUnescape();
  String? accountType = DIManager.findDep<SharedPrefs>().getAccountType();
  bool isCouponGeneratored = false;

  String mobileNumberUser = '000';
  String? couponAds;
  bool isLoadingCoupon = true;
  dataPage(context){
    HomeCubit.get(context).getRelatedAds(
      categoryId: int.parse(widget.categoryId.toString()),
      adsId: widget.idBannerOrProduct!,
      companyId: widget.idAdOnwerCompany!,
    );
    if (tokenUser != null) {
      if (appUserId == widget.idAdOnwerCompany.toString()) {
        print('widget.idAds : ${widget.idAds}');
        HomeCubit.get(context)
          ..getAdsSpecialFeatures()
          ..showAdsFromUser(
              adsId:
              int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
              userId: int.parse(appUserId ?? '0'))
          ..adsIsFavorites(
            adsId: int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
          );
      } else {
        print('widget.idAds : ${widget.idAds}');
        HomeCubit.get(context)
          ..showAdsFromUser(
              adsId:
              int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
              userId: int.parse(appUserId ?? '0'))
          ..adsIsFavorites(
            adsId: int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
          );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    print(
        'DetailsProduct: _________idCompany___ ${appUserId.toString()}_________________');
    print(
        'DetailsProduct: _________idProduct___ ${widget.idBannerOrProduct.toString()}_________________');
    print(
        'DetailsProduct: _________categoryId___ ${widget.categoryId.toString()}_________________');
    print('DetailsProduct: _________idProduct___ ${widget.idBannerOrProduct.toString()}_________________');
    print('DetailsProduct: _________idProduct___ ${widget.idAds.toString()}_________________');
    print(
        'DetailsProduct: package:syrians_in_uae/ui/screens/details_product/details_product.dart');
    print(
        'DetailsProduct: _________idUser___ ${appUserId.toString()}_________________');
    print(
        'DetailsProduct: _________idCompany___ ${widget.idAdOnwerCompany!.toString()}_________________');
    return BlocProvider(
      create: (context) {

        if (widget.detailsProductFromBanner == null &&
            widget.detailsProduct == null) {
          if (widget.isBanner == true) {
            return HomeCubit()
              ..getDetailsBannerApi(idDetailsBanner: widget.idBannerOrProduct!);
          } else {
            return HomeCubit()
              ..getDetailsProductApi(
                  idDetailsProduct: widget.idBannerOrProduct!);

            ///Need Category Id For Get Price
          }
        } else {
          ///Date For Product From Out Page
          if (widget.detailsProductFromBanner == null) {
            dataDetailsProduct = widget.detailsProduct!;
            isHaveAds = dataDetailsProduct.isHave.toString();
            mobileNumberUser = dataDetailsProduct.mobile.toString();
            couponDateController!.text =
                dataDetailsProduct.days_add_coupon == null
                    ? ''
                    : dataDetailsProduct.days_add_coupon.toString();
            type = dataDetailsProduct.type.toString();
            isChats = dataDetailsProduct.activeChat == '1' ? true : false;
            // print('mobileNumber : $mobileNumber');
            if (tokenUser != null) {
              if (appUserId == widget.idAdOnwerCompany.toString()) {
                return HomeCubit()..getDetailsProductApi(
                    idDetailsProduct: widget.idBannerOrProduct!,isNeedRefresh: false)
                  ..getAdsSpecialFeatures()
                  ..showAdsFromUser(
                      adsId: widget.isBanner
                          ? int.parse(dataDetailsProduct!.adsId ?? '0')
                          : widget.idBannerOrProduct ?? 0,
                      userId: int.parse(appUserId ?? '0'))
                  ..adsIsFavorites(
                    adsId: int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
                  )
                  ..getStatusCouponsUser(adsId: int.parse(widget.idAds!))
                  // ..getStatusWhatsappStatusCompanyUser(
                  //     companyId: widget.idAdOnwerCompany!)
                  // ..getPriceAds(
                  //   categoryId: int.parse(widget.categoryId.toString()),
                  // )
                  ..getClickStatistics(
                      idAds: int.parse(dataDetailsProduct.adsId!))
                  ..getRelatedAds(
                    categoryId: int.parse(widget.categoryId.toString()),
                    adsId: int.parse(dataDetailsProduct.adsId!),
                    companyId:
                        int.parse(dataDetailsProduct.company[0].id.toString()),
                  );
              } else {
                return HomeCubit()..getDetailsProductApi(
                    idDetailsProduct: widget.idBannerOrProduct!,isNeedRefresh: false)
                  ..showAdsFromUser(
                      adsId: widget.isBanner
                          ? int.parse(dataDetailsProduct!.adsId ?? '0')
                          : widget.idBannerOrProduct ?? 0,
                      userId: int.parse(appUserId ?? '0'))
                  ..adsIsFavorites(
                    adsId:
                        int.parse(widget.idAds ?? dataDetailsProduct!.adsId!),
                  )
                  ..getStatusCouponsUser(adsId: int.parse(widget.idAds!))
                  // ..getStatusWhatsappStatusCompanyUser(
                  //     companyId: widget.idAdOnwerCompany!)
                  // ..getPriceAds(
                  //   categoryId: int.parse(widget.categoryId.toString()),
                  // )
                  ..getClickStatistics(
                      idAds: int.parse(dataDetailsProduct.adsId!))
                  ..getRelatedAds(
                    categoryId: int.parse(widget.categoryId.toString()),
                    adsId: int.parse(dataDetailsProduct.adsId!),
                    companyId:
                        int.parse(dataDetailsProduct.company[0].id.toString()),
                  );
              }
            } else {
              return HomeCubit()..getDetailsProductApi(
                  idDetailsProduct: widget.idBannerOrProduct!,isNeedRefresh: false)
                // ..getStatusWhatsappStatusCompanyUser(
                //     companyId: widget.idAdOnwerCompany!)
                // ..getPriceAds(
                //   categoryId: int.parse(widget.categoryId.toString()),
                // )
                ..getClickStatistics(
                    idAds: int.parse(dataDetailsProduct.adsId!))
                ..getRelatedAds(
                  categoryId: int.parse(widget.categoryId.toString()),
                  adsId: int.parse(dataDetailsProduct.adsId!),
                  companyId:
                      int.parse(dataDetailsProduct.company[0].id.toString()),
                );
            }
          }

          ///Date For Banner From Out Page
          else {

            dataDetailsProduct = widget.detailsProductFromBanner!;
            isHaveAds = dataDetailsProduct.isHave.toString();
            mobileNumberUser = dataDetailsProduct.mobile.toString();
            //couponDateController
            couponDateController!.text =
                dataDetailsProduct.days_add_coupon == null
                    ? ''
                    : dataDetailsProduct.days_add_coupon.toString();
            type = dataDetailsProduct.type.toString();
            isChats = dataDetailsProduct.activeChat == '1' ? true : false;
            print('mobileNumber : $mobileNumberUser');
            if (tokenUser != null) {
              if (appUserId == widget.idAdOnwerCompany.toString()) {
                return HomeCubit()..getDetailsBannerApi(idDetailsBanner: widget.idBannerOrProduct!,isNeedRefresh: false)
                  ..getAdsSpecialFeatures()
                  ..showAdsFromUser(
                      adsId: widget.isBanner
                          ? int.parse(dataDetailsProduct!.adsId ?? '0')
                          : widget.idBannerOrProduct ?? 0,
                      userId: int.parse(appUserId ?? '0'))
                  ..adsIsFavorites(
                    adsId:
                        int.parse(widget.idAds ?? dataDetailsProduct!.adsId!),
                  )
                  ..getStatusCouponsUser(adsId: int.parse(widget.idAds!))
                  // ..getStatusWhatsappStatusCompanyUser(
                  //     companyId: widget.idAdOnwerCompany!)
                  // ..getPriceAds(
                  //   categoryId: int.parse(dataDetailsProduct.categoryId!),
                  // )
                  ..getClickStatistics(
                      idAds: int.parse(dataDetailsProduct.adsId!));
              } else {
                return HomeCubit()..getDetailsBannerApi(idDetailsBanner: widget.idBannerOrProduct!,isNeedRefresh: false)
                  ..showAdsFromUser(
                      adsId: widget.isBanner
                          ? int.parse(dataDetailsProduct!.adsId ?? '0')
                          : widget.idBannerOrProduct ?? 0,
                      userId: int.parse(appUserId ?? '0'))
                  ..adsIsFavorites(
                    adsId: int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
                  )
                  ..getStatusCouponsUser(adsId: int.parse(widget.idAds!))
                  // ..getStatusWhatsappStatusCompanyUser(
                  //     companyId: widget.idAdOnwerCompany!)
                  // ..getPriceAds(
                  //   categoryId: int.parse(dataDetailsProduct.categoryId!),
                  // )
                  ..getClickStatistics(
                      idAds: int.parse(dataDetailsProduct.adsId!));
              }
            } else {
              return HomeCubit()..getDetailsBannerApi(idDetailsBanner: widget.idBannerOrProduct!,isNeedRefresh: false)
                // ..getStatusWhatsappStatusCompanyUser(
                //     companyId: widget.idAdOnwerCompany!)
                // ..getPriceAds(
                //   categoryId: int.parse(dataDetailsProduct.categoryId!),
                // )
                ..getClickStatistics(
                    idAds: int.parse(dataDetailsProduct.adsId!));
            }
          }
        }
        // }
      },
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is SuccessDetailsProductState) {
            dataDetailsProduct = state.detailsProductModel.data!;
            isHaveAds = dataDetailsProduct.isHave.toString();
            mobileNumberUser = dataDetailsProduct.mobile.toString();
            //couponDateController
            couponDateController!.text =
                dataDetailsProduct.days_add_coupon == null
                    ? ''
                    : dataDetailsProduct.days_add_coupon.toString();
            type = 'B';
            isChats = dataDetailsProduct.activeChat == '1' ? true : false;

          }
          /*
    String clicksShare = '';
      String clicksWhatsapp = '';
      String clicksChat = '';
     */

          if (state is SuccessRelatedAdsState) {
            relatedAds = state.homePageModel.relatedAds ??[];
            isLoadingRelated = false;
          }
          if (state is SuccessClickStatisticsState) {
            clicksShare = state.generalModel.clicksShare ?? '0';
            clicksWhatsapp = state.generalModel.clicksWhatsapp ?? '0';
            clicksChat = state.generalModel.clicksChat ?? '0';
            loadingClick = false;
          }

          if (state is ErrorClickStatisticsState) {
            clicksShare = '0';
            clicksWhatsapp = '0';
            clicksChat = '0';
            loadingClick = false;
          }

          if (state is LoadingClickStatisticsState) {
            clicksShare = '0';
            clicksWhatsapp = '0';
            clicksChat = '0';
            loadingClick = true;
          }
          if (state is SuccessGetStatusCouponsUsersState) {
            isCouponGeneratored =
                state.couponUserModel.hasCoupon == '0' ? false : true;
            isLoadingCoupon = false;
            couponAds = state.couponUserModel.couponUser;
          }

          if (state is LoadingGetStatusCouponsUsersState) {
            isLoadingCoupon = true;
          }
          // if (state is SuccessGetPriceAdsState) {
          //   priceBanner =
          //       double.parse(state.priceAdsModel.bannerPrice ?? "0.0");
          //   priceAds = double.parse(state.priceAdsModel.adsPrice ?? "0.0");
          // }
          if (state is SuccessDetailsBannerState) {
            dataDetailsProduct = state.detailsProductModel.data!;
            isHaveAds = dataDetailsProduct.isHave.toString();
            mobileNumberUser = dataDetailsProduct.mobile.toString();
            //couponDateController
            couponDateController!.text =
                dataDetailsProduct.days_add_coupon == null
                    ? ''
                    : dataDetailsProduct.days_add_coupon.toString();
            type = 'A';
            isChats = dataDetailsProduct.activeChat == '1' ? true : false;
            // HomeCubit.get(context).getStatusWhatsappStatusCompanyUser(
            //     companyId: widget.idAdOnwerCompany ??
            //         dataDetailsProduct.company[0].id!);
            if (tokenUser != null) {
              if (appUserId == widget.idAdOnwerCompany.toString()) {
                print('widget.idAds : ${widget.idAds}');
                HomeCubit.get(context)
                  ..getAdsSpecialFeatures()
                  ..showAdsFromUser(
                      adsId:
                          int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
                      userId: int.parse(appUserId ?? '0'))
                  ..adsIsFavorites(
                    adsId: int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
                  );
              } else {
                print('widget.idAds : ${widget.idAds}');
                HomeCubit.get(context)
                  ..showAdsFromUser(
                      adsId:
                          int.parse(widget.idAds ?? dataDetailsProduct.adsId!),
                      userId: int.parse(appUserId ?? '0'))

                  ..adsIsFavorites(
                    adsId:
                        int.parse(widget.idAds ?? dataDetailsProduct!.adsId!),
                  )..getStatusCouponsUser(adsId: int.parse(widget.idAds ?? dataDetailsProduct!.adsId!));
              }
            }
          }
          if (state is SuccessShowAdsState) {
            if (state.showAdsModel.status == true) {
              showAds++;
            }
            clicks = int.parse(state.showAdsModel.data ?? '0');
          }

          if (state is SuccessEditWhatsappMobileState) {
            SnackBarHelper.mySnackBarSuccess(
                state.generalResult.message, context);
            mobileNumberUser = state.generalResult.data!;
          }

          if (state is ErrorEditWhatsappMobileState) {
            SnackBarHelper.mySnackBarError(state.error.toString(), context);
          }

          if (state is ErrorDeleteAdsState) {
            SnackBarHelper.mySnackBarError(state.error.toString(), context);
          }

          if (state is SuccessDeleteAdsState) {
            SnackBarHelper.mySnackBarSuccess(
                state.generalResult.message.toString(), context);
            navigatorToPushReplacementUntil(
              context: context,
              location: '/homePage',
              extra: homePageData
            );
          }
          if (state is SuccessAddAdsSpecialFeaturesState) {
            SnackBarHelper.mySnackBarSuccess(
                state.generalResult.message, context);
            isHaveAds = state.generalResult.success!;
          }

          if (state is ErrorAddAdsSpecialFeaturesState) {
            SnackBarHelper.mySnackBarSuccess(state.error.toString(), context);
          }
          if (state is SuccessEvaluateAdsState) {
            SnackBarHelper.mySnackBarSuccess('تم تقييم الإعلان بنجاح', context);
          }
          if (state is ErrorEvaluateAdsState) {
            SnackBarHelper.mySnackBarError(
                'فشل تقييم الإعلان الرجاء المحاولة مرة أخرى ..', context);
          }
          if (state is SuccessAddAndRemoveAdsFromFavoritesState) {
            if (state.showAdsModel.status == 1) {
              isFavoriteAd = true;
            } else {
              isFavoriteAd = false;
            }
            counterFavorite = int.parse(state.showAdsModel.data ?? '0');
          }
          if (state is SuccessAdsIsFavoritesState) {
            // if(state.showAdsModel.status ==1){
            //   showAds++;
            // }
            // clicks = int.parse(state.showAdsModel.data ??'0');

            if (state.hasFavoritesModel.hasFavorites == 1) {
              isFavoriteAd = true;
            } else if (state.hasFavoritesModel.hasFavorites == 0) {
              isFavoriteAd = false;
            }
          }
          // if (state is ChangeChatState) {
          //   isChats = !isChats;
          //   print(isChats);
          // }
          if (state is SuccessActiveChatsForAdsState) {
            isChats = state.showAdsModel.status == 1 ? true : false;
            loadingActiveChats = false;
            SnackBarHelper.mySnackBarSuccess(
                state.showAdsModel.message.toString(), context);
          }

          if (state is LoadingActiveChatsForAdsState) {
            loadingActiveChats = true;
          }

          if (state is ErrorActiveChatsForAdsState) {
            loadingActiveChats = false;
            SnackBarHelper.mySnackBarError(state.error.toString(), context);
          }
          if (state is SuccessEditAdsInformationState) {
            BlocProvider.of<HomeCubit>(context).changeShowEditAds(false);
            SnackBarHelper.mySnackBarSuccess(
                state.editAdsModel.message, context);
          }

          if (state is ErrorCreateCouponsUsersState) {
            SnackBarHelper.mySnackBarError(state.error.toString(), context);
          }

          if (state is SuccessCreateCouponsUsersState) {
            SnackBarHelper.mySnackBarSuccess(
                state.generalResult.message.toString(), context);
          }
          if (state is ErrorEditAdsInformationState) {
            SnackBarHelper.mySnackBarError(state.error.toString(), context);
          }
          if (state is LoadingAdsSpecialFeaturesState) {
            isAdsSpecialFeatures = true;
          }
          if (state is SuccessAdsSpecialFeaturesState) {
            adsSpecialFeaturesModel = state.adsSpecialFeaturesModel.data;
            isAdsSpecialFeatures = false;
          }
          if (state is LoadingRelatedAdsState) {
            relatedAds = [];
            isLoadingRelated = true;
          }
          if (state is ErrorRelatedAdsState) {
            isLoadingRelated = false;
            SnackBarHelper.mySnackBarError(state.error.toString(), context);
          }
          // if (state is SuccessStatusWhatsappStatusCompanyState) {
          //   isActiveWhatsapp =
          //       state.whatsappCompanyStatusModel.data == '1' ? true : false;
          // }
        },
        builder: (context, state) {
          return HandelAndroidApp(
            child: Scaffold(
              appBar: appBarNormalWithIcon(
                  text: (dataDetailsProduct?.name == null ||
                              dataDetailsProduct?.name == "null") &&
                          widget.isBannerInOut == false
                      ? 'تفاصيل الإعلان'
                      : widget.isBannerInOut == true
                          ? 'بنر خارجي'
                          : dataDetailsProduct.name!,
                  context: context,
                  isShowBack: true),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: RefreshIndicator(
                  color: appTheme.greenColor,
                  backgroundColor: appTheme.lightBlue100,
                  onRefresh: () {
                    // HomeCubit.get(context).getCategoriesMainApi();

                    // if (appUserId == widget.idAdOnwerCompany.toString()) {
                    //   HomeCubit.get(context).getAdsSpecialFeatures();
                    // }
                    dataPage(context);
                    // HomeCubit.get(context).getStatusWhatsappStatusCompanyUser(
                    //     companyId: widget.idAdOnwerCompany!);
                    // HomeCubit.get(context).getPriceAds(
                    //     categoryId: int.parse(dataDetailsProduct.categoryId!));
                    HomeCubit.get(context).getClickStatistics(
                        idAds: int.parse(dataDetailsProduct.adsId!));

                    if (widget.isBanner) {
                      return HomeCubit.get(context).getDetailsBannerApi(
                          idDetailsBanner: widget.idBannerOrProduct!);
                    } else {
                      return HomeCubit.get(context).getDetailsProductApi(
                          idDetailsProduct: widget.idBannerOrProduct!);
                    }
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                      ),
                      child: state is LoadingDeleteAdsState
                          ? DeleteAdWidget()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state is LoadingDetailsProductState) ...[
                                  DetailsProductShimmer(),
                                ] else if (state
                                    is ErrorDetailsProductState) ...[
                                  ErrorAdWidget()
                                ] else ...[
                                  if (dataDetailsProduct.deletedAt != null) ...{
                                    AdNotFoundWidget()
                                  } else ...{
                                    sizeHeightNormal(height: 4.h),
                                    // _buildBodyContainer(
                                    //     context, dataDetailsProduct!, state),
                                    DetailsAdWidget(
                                      dataDetailsProduct: dataDetailsProduct,
                                      isBanner: widget.isBanner,
                                      isFromStore: widget.isFromStore,
                                      idAdOnwerCompany:
                                          widget.idAdOnwerCompany.toString(),
                                      idBannerOrProduct:
                                          widget.idBannerOrProduct!,
                                      isBannerInOut: widget.isBannerInOut,
                                      type: type,
                                      categoryId: widget.categoryId!,
                                      isChats: isChats,
                                      isFavorite: isFavoriteAd,
                                      isOwnerCompany:  appUserId == widget.idAdOnwerCompany.toString(),
                                      loadingActiveChats: loadingActiveChats,
                                      mobileNumber: mobileNumberUser,
                                      tokenUser: tokenUser,
                                    ),

                                    appUserId !=
                                            widget.idAdOnwerCompany.toString()
                                        ? Container()
                                        : sizeHeightNormal(),
                                    widget.isBanner ||   appUserId !=
                                        widget.idAdOnwerCompany.toString()?Container():  BodyFavoriteAndEyesWidget(
                                      dataProduct: dataDetailsProduct,
                                      showAds: showAds,
                                      clicksShare: clicksShare,
                                      clicksWhatsapp: clicksWhatsapp,
                                      clicksChat: clicksChat,
                                    ),
                                    sizeHeightNormal(),
                                    if (dataDetailsProduct.isAddCoupon == '1' &&
                                        accountType == 'individual') ...[
                                      appUserId ==
                                              widget.idAdOnwerCompany.toString()
                                          ? Container()
                                          : _buildInPressing(
                                              context, widget.idAds),
                                      sizeHeightNormal(height: 15.h),
                                    ],
                                    appUserId ==
                                            widget.idAdOnwerCompany.toString()
                                        ? Container()
                                        :  CompanyInfoWidget(
                                      company:dataDetailsProduct!.company,
                                    ),
                                    appUserId !=
                                        widget.idAdOnwerCompany.toString()
                                        ? Container()
                                        :  sizeHeightNormal(height: 15.h),
                                    appUserId !=
                                            widget.idAdOnwerCompany.toString()
                                        ? Container()
                                        : AdDetailsForOwnerWidget(
                                      dataDetailsProduct: dataDetailsProduct,
                                      clicks: clicks,
                                      showAds: showAds,
                                      isHaveAds: isHaveAds,
                                    ),
                                    // sizeHeightNormal(height: 15.h),

                                    // TermsConditionsQuestionsWidget(),
                                    if(widget.isBanner == true)...{
                                      Container(
                                        width: double.infinity,
                                        height: 200.h,
                                      ),
                                    },
                                    sizeHeightNormal(height: 15.h),
                                    if (widget.isBanner == false &&
                                        appUserId !=
                                            widget.idAdOnwerCompany
                                                .toString()) ...{
                                      if (isLoadingRelated) AdsProductShimmer(),
                                      if (!isLoadingRelated)
                                         RelatedAdsWidget(
                                        relatedAds: relatedAds,
                                      ),
                                    },
                                    sizeHeightNormal(height: 40.h),
                                  },
                                ],
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildInPressing(BuildContext context, String? adsId) {
    return isLoadingCoupon
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              appUserId == widget.idAdOnwerCompany.toString()
                  ? Container()
                  : textNormal(
                      text:
                          'أحصل على كود خصم (${dataDetailsProduct.couponPercent}%) :'),
              appUserId == widget.idAdOnwerCompany.toString()
                  ? Container()
                  : sizeHeightNormal(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 75.h,
                decoration: AppDecoration.outlineWhiteB,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sizeWidthNormal(width: 50.w),
                    textNormal(text: 'حك هنا'),
                    sizeWidthNormal(),
                    Icon(
                      Icons.arrow_forward,
                      color: appTheme.deepPurpleA10001,
                      size: 25.sp,
                    ),
                    sizeWidthNormal(),
                    couponAds == null
                        ? Shimmer.fromColors(
                            baseColor: appTheme.baseColorShimmer,
                            highlightColor: appTheme.highlightColorShimmer,
                            child: Scratcher(
                              brushSize: 30,
                              threshold: 50,
                              color: Colors.transparent,
                              image: Image.asset(
                                ImageConstant.imgBackCouponsGray,
                                fit: BoxFit.cover,
                                // color: Colors.grey,
                              ),
                              onChange: (value) =>
                                  print("Scratch progress: $value%"),
                              // onThreshold: () {
                              //   // setState(() {
                              //   //   couponAds = generateCoupon();
                              //   // });
                              //   // HomeCubit.get(context).createCouponsUser(
                              //   //   adsId: int.parse(adsId!),
                              //   //   companyId: widget.idAdOnwerCompany!,
                              //   //   couponValue: couponAds!,
                              //   // );
                              // },
                              child: couponAds == null
                                  ? CustomImageView(
                                      imagePath: ImageConstant.imgBackCoupons,
                                      height: 50.h,
                                      width: 110.w)
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomImageView(
                                            imagePath:
                                                ImageConstant.imgBackCoupons,
                                            height: 50.h,
                                            width: 110.w),
                                        textNormal(
                                            text: couponAds!,
                                            color: Colors.black),
                                      ],
                                    ),
                            ),
                          )
                        : Shimmer.fromColors(
                            baseColor: appTheme.baseColorShimmer,
                            highlightColor: appTheme.highlightColorShimmer,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomImageView(
                                    imagePath: ImageConstant.imgBackCoupons,
                                    height: 50.h,
                                    width: 110.w),
                                textNormal(
                                    text: couponAds!, color: Colors.black),
                              ],
                            ),
                          ),
                    couponAds == null
                        ? Container()
                        : InkWell(
                            onTap: () {
                              copyToClipboard(couponAds!, context);
                            },
                            child: textNormal(text: 'نسخ')),
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              appUserId == widget.idAdOnwerCompany.toString()
                  ? Container()
                  : textNormal(
                      text:
                          'أحصل على كود خصم (${dataDetailsProduct.couponPercent}%) :'),
              appUserId == widget.idAdOnwerCompany.toString()
                  ? Container()
                  : sizeHeightNormal(),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 75.h,
                decoration: AppDecoration.outlineWhiteB,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sizeHeightNormal(),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sizeWidthNormal(width: 50.w),
                        textNormal(text: 'حك هنا'),
                        sizeWidthNormal(),
                        Icon(
                          Icons.arrow_forward,
                          color: appTheme.deepPurpleA10001,
                          size: 25.sp,
                        ),
                        sizeWidthNormal(),
                        couponAds == null
                            ? Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.transparent,
                                image: Image.asset(
                                    ImageConstant.imgBackCouponsGray,
                                    fit: BoxFit.cover,
                                    height: 50.h,
                                    width: 110.w
                                    // color: Colors.grey,
                                    ),
                                onChange: (value) =>
                                    print("Scratch progress: $value%"),
                                onThreshold: () {
                                  setState(() {
                                    couponAds = generateCoupon();
                                  });
                                  HomeCubit.get(context).createCouponsUser(
                                    adsId: int.parse(adsId!),
                                    companyId: widget.idAdOnwerCompany!,
                                    couponValue: couponAds!,
                                  );
                                },
                                child: couponAds == null
                                    ? CustomImageView(
                                        imagePath: ImageConstant.imgBackCoupons,
                                        height: 50.h,
                                        width: 110.w)
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomImageView(
                                              imagePath:
                                                  ImageConstant.imgBackCoupons,
                                              height: 50.h,
                                              width: 110.w),
                                          textNormal(
                                              text: couponAds!,
                                              color: Colors.black),
                                        ],
                                      ),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                      imagePath: ImageConstant.imgBackCoupons,
                                      height: 50.h,
                                      width: 110.w),
                                  textNormal(
                                      text: couponAds!, color: Colors.black),
                                ],
                              ),
                        // couponAds == null ? Container() : sizeWidthNormal(),
                        couponAds == null
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  copyToClipboard(couponAds!, context);
                                },
                                child: textNormal(text: 'نسخ')),
                      ],
                    ),
                    sizeHeightNormal(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Row(
                        children: [
                          textNormal(text: 'ينتهي الخصم بعد :'),
                          sizeWidthNormal(),
                      TimerCounterWidget(
                        createdAt: originalDate(
                          daysDateString: couponDateController?.text ?? "0",
                          originalDateString: dataDetailsProduct.acceptDate.toString(),
                        ),
                      ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }




}
