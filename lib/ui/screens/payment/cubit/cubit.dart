
import 'package:syrians_in_uae/data/sources/payment/payment_data_source.dart';
import 'package:syrians_in_uae/ui/screens/payment/cubit/status.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/sources/profile/profile_page_data_source.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(InitialPaymentState());

  static PaymentCubit get(context) => BlocProvider.of(context);


  Future<void> paymentForPackage({
    required int idPackage,
}) async {
    PaymentPageDataSourceImpl pageDataSource =
    const PaymentPageDataSourceImpl();
    try {
      emit(LoadingPaymentPackageState());

      var pageData =
      await  pageDataSource.paymentPackage(packageId:idPackage );

      if (pageData.data != null) {
        emit(SuccessPaymentPackageState(pageData.data!));
      } else {
        emit(ErrorPaymentPackageState(pageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CategoriesMain is : $e in $stack");
      emit(ErrorPaymentPackageState("Error is $e"));
    }
  }


  Future<void> changeStatusAdsFromUnPaid({
    required int idAds,
  }) async {
    PaymentPageDataSourceImpl pageDataSource =
    const PaymentPageDataSourceImpl();
    try {
      emit(LoadingChangeStatusAdsFromUnPaidState());

      var pageData =
      await  pageDataSource.changeStatusAdsFromUnPaid(idAds: idAds);

      if (pageData.data != null) {
        emit(SuccessChangeStatusAdsFromUnPaidState(pageData.data!));
      } else {
        emit(ErrorChangeStatusAdsFromUnPaidState(pageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CategoriesMain is : $e in $stack");
      emit(ErrorChangeStatusAdsFromUnPaidState("Error is $e"));
    }
  }

  Future<void> getPackageCompany() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingPackageCompanyState());

      var packageData = await profileDataSourceImpl.getPackageCompany();

      if (packageData.data != null) {
        emit(SuccessPackageCompanyState(packageData.data!));
      } else {
        emit(ErrorPackageCompanyState(packageData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorPackageCompanyState(e.toString()));
    }
  }





  Future<void> paymentAdsByPackage({
    required int packageId,
    required String priceAds,
    required int idAds,
    required String paymentMethod,
  }) async {
    PaymentPageDataSourceImpl pageDataSource =
    const PaymentPageDataSourceImpl();
    try {
      emit(LoadingPaymentAdsState());

      var pageData =
      await  pageDataSource.paymentAdsByPackage(
        idAds:idAds ,packageId: packageId,paymentMethod:paymentMethod ,priceAds:priceAds ,
      );

      if (pageData.data != null) {
        emit(SuccessPaymentAdsState(pageData.data!));
      } else {
        emit(ErrorPaymentAdsState(pageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CategoriesMain is : $e in $stack");
      emit(ErrorPaymentAdsState("Error is $e"));
    }
  }


  // Future<void> payForAdsSpecialFeatures({
  //   required int idAdSpecialFeature,
  //   required String priceSpecialFeature,
  //   required int idAds,
  //   required String paymentMethod,
  // }) async {
  //   PaymentPageDataSourceImpl pageDataSource =
  //   const PaymentPageDataSourceImpl();
  //   try {
  //     emit(LoadingPayForAdsSpecialFeaturesState());
  //
  //     var pageData =
  //     await  pageDataSource.payForAdsSpecialFeatures(paymentMethod: paymentMethod,
  //         idAdSpecialFeature: idAdSpecialFeature,
  //         idAds: idAds,
  //         priceSpecialFeature: priceSpecialFeature,);
  //
  //     if (pageData.data != null) {
  //       emit(SuccessPayForAdsSpecialFeaturesState(pageData.data!));
  //     } else {
  //       emit(ErrorPayForAdsSpecialFeaturesState(pageData.error!.message!));
  //     }
  //   } catch (e, stack) {
  //     print("Error In Error Pay ForAdsSpecialFeaturesState is : $e in $stack");
  //     emit(ErrorPayForAdsSpecialFeaturesState("Error is $e"));
  //   }
  // }
}
