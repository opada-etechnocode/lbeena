import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:syrians_in_uae/data/sources/home_page/home_page_data_source.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/add_ad_new/category_model.dart';
import '../../../../data/models/add_ad_new/cities_model.dart';
import '../../../../data/models/company/activity_company_model.dart';
import '../../../../data/models/company/company_model.dart';
import '../../../../data/models/setting_model.dart';
import '../../../../data/sources/ads/ads_data_source.dart';
import '../../../../data/sources/auth/auth_remote_data_source.dart';
import '../../../../data/sources/coupon/coupon_remote_data_source.dart';

import '../../../../data/sources/news/news_data_source.dart';
import '../../../../data/sources/notifications/notifications_data_source.dart';
import '../../../../data/sources/payment/payment_data_source.dart';
import '../../../../widgets/components.dart';
import '../../../theme/theme_helper.dart';
import '../../auth/login/model_home_page.dart';
import '../../chats/cubit/apis_chat_firebase.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);





  //getPackagesUser()
  Future<void> getPackagesUser() async {
    NotificationsDataSourceImpl getPackagesUserSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingPackagesUserState());

      var getPackagesUser =
      await getPackagesUserSourceImpl.getPackagesUser();
      if (getPackagesUser.data != null) {
        emit(SuccessPackagesUserState(getPackagesUser.data!));
      } else {
        emit(ErrorPackagesUserState(getPackagesUser.error!.message!));
      }
    } catch (e, stack) {
      print("Error In PackagesUserState is : $e in $stack");
      emit(ErrorPackagesUserState("Error is $e"));
    }
  }



  //getPackagesUser()
  Future<void> payPackagesUser() async {
    NotificationsDataSourceImpl getPackagesUserSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingPayPackagesUserState());

      var getPackagesUser =
      await getPackagesUserSourceImpl.payPackagesUser();
      if (getPackagesUser.data != null) {
        emit(SuccessPayPackagesUserState(getPackagesUser.data!));
      } else {
        emit(ErrorPayPackagesUserState(getPackagesUser.error!.message!));
      }
    } catch (e, stack) {
      print("Error In PackagesUserState is : $e in $stack");
      emit(ErrorPayPackagesUserState("Error is $e"));
    }
  }
  /// get colors app
  Future<void> getColorsApp() async {
    HomePageDataSourceImpl homePageDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingColorsAppState());

      var colorsAppData = await homePageDataSourceImpl.getColorsApp();

      if (colorsAppData.data != null) {
        emit(SuccessColorsAppState(colorsAppData.data!));
      } else {
        emit(ErrorColorsAppState(colorsAppData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ColorsApp is : $e in $stack");
      emit(ErrorColorsAppState("Error is $e"));
    }
  }
  /// get colors app
  Future<void> getStatusRecorder() async {
    HomePageDataSourceImpl homePageDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      emit(LoadingStatusRecorderState());

      var status = await homePageDataSourceImpl.getStatusRecorder();

      if (status.data != null) {
        emit(SuccessStatusRecorderState(status.data!));
      } else {
        emit(ErrorStatusRecorderState(status.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ColorsApp is : $e in $stack");
      emit(ErrorStatusRecorderState("Error is $e"));
    }
  }
  bool isLoadingCompanyList = true;
  bool isLoadingPageCompanyList = false;

  List<CompaniesListModel> dataCompaniesList = [];
  /// get Companies app
    orderList({
    required int order
}){
      if (dataCompaniesList.isNotEmpty) {
        print('object');
       dataCompaniesList.sort((a, b) {
          DateTime dateA = a.createdAt!;
          DateTime dateB = b.createdAt!;
          if (order == 0) {
            return dateB.compareTo(dateA);
          } else {
            return dateA.compareTo(dateB);
          }
        });
        print('object1');
        emit(SuccessOrderCompaniesState());
      }
    }
  ActivityCompanyModel? activityCompanyModel;
  Future<void> getCompanies({
    required int page, bool isLoadingActive = true,
    bool isSearchCompany =false,
  required int order
    }) async {
    HomePageDataSourceImpl homePageDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if(isLoadingActive){
        dataCompaniesList.clear();
        isLoadingCompanyList = true;
        emit(LoadingCompaniesState());
      }else {
        isLoadingPageCompanyList = true;
        emit(LoadingCompaniesPagState());
      }

      var companyData = await homePageDataSourceImpl.getCompaniesList(page:page,
      order: order,);

      if (companyData.data != null) {
        isLoadingCompanyList = false;
        isLoadingPageCompanyList = false;
        dataCompaniesList.addAll(companyData.data!.data!.companies!.data);
        // setDataCompany(companyData.data!);
        emit(SuccessCompaniesState(companyData.data!));
      } else {
        isLoadingCompanyList = false;
        isLoadingPageCompanyList = false;
        emit(ErrorCompaniesState(companyData.error!.message!));
      }
    } catch (e, stack) {
      isLoadingCompanyList = false;
      isLoadingPageCompanyList = false;
      print("Error In Companies is : $e in $stack");
      emit(ErrorCompaniesState("Error is $e"));
    }
  }
  /// get Companies app
  Future<void> searchCompanies({
    required int page,
    bool isLoadingActive = true,
    bool isNeedClear = false,
    required int order,
    int? businessActivitiesId,
    int? subcategory_id,
    String? title,
    String? city_name,
  }) async {
    HomePageDataSourceImpl homePageDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if(isNeedClear){
        dataCompaniesList.clear();
      }
      if(isLoadingActive){
        isLoadingCompanyList = true;
        dataCompaniesList.clear();
        emit(LoadingSearchCompaniesState());
      }else {
        emit(LoadingCompaniesPagState());
      }

      var companyData = await homePageDataSourceImpl.searchCompaniesList(page: page, order: order, search: title,
      businessActivitiesId: businessActivitiesId,
      city_name: city_name,
        subcategory_id: subcategory_id
      );

      if (companyData.data != null) {
        isLoadingCompanyList = false;

        dataCompaniesList.addAll(companyData.data!.data!.companies!.data);
        emit(SuccessSearchCompaniesState(companyData.data!));
      } else {
        isLoadingCompanyList = false;
        emit(ErrorSearchCompaniesState(companyData.error!.message!));
      }
    } catch (e, stack) {
      isLoadingCompanyList = false;
      print("Error In Companies is : $e in $stack");
      emit(ErrorSearchCompaniesState("Error is $e"));
    }
  }



  /// getServiceTeam colors app
  Future<void> getServiceTeam() async {
    HomePageDataSourceImpl homePageDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      emit(LoadingServiceTeamState());

      var serviceTeam = await homePageDataSourceImpl.serviceModel();

      if (serviceTeam.data != null) {
        emit(SuccessServiceTeamState(serviceTeam.data!));
      } else {
        emit(ErrorServiceTeamState(serviceTeam.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorServiceTeamState is : $e in $stack");
      emit(ErrorServiceTeamState("Error is $e"));
    }
  }
  Future<void> getPriceAds({required int categoryId}) async {
    AddAdsDataSourceImpl categoriesMainDataSourceImpl =
        const AddAdsDataSourceImpl();
    if(DIManager.findDep<SharedPrefs>().getToken() !=null){
      try {
        emit(LoadingGetPriceAdsState());

        var categoriesMainData = await categoriesMainDataSourceImpl
            .getPriceAdsAndBanner(categoryId: categoryId);

        if (categoriesMainData.data != null) {
          if (!isClosed) {
            emit(SuccessGetPriceAdsState(categoriesMainData
                .data!)); // Replace NewStateWithData with your actual state
          }
        } else {
          if (!isClosed) {
            emit(ErrorGetPriceAdsState(categoriesMainData.error!.message!));
          }
        }
      } catch (e, stack) {
        print("Error In GetPriceAds is : $e in $stack");
        // emit(ErrorGetPriceAdsState("Error is $e"));

        if (!isClosed) {
          emit(ErrorGetPriceAdsState("Error is $e"));
        }
      }
    }

  }

  /// get All News
  Future<void> getAllNews() async {
    NewsDataSourceImpl getAllNewsDataImpl = const NewsDataSourceImpl();
    try {
      emit(LoadingGetAllNewsState());

      var getAllNotifications = await getAllNewsDataImpl.getAllNews(page: 1);
      if (getAllNotifications.data != null) {
        emit(SuccessGetAllNewsState(getAllNotifications.data!));
      } else {
        emit(ErrorGetAllNewsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllNewsState is : $e in $stack");
      emit(ErrorGetAllNewsState("Error is $e"));
    }
  }

  /// Create Coupon
  Future<void> createCouponsUser({
    required int adsId,
    required int companyId,
    required String couponValue,
  }) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
        const CouponRemoteDataSourceImpl();
    try {
      emit(LoadingCreateCouponsUsersState());

      var getPolicyTermsAppLinksData =
          await couponUsersDataSourceImpl.createCouponForUser(
              adsId: adsId, companyId: companyId, couponValue: couponValue);

      if (getPolicyTermsAppLinksData.data != null) {
        emit(SuccessCreateCouponsUsersState(getPolicyTermsAppLinksData.data!));
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorCreateCouponsUsersState(
            getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorCreateCouponsUsersState("Error is $e"));
    }
  }

  /// Get Status Coupon
  Future<void> getStatusCouponsUser({
    required int adsId,
  }) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
        const CouponRemoteDataSourceImpl();
    try {
      emit(LoadingGetStatusCouponsUsersState());

      var getPolicyTermsAppLinksData =
          await couponUsersDataSourceImpl.getStatusUserCoupon(adsId: adsId);

      if (getPolicyTermsAppLinksData.data != null) {
        if (!isClosed) {
          emit(SuccessGetStatusCouponsUsersState(
              getPolicyTermsAppLinksData.data!));
        }
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        if (!isClosed) {
          emit(ErrorGetStatusCouponsUsersState(
              getPolicyTermsAppLinksData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      // Handle exception
      if (!isClosed) {
        emit(ErrorGetStatusCouponsUsersState("Error is $e"));
      }
    }
  }

  ///Logout
  Future<void> logout() async {
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
        const AuthRemoteDataSourceImpl();
    try {
      emit(LoadingLogoutState());

      var authentication = await authRemoteDataSourceImpl.logout();

      if (authentication.data != null) {
        APIs.updateStatusUser(
          userStatus: DateTime.now().toString(),
        );
        DIManager.findDep<SharedPrefs>().setImageProfile(null);

        DIManager.findDep<SharedPrefs>().setToken(null);
        DIManager.findDep<SharedPrefs>().setAccountType(null);
        DIManager.findDep<SharedPrefs>().setUserInformation(
          companyIsActive2: null,
          userNameCompany2: null,
          mobileNumber2: null,
          accountType2: null,
          token: null,
          status: null,
          imageProfile2: null,
          userID2: null,
          userNamePerson2: null,
          createdAd2: null,
          joinedAd2: null,
          ratingUser2: null,
          membershipNumberValue: null,
        );

        DIManager.findDep<SharedPrefs>().setStatusUGC(false);
        DIManager.findDep<SharedPrefs>().setCounterNotifications(0);
        subscribeToTopic();
        emit(SuccessLogoutState(authentication.data));
      } else {
        emit(ErrorLogoutState(authentication.error!.message!));
      }
    } catch (e, stack) {
      print("Error In Logout is : $e in $stack");
      emit(ErrorLogoutState("Error is $e"));
    }
  }

  Future<void> payForAdsSpecialFeatures({
    required int idAdSpecialFeature,
    required String priceSpecialFeature,
    required int idAds,
    required String paymentMethod,
  }) async {
    PaymentPageDataSourceImpl pageDataSource =
        const PaymentPageDataSourceImpl();
    try {
      emit(LoadingPayForAdsSpecialFeaturesState());

      var pageData = await pageDataSource.payForAdsSpecialFeatures(
        paymentMethod: paymentMethod,
        idAdSpecialFeature: idAdSpecialFeature,
        idAds: idAds,
        priceSpecialFeature: priceSpecialFeature,
      );

      if (pageData.data != null) {
        emit(SuccessPayForAdsSpecialFeaturesState(pageData.data!));
      } else {
        emit(ErrorPayForAdsSpecialFeaturesState(pageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In Error Pay ForAdsSpecialFeaturesState is : $e in $stack");
      emit(ErrorPayForAdsSpecialFeaturesState("Error is $e"));
    }
  }

  /// Policy Terms App Links
  Future<void> getPolicyTermsAppLinks() async {
    HomePageDataSourceImpl homePageDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingPolicyTermsAppLinksState());
      }

      var getPolicyTermsAppLinksData =
          await homePageDataSourceImpl.getPolicyTermsAppLinks();

      if (getPolicyTermsAppLinksData.data != null) {
        if (!isClosed) {
          emit(SuccessPolicyTermsAppLinksState(
              getPolicyTermsAppLinksData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorPolicyTermsAppLinksState(
              getPolicyTermsAppLinksData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In HomePage is : $e in $stack");
      if (!isClosed) {
        emit(ErrorPolicyTermsAppLinksState("Error is $e"));
      }
    }
  }

  // Future<void> getWeatherApp() async {
  //   double lat = 25.227580 ;
  //   double lon = 55.175012 ;
  //   String key = '5f61d4235c5754633a95081212ab7d23';
  //   String cityName = 'UAE';
  //   WeatherFactory wf = WeatherFactory(key);
  //
  //   List<Weather> forecast = await wf.fiveDayForecastByLocation(lat, lon);
  //
  //   print(forecast);
  //   emit(SuccessWeatherAppState());
  // }
  /// Delete Account
  Future<void> deleteAccount() async {
    HomePageDataSourceImpl homePageDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingDeleteAccountState());

      var deleteAccount = await homePageDataSourceImpl.deleteAccount();

      if (deleteAccount.data != null) {
        emit(SuccessDeleteAccountState(deleteAccount.data!));
      } else {
        emit(ErrorDeleteAccountState(deleteAccount.error!.message!));
      }
    } catch (e, stack) {
      print("Error In deleteAccount is : $e in $stack");
      emit(ErrorDeleteAccountState("Error is $e"));
    }
  }



  /// Ads Random
  Future<void> getAdsRandom({int page = 0}) async {
    HomePageDataSourceImpl adsRandomDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingAdsRandomState());

      var adsRandomData =
          await adsRandomDataSourceImpl.getAdsRandom(pageIndex: page);

      if (adsRandomData.data != null) {
        emit(SuccessAdsRandomState(adsRandomData.data!));
      } else {
        emit(ErrorAdsRandomState(adsRandomData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In adsRandom is : $e in $stack");
      emit(ErrorAdsRandomState("Error is $e"));
    }
  }

  /// get Status User
  Future<void> getStatusUser() async {
    HomePageDataSourceImpl getStatusUserDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingGetStatusUserState());
      }

      var getStatusUserData = await getStatusUserDataSourceImpl.getStatusUser();

      if (getStatusUserData.data != null) {
        if (!isClosed) {
          emit(SuccessGetStatusUserState(getStatusUserData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorGetStatusUserState(getStatusUserData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In GetStatusUser is : $e in $stack");
      if (!isClosed) {
        emit(ErrorGetStatusUserState("Error is $e"));
      }
    }
  }
  ///playNowRadio

  Future<void> playNowRadio() async {
    HomePageDataSourceImpl getStatusUserDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingPlayNowRadioState());
      }

      var getStatusUserData = await getStatusUserDataSourceImpl.playNowRadio();

      if (getStatusUserData.data != null) {
        if (!isClosed) {
          emit(SuccessPlayNowRadioState(getStatusUserData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorPlayNowRadioState(getStatusUserData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In GetStatusUser is : $e in $stack");
      if (!isClosed) {
        emit(ErrorPlayNowRadioState("Error is $e"));
      }
    }
  }

  CategoriesAddPostModel? categoriesAddPostModel;
  List<SubCategoryModel> categoriesHavePrice =[];
  bool isLoadingCategoriesAddPostModel = true;
  CitiesModel? citiesModel;
  ColorNew? colorsPost;
  /// get CategoryMainAndSubCategory
  Future<void> getCategoryMainAndSubCategory() async {
    HomePageDataSourceImpl getStatusUserDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingCategoryMainAndSubCategoryState());
        isLoadingCategoriesAddPostModel = true;
      }

      var getStatusUserData = await getStatusUserDataSourceImpl.getCategoryMainAndSubCategory();
      var getCitiesApp= await getStatusUserDataSourceImpl.getCitiesApp();

      if (getStatusUserData.data != null) {
        if (!isClosed) {
          emit(SuccessCategoryMainAndSubCategoryState(getStatusUserData.data!,getCitiesApp.data!));
          categoriesAddPostModel =getStatusUserData.data!;
          categoriesHavePrice = getStatusUserData.data!.data
              .where((category) => category.have_price == 1)
              .toList();
          citiesModel = getCitiesApp.data!;
          colorsPost = getStatusUserData.data!.colors![0];
          isLoadingCategoriesAddPostModel = false;
        }
      } else {
        if (!isClosed) {
          emit(ErrorCategoryMainAndSubCategoryState(getStatusUserData.error!.message!));
          isLoadingCategoriesAddPostModel = false;
        }
      }
    } catch (e, stack) {
      print("Error In CategoryMainAndSubCategory is : $e in $stack");
      if (!isClosed) {
        emit(ErrorCategoryMainAndSubCategoryState("Error is CategoryMainAndSubCategory $e"));
        isLoadingCategoriesAddPostModel = false;
      }
    }
  }


  Future<void> getCity() async {
    HomePageDataSourceImpl getStatusUserDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingGetCityState());
        isLoadingCategoriesAddPostModel = true;
      }

      var getCitiesApp= await getStatusUserDataSourceImpl.getCitiesApp();

      if (getCitiesApp.data != null) {
        if (!isClosed) {
          emit(SuccessGetCityState(getCitiesApp.data!));
          citiesModel = getCitiesApp.data!;
          isLoadingCategoriesAddPostModel = false;
        }
      } else {
        if (!isClosed) {
          emit(ErrorGetCityState(getCitiesApp.error!.message!));
          isLoadingCategoriesAddPostModel = false;
        }
      }
    } catch (e, stack) {
      print("Error In CategoryMainAndSubCategory is : $e in $stack");
      if (!isClosed) {
        emit(ErrorCategoryMainAndSubCategoryState("Error is CategoryMainAndSubCategory $e"));
        isLoadingCategoriesAddPostModel = false;
      }
    }
  }

  /// get CategoryMainAndSubCategory
  Future<void> addAd({
    required String description,
    required List<String> categories,
     String? price,
     String? couponPercent,
     String? daysAddCoupon,
     int? isAddCoupon,
    required String cityId,
     String? background_color,
     List<File>? image,
  }) async {
    HomePageDataSourceImpl addAdDataDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingAddAdState());
      }

      var addAdData = await addAdDataDataSourceImpl.addAd(
          description: description, categories: categories, price: price ?? '', cityId: cityId, image: image,
      couponPercent: couponPercent ??'',
      daysAddCoupon: daysAddCoupon??'',
      isAddCoupon: isAddCoupon ??0,
      background_color: background_color);
      if (addAdData.data != null) {
        if (!isClosed) {
          emit(SuccessAddAdState(addAdData.data!,));
        }
      } else {
        if (!isClosed) {
          emit(ErrorAddAdState(addAdData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In ErrorAddAdState is : $e in $stack");
      if (!isClosed) {
        emit(ErrorAddAdState("Error is ErrorAddAdState $e"));
      }
    }
  }
  Future<void> getStatusWhatsappStatusCompanyUser({
    required int companyId,
  }) async {
    HomePageDataSourceImpl addAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingStatusWhatsappStatusCompanyState());

      var adsSpecialFeaturesData = await addAdsDataSourceImpl.getStatusWhatsappStatusCompanyUser(userIdCompany: companyId);

      if (adsSpecialFeaturesData.data != null) {
        // emit(SuccessStatusWhatsappStatusCompanyState(adsSpecialFeaturesData.data!));
        if (!isClosed) {
          emit(SuccessStatusWhatsappStatusCompanyState(
              adsSpecialFeaturesData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorStatusWhatsappStatusCompanyState(
              adsSpecialFeaturesData.error!.message!));
        }
        // emit(ErrorStatusWhatsappStatusCompanyState(adsSpecialFeaturesData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorStatusWhatsappStatusCompanyState is : $e in $stack");
      // emit(ErrorStatusWhatsappStatusCompanyState("Error is $e"));
      if (!isClosed) {
        emit(ErrorStatusWhatsappStatusCompanyState("Error is $e"));
      }
    }
  }

  /// get Status User
  Future<void> sendCustomerServes({
    required String type,
    required String userName,
    required String mobileNumber,
    required String messageServes,
  }) async {
    HomePageDataSourceImpl sendMessageSupportSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingSendMessageSupportState());

      var sendMessageSupport =
          await sendMessageSupportSourceImpl.sendCustomerServes(
              type: type,
              userName: userName,
              mobileNumber: mobileNumber,
              messageServes: messageServes);

      if (sendMessageSupport.data != null) {
        emit(SuccessSendMessageSupportState(sendMessageSupport.data!));
      } else {
        emit(ErrorSendMessageSupportState(sendMessageSupport.error!.message!));
      }
    } catch (e, stack) {
      print("Error In SendMessageSupportState is : $e in $stack");
      emit(ErrorSendMessageSupportState("Error is $e"));
    }
  }

  /// Ads Evaluation
  Future<void> getAdsEvaluation() async {
    HomePageDataSourceImpl adsEvaluationDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingAdsEvaluationState());

      var adsEvaluationData =
          await adsEvaluationDataSourceImpl.getAdsEvaluation();

      if (adsEvaluationData.data != null) {
        emit(SuccessAdsEvaluationState(adsEvaluationData.data!));
      } else {
        emit(ErrorAdsEvaluationState(adsEvaluationData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In AdsEvaluation is : $e in $stack");
      emit(ErrorAdsEvaluationState("Error is $e"));
    }
  }

  HomePageLoginModel? dataHomePage;
  /// All Data In Home Page
  Future<void> getAllDataInHomePage({bool isNeedRefresh =true}) async {
    HomePageDataSourceImpl adsAllDataInHomePageImpl =
        const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        if(isNeedRefresh){

          emit(LoadingAllDataHomePageState());
        }else{

          emit(LoadingWithoutRefreshAllDataHomePageState());

        }
      }

      // var adsRandomData = await adsAllDataInHomePageImpl.getAdsRandom();
      var homePageData = await adsAllDataInHomePageImpl.getAllApiHomePage();
      // var categoriesMainData = await adsAllDataInHomePageImpl.getCategoriesMain();
      var categoriesMainData = await adsAllDataInHomePageImpl.getCategoryMainAndSubCategory();
      if (homePageData.data != null && categoriesMainData.data != null) {
        try{
          setDataHomePage( HomePageLoginModel(
              // adsRandomModel:   adsRandomData.data,
              categoriesMainModel:  categoriesMainData.data,
              homePageModel:  homePageData.data
          ));
          dataHomePage=  await getDataHomePage();
          print('تم تخزين بينات الصفحة الرئيسية');
          if (!isClosed) {
          emit(SaveDataHomePageState(dataHomePage));}
        }catch(error,stack){
          print(error);
          print(stack);
          print('فشل في تخزين بينات الصفحة الرئيسية');
          if (!isClosed) {
          emit(ErrorSaveDataHomePageState());}
        }

        if (!isClosed) {
          emit(SuccessAllDataHomePageState(
            homePageModel: homePageData.data,
            // adsRandomModel: adsRandomData.data,
            categoriesMainModel: categoriesMainData.data,
          ));
        }
      } else {
        if (!isClosed) {
          emit(ErrorAllDataHomePageState(
            categoriesMainData.error?.message ??
                homePageData.error?.message ??
                'فشل تحميل الصفحة الرئيسية',
          ));
        }
      }
    } catch (e, stack) {
      print("Error In AdsEvaluation is : $e in $stack");
      if (!isClosed) {
        emit(ErrorAllDataHomePageState("Error is $e"));
      }
    }
  }

  /// Show Ads From User
  Future<void> showAdsFromUser({
    required int adsId,
    required int userId,
  }) async {
    HomePageDataSourceImpl showAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingShowAdsState());

      var showAdsData =
          await showAdsDataSourceImpl.showAds(adsId: adsId, userId: userId);

      if (showAdsData.data != null) {
        if (!isClosed) {
          emit(SuccessShowAdsState(showAdsData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorShowAdsState(showAdsData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In ErrorShowAdsState is : $e in $stack");
      if (!isClosed) {
        emit(ErrorShowAdsState("Error is $e"));
      }
    }
  }


  Future<void> getSettingApp() async {
    HomePageDataSourceImpl showAdsDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      emit(LoadingSettingAppState());

      var showAdsData =
      await showAdsDataSourceImpl.getSettingApp();

      if (showAdsData.data != null) {
        if (!isClosed) {
          emit(SuccessSettingAppState(showAdsData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorSettingAppState(showAdsData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In ErrorShowAdsState is : $e in $stack");
      if (!isClosed) {
        emit(ErrorSettingAppState("Error is $e"));
      }
    }
  }

/*
changeStatusCounterForWhatsappShareChat({
    required int idAds,
    required int userId,
    required int type,
  })
 */

  Future<void> changeStatusCounterForWhatsappShareChat({
    required int idAds,
    required int type,
  }) async {
    HomePageDataSourceImpl showAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingChangeStatusCounterForWhatsappShareChatState());

      var showAdsData = await showAdsDataSourceImpl
          .changeStatusCounterForWhatsappShareChat(idAds: idAds, type: type);

      if (showAdsData.data != null) {
        emit(SuccessChangeStatusCounterForWhatsappShareChatState(
            showAdsData.data!));
      } else {
        emit(ErrorChangeStatusCounterForWhatsappShareChatState(
            showAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorShowAdsState is : $e in $stack");
      emit(ErrorChangeStatusCounterForWhatsappShareChatState("Error is $e"));
    }
  }

  ///

  Future<void> getClickStatistics({
    required int idAds,
  }) async {
    HomePageDataSourceImpl showAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingClickStatisticsState());
      }
      var showAdsData =
          await showAdsDataSourceImpl.getClickStatistics(idAds: idAds);

      if (showAdsData.data != null) {
        if (!isClosed) {
          emit(SuccessClickStatisticsState(showAdsData.data!));
        }
        // emit(SuccessClickStatisticsState(showAdsData.data!));
      } else {
        if (!isClosed) {
          emit(ErrorClickStatisticsState(showAdsData.error!.message!));
        }
        // emit(ErrorClickStatisticsState(showAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorShowAdsState is : $e in $stack");
      if (!isClosed) {
        emit(ErrorClickStatisticsState("Error is $e"));
      }
      // emit(ErrorClickStatisticsState("Error is $e"));
    }
  }

  Future<void> addAndRemoveAdsFromFavorites({
    required int adsId,
  }) async {
    HomePageDataSourceImpl showAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingAddAndRemoveAdsFromFavoritesState());

      var showAdsData = await showAdsDataSourceImpl.favoriteAds(adsId: adsId);

      if (showAdsData.data != null) {
        emit(SuccessAddAndRemoveAdsFromFavoritesState(showAdsData.data!));
      } else {
        emit(ErrorAddAndRemoveAdsFromFavoritesState(
            showAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorShowAdsState is : $e in $stack");
      emit(ErrorAddAndRemoveAdsFromFavoritesState("Error is $e"));
    }
  }

  bool isLoadingIsFavorites =false;
  Future<void> adsIsFavorites({
    required int adsId,
  }) async {
    HomePageDataSourceImpl adsIsFavoritesDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      isLoadingIsFavorites =true;
      emit(LoadingAdsIsFavoritesState());

      var adsIsFavoritesData = await adsIsFavoritesDataSourceImpl.adsIsFavorite(
        adsId: adsId,
      );

      if (adsIsFavoritesData.data != null) {
        if (!isClosed) {isLoadingIsFavorites =false;
          emit(SuccessAdsIsFavoritesState(adsIsFavoritesData.data!));
        }
      } else {
        if (!isClosed) {isLoadingIsFavorites =false;
          emit(ErrorAdsIsFavoritesState(adsIsFavoritesData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In adsIsFavorites is : $e in $stack");
      if (!isClosed) {isLoadingIsFavorites =false;
        emit(ErrorAdsIsFavoritesState(
            "Error is $e")); // Replace ErrorState with your actual error state
      }
    }
  }

  Future<void> getAdsSpecialFeatures() async {
    AddAdsDataSourceImpl addAdsDataSourceImpl = const AddAdsDataSourceImpl();
    try {
      emit(LoadingAdsSpecialFeaturesState());

      var adsSpecialFeaturesData =
          await addAdsDataSourceImpl.getAdsSpecialFeatures();

      if (adsSpecialFeaturesData.data != null) {
        emit(SuccessAdsSpecialFeaturesState(adsSpecialFeaturesData.data!));
      } else {
        emit(ErrorAdsSpecialFeaturesState(
            adsSpecialFeaturesData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In adsSpecialFeatures is : $e in $stack");
      emit(ErrorAdsSpecialFeaturesState("Error is $e"));
    }
  }

  Future<void> addAdsSpecialFeatures({
    required int adsId,
    required int idAdsSpecialFeature,
    required int isHave,
  }) async {
    HomePageDataSourceImpl addAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingAddAdsSpecialFeaturesState());

      var adsSpecialFeaturesData =
          await addAdsDataSourceImpl.addSpecialFeaturesForAds(
        adsId: adsId,
        idAdsSpecialFeature: idAdsSpecialFeature,
        isHave: isHave,
      );

      if (adsSpecialFeaturesData.data != null) {
        emit(SuccessAddAdsSpecialFeaturesState(adsSpecialFeaturesData.data!));
      } else {
        emit(ErrorAddAdsSpecialFeaturesState(
            adsSpecialFeaturesData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In Add adsSpecialFeatures is : $e in $stack");
      emit(ErrorAddAdsSpecialFeaturesState("Error is $e"));
    }
  }

  Future<void> editWhatsappMobile({
    required int adsId,
    required String mobileWhatsapp,
  }) async {
    HomePageDataSourceImpl editWhatsappMobileDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingEditWhatsappMobileState());

      var editWhatsappMobileData =
          await editWhatsappMobileDataSourceImpl.editMobileWhatsappForAds(
              adsId: adsId, mobileWhatsapp: mobileWhatsapp);

      if (editWhatsappMobileData.data != null) {
        emit(SuccessEditWhatsappMobileState(editWhatsappMobileData.data!));
      } else {
        emit(ErrorEditWhatsappMobileState(
            editWhatsappMobileData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In  editWhatsappMobileData is : $e in $stack");
      emit(ErrorEditWhatsappMobileState("Error is $e"));
    }
  }

  bool isLoadingEditAdsInformation =false;
  Future<void> editAdsInformation({
    required int adsId,
    // required String adsName,
    required String adsDescription,
    required String price,
    required String urlBannerInOut,
    required String coupon,
    required String couponDateController,
    required String type,
    required bool isBannerInOut,
  }) async {
    HomePageDataSourceImpl editAdsInformationDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      isLoadingEditAdsInformation= true;
      emit(LoadingEditAdsInformationState());

      var editAdsInformationData =
          await editAdsInformationDataSourceImpl.editAdsInformation(
              adsId: adsId,
              // adsName: adsName,
              urlBannerInOut: urlBannerInOut,
              isBannerInOut: isBannerInOut,
              adsDescription: adsDescription,
              price: price,
              couponDateController: couponDateController,
              coupon: coupon,
              type: type);

      if (editAdsInformationData.data != null) {
        isLoadingEditAdsInformation= false;
        emit(SuccessEditAdsInformationState(editAdsInformationData.data!));
      } else {
        isLoadingEditAdsInformation= false;
        emit(ErrorEditAdsInformationState(
            editAdsInformationData.error!.message!));
      }
    } catch (e, stack) {
      isLoadingEditAdsInformation= false;
      print("Error In  editAdsInformationData is : $e in $stack");
      emit(ErrorEditAdsInformationState("Error is $e`"));
    }
  }

  Future<void> deleteAds({
    required int adsId,
    required String type,
  }) async {
    HomePageDataSourceImpl deleteAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingDeleteAdsState());

      var deleteAdsData =
          await deleteAdsDataSourceImpl.deleteAds(adsId: adsId, type: type);

      if (deleteAdsData.data != null) {
        emit(SuccessDeleteAdsState(deleteAdsData.data!));
      } else {
        emit(ErrorDeleteAdsState(deleteAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In  deleteAdsData is : $e in $stack");
      emit(ErrorDeleteAdsState("Error is $e`"));
    }
  }

  void changeVariable({
    bool isChangeMobile = false,
    bool isChangeVar = false,
    bool isChangeCoupon = false,
    bool isChangeChats = false,
  }) {
    if (isChangeVar) {
      emit(ChangeVariableState());
    }

    if (isChangeMobile) {
      emit(ChangeMobileNumberState());
    }
    if (isChangeCoupon) {
      emit(ChangeCouponState());
    }
    if (isChangeChats) {
      emit(ChangeChatState());
    }
  }

  bool isLoadingEvaluateAds =false;
  Future<void> evaluateAds({
    required int adsId,
    required double value,
  }) async {
    HomePageDataSourceImpl evaluateAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {isLoadingEvaluateAds =true;
      emit(LoadingEvaluateAdsState());

      var evaluateAdsData = await evaluateAdsDataSourceImpl.evaluateAds(
          adsId: adsId, value: value);

      if (evaluateAdsData.data != null) {isLoadingEvaluateAds =false;
        emit(SuccessEvaluateAdsState(evaluateAdsData.data!));
      } else {isLoadingEvaluateAds =false;
        emit(ErrorEvaluateAdsState(evaluateAdsData.error!.message!));
      }
    } catch (e, stack) {isLoadingEvaluateAds =false;
      print("Error In EvaluateAds is : $e in $stack");
      emit(ErrorEvaluateAdsState("Error is $e"));
    }
  }


  Future<void> getCategoriesPartsNewApi({
    required int idCategoryPart,
    required int page,
     bool isLoading =true,
  }) async {
    HomePageDataSourceImpl categoriesPartsDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if(isLoading){
        emit(LoadingCategoriesPartsState());

      }

      var categoriesPartsData = await categoriesPartsDataSourceImpl
          .getCategoriesPartNew(id: idCategoryPart, page: page);

      if (categoriesPartsData.data != null) {
        emit(SuccessCategoriesPartsNewState(categoriesPartsData.data!));
      } else {
        emit(ErrorCategoriesPartsState(categoriesPartsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CategoriesParts is : $e in $stack");
      emit(ErrorCategoriesPartsState("Error is $e"));
    }
  }


  Future<void> filterCategoriesPartsNewApi({
    required int idCategory,
     int? idSubCategory,
     int? idCity,
    bool isLoading =true,
    required int page,
  }) async {
    HomePageDataSourceImpl categoriesPartsDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if(isLoading){
        emit(LoadingFilterCategoriesState());
      }

      var categoriesPartsData = await categoriesPartsDataSourceImpl.filterCategoriesPartNew(idCategory: idCategory, idSubCategory: idSubCategory, idCity: idCity, page: page);

      if (categoriesPartsData.data != null) {
        emit(SuccessFilterCategoriesPartsState(categoriesPartsData.data!));
      } else {
        emit(ErrorFilterCategoriesPartsState(categoriesPartsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CategoriesParts is : $e in $stack");
      emit(ErrorFilterCategoriesPartsState("Error is $e"));
    }
  }


  Future<void> activeChats({
    required int adsId,
  }) async {
    HomePageDataSourceImpl activeChatsForAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingActiveChatsForAdsState());

      var activeChatsForAdsData =
          await activeChatsForAdsDataSourceImpl.activeChatsForAds(adsId: adsId);

      if (activeChatsForAdsData.data != null) {
        emit(SuccessActiveChatsForAdsState(activeChatsForAdsData.data!));
      } else {
        emit(
            ErrorActiveChatsForAdsState(activeChatsForAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ActiveChatsForAds is : $e in $stack");
      emit(ErrorActiveChatsForAdsState("Error is $e"));
    }
  }

  /// Related Ads
  Future<void> getRelatedAds({
    required int adsId,
    required int companyId,
    required int categoryId,
  }) async {
    HomePageDataSourceImpl relatedAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      if (!isClosed) {
        emit(LoadingRelatedAdsState());
      }

      var relatedAdsData = await relatedAdsDataSourceImpl.getRelatedAds(
        adsId: adsId,
        companyId: companyId,
        categoryId: categoryId,
      );

      if (relatedAdsData.data != null) {
        if (!isClosed) {
          emit(SuccessRelatedAdsState(relatedAdsData.data!));
        }
      } else {
        if (!isClosed) {
          emit(ErrorRelatedAdsState(relatedAdsData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In RelatedAds is : $e in $stack");
      if (!isClosed) {
        emit(ErrorRelatedAdsState("Error is $e"));
      }
    }
  }


  Future<void> getDetailsProductApi({
    required int idDetailsProduct,
    bool isNeedRefresh =true
  }) async {
    HomePageDataSourceImpl detailsProductDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      if(isNeedRefresh)
      {
        emit(LoadingDetailsProductState());

      }else{

        emit(LoadingWithoutRefreshDetailsProductState());

      }
      var detailsProductData = await detailsProductDataSourceImpl
          .getDetailsProduct(id: idDetailsProduct);

      if (detailsProductData.data != null) {
        emit(SuccessDetailsProductState(detailsProductData.data!));
      } else {
        emit(ErrorDetailsProductState(detailsProductData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In DetailsProduct is : $e in $stack");
      emit(ErrorDetailsProductState("Error is $e"));
    }
  }


  Future<void> getGovernmentWithServices() async {
    HomePageDataSourceImpl detailsProductDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      emit(LoadingGovernmentWithServicesState());

      var detailsProductData = await detailsProductDataSourceImpl.getGovernmentWithServices();

      if (detailsProductData.data != null) {
        emit(SuccessGovernmentWithServicesState(detailsProductData.data!));
      } else {
        emit(ErrorGovernmentWithServicesState(detailsProductData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In DetailsProduct is : $e in $stack");
      emit(ErrorGovernmentWithServicesState("Error is $e"));
    }
  }

  Future<void> getDetailsBannerApi({
    required int idDetailsBanner,
    bool isNeedRefresh =true
  }) async {
    HomePageDataSourceImpl detailsProductDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      if(isNeedRefresh)
      {
        emit(LoadingDetailsProductState());

      }else{

        emit(LoadingWithoutRefreshDetailsProductState());

      }

      var detailsProductData = await detailsProductDataSourceImpl
          .getDetailsBanner(id: idDetailsBanner);

      if (detailsProductData.data != null) {
        emit(SuccessDetailsBannerState(detailsProductData.data!));
      } else {
        emit(ErrorDetailsProductState(detailsProductData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In DetailsProduct is : $e in $stack");
      emit(ErrorDetailsProductState("Error is $e"));
    }
  }

  List<GetSectionData> dataSectionList =[];
  Future<void> getSectionSetting() async {
    HomePageDataSourceImpl getSectionDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      emit(LoadingGetSectionSettingState());

      var getSection = await getSectionDataSourceImpl.getSectionSetting();

      if (getSection.data != null) {
        dataSectionList =getSection.data!.data;
        emit(SuccessGetSectionSettingState(getSection.data!));

      } else {
        emit(ErrorGetSectionSettingState(getSection.error!.message!));
      }
    } catch (e, stack) {
      print("Error In Get Section is : $e in $stack");
      emit(ErrorGetSectionSettingState("Error is $e"));
    }
  }


  bool isShowEditAds = false;
  void changeShowEditAds(bool isShow) {
    isShowEditAds = isShow;
    emit(ChangeShowEditAdsState());
  }


}

void subscribeToTopic() async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic('unregistered');
    if(DIManager.findDep<SharedPrefs>().getToken() != null){
      await FirebaseMessaging.instance.subscribeToTopic('registered');
    }
    if(DIManager.findDep<SharedPrefs>().getAccountType() =='company'){
      await FirebaseMessaging.instance.unsubscribeFromTopic('registeredCompany');
    }
    if(DIManager.findDep<SharedPrefs>().getAccountType() =='individual'){
      await FirebaseMessaging.instance.unsubscribeFromTopic('registeredIndividual');
    }
    //individual
    print('Successfully subscribed to topic');
  } catch (e) {
    debugPrint('Failed to subscribe to topic: $e');
  }
}
