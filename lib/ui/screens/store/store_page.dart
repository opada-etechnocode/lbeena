import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/ui/screens/store/cubit/store_cubit.dart';
import 'package:syrians_in_uae/ui/screens/store/cubit/store_state.dart';
import 'package:syrians_in_uae/ui/screens/store/widget/card_ads_store_widget.dart';
import 'package:syrians_in_uae/widgets/components.dart';

import '../../../widgets/smart_refresh_widget.dart';
import '../../../widgets/store_ads_shimmer.dart';
import '../details_product/details_product.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int page = 1;

  @override
  void initState() {
    if (StoreCubit.get(context).asdStoreData.isEmpty) {
      StoreCubit.get(context).getAdsStore(page: 1, isRefresh: true);
    }else{
      StoreCubit.get(context).getAdsStore(page: 1, isRefresh: false,isUpdateData: true);
    }
    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  onRefresh(context) async {
    page =1;
    await StoreCubit.get(context).getAdsStore(page: 1, isRefresh: true);
    _refreshController.refreshCompleted();
  }
  onLoading(context) async {
    page++;
    await StoreCubit.get(context).getAdsStore(page: page, isRefresh: false);
    setState(() {});
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNormalWithIcon(
          text: 'المتجر', context: context, isShowBack: true),
      body: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SmartRefreshWidget(
              onRefresh: () async {
                onRefresh(context);
              },
              controller: _refreshController,
              onLoading: () async {
                onLoading(context);
              },
              child:  StoreCubit.get(context).isLoadingDate?AdsStoreShimmer():SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    sizeHeightNormal(height: 5.h),
                    StoreCubit.get(context).bannerStore ==null?Container():  buildBannerItem(
                        context,StoreCubit.get(context).bannerStore!,horizontal: 10.w),
                    sizeHeightNormal(),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 14.w),
                      child: textNormal(text: 'متجرنا في الإمارات'),
                    ),
                    sizeHeightNormal(),
                    StoreCubit.get(context).asdStoreData.length ==0?Center(
                      child: textNormal(text: 'لا يوجد منتجات بعد'),
                    ):   GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 0.75,
                        ),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 5.h,left: 10.w,right: 10.w),
                        itemCount: StoreCubit.get(context).asdStoreData.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              navigatorToPush(
                                  context: context,
                                  pageName: DetailsProduct(
                                    detailsProduct: StoreCubit.get(context).asdStoreData[index],
                                    isFromStore: true,
                                    categoryId:StoreCubit.get(context).asdStoreData[index].categoryId.toString(),
                                    adsName: StoreCubit.get(context).asdStoreData[index].name,
                                    idAds: StoreCubit.get(context).asdStoreData[index].adsId.toString(),
                                    idBannerOrProduct:
                                    int.parse(StoreCubit.get(context).asdStoreData[index].adsId!),
                                    idAdOnwerCompany:
                                    int.parse(StoreCubit.get(context).asdStoreData[index].userId!),
                                  ));
                            },
                            child: CardAdsStoreWidget(
                                dataProductItem: StoreCubit.get(context).asdStoreData[index],
                            ),
                          );
                        }),
                    sizeHeightNormal(height: 20.h),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
