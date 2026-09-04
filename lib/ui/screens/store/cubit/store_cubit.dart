import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syrians_in_uae/ui/screens/store/cubit/store_state.dart';

import '../../../../data/models/home_page/banner_product_model.dart';
import '../../../../data/sources/store/store_remote_data_source.dart';


class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreInitial());

  static StoreCubit get(context) => BlocProvider.of(context);

  List<DataProductBannerModel> asdStoreData =[];
  DataProductBannerModel? bannerStore;
  bool isLoadingDate =true;
  Future<void> getAdsStore({required int page,required bool isRefresh,bool isUpdateData =false}) async {
    StoreRemoteDataSourceImpl storeRemoteDataSourceImpl = const StoreRemoteDataSourceImpl();
    try {
      if(!isUpdateData){
        if(isRefresh){
          isLoadingDate =true;
        }else{
          isLoadingDate =false;
        }
      }else {
        isLoadingDate =false;
      }

      emit(GatAdsStoreStateLoading());
      var data = await storeRemoteDataSourceImpl.getStoreAds(page: page);
      if (data.data != null) {
        if(!isUpdateData){
        if(isRefresh){
          asdStoreData = data.data!.data!.adsProduct!.data;
          if( data.data!.data!.adsBanner!.data.isNotEmpty){

            bannerStore = data.data!.data!.adsBanner!.data[0];
          }
        }else{
          asdStoreData.addAll( data.data!.data!.adsProduct!.data);
        }}else{
          // final newItems = data.data!.data!.adsProduct!.data;
          // final uniqueItems = <DataProductBannerModel>[];
          //
          // for (final newItem in newItems) {
          //   if (!asdStoreData.any((existingItem) => existingItem.adsId == newItem.adsId)) {
          //     uniqueItems.add(newItem);
          //   }
          // }
          // asdStoreData = [...asdStoreData, ...uniqueItems];
          if( data.data!.data!.adsBanner!.data.isNotEmpty){
            bannerStore = data.data!.data!.adsBanner!.data[0];
          }
          asdStoreData = data.data!.data!.adsProduct!.data;
        }
        isLoadingDate =false;
        emit(GatAdsStoreStateSuccess(data.data!));
      } else {
        isLoadingDate =false;
        emit(GatAdsStoreStateError(data.data?.message??''));
      }
    } catch (e, stack) {
      isLoadingDate =false;
      print("Error In GatAdsStore is : $e in $stack");
      emit(GatAdsStoreStateError(e.toString()));
    }
  }
}
