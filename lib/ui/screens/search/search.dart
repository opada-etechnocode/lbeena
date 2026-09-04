import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/search/seach_model.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/search/cubit/search_cubit.dart';
import 'package:syrians_in_uae/widgets/ads_product_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/home_page/banner_product_model.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loader_for_page.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../widget/url_webview.dart';
import '../details_product/details_product.dart';
import '../home/widget/main_cateogies.dart';

class SearchPage extends StatefulWidget {
   SearchPage({super.key,required this.categoriesMainModel});
  CategoriesAddPostModel? categoriesMainModel;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
   // SearchItemModel? searchItemModel;

   final RefreshController _refreshController =
   RefreshController(initialRefresh: false);
  final FocusNode _firstFocusNode = FocusNode();
  int page =1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('object');
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: Scaffold(
          appBar: appBarNormalWithIcon(text: 'البحث', context: context,isShowBack: true),
          body: MultiBlocProvider(
          providers: [
            BlocProvider(
            create: (context) => SearchCubit(),
        ),
            BlocProvider(
        create: (context) => HomeCubit(),
            ),
          ],
          child: BlocConsumer<SearchCubit, SearchState>(
              listener: (context, state) {
                if(state is SuccessSearchItemState) {
                  // searchItemModel = state.searchItemModel;
                  SearchCubit.get(context).data.addAll(state.searchItemModel!.data!.data);
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30.w, right: 30.w,top: 10.h),
                      child: CustomSearchView(
                        autofocus: false,
                        controller: SearchCubit.get(context).searchController,
                focusNode: _firstFocusNode,
                        hintText: "إعلان ...",
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (text){
                          if(SearchCubit.get(context).categoryId ==-1)
                          {
                            SearchCubit.get(context).getSearchItem(title: text,
                              page: 1,
                              clearDate: true ,);
                          }else {
                            SearchCubit.get(context).getSearchItem(title: text,
                              page: 1,
                              clearDate: true ,
                              categoryId: SearchCubit.get(context).categoryId,);
                          }
                        },
                      ),
                    ),
                    MainCategories(
                      isFromSearchPage: true,
                      categoriesMainModel:widget.categoriesMainModel,
                    ),
                    sizeHeightNormal(),
                    SearchCubit.get(context).isLoadingSearch? loaderNormal(): Expanded(
                        flex: 3,child:  SmartRefreshWidget(
                        onRefresh: () async {

                          page=1;
                          if(SearchCubit.get(context).categoryId ==-1)
                          {
                            SearchCubit.get(context).getSearchItem(title: SearchCubit.get(context).searchController.text,
                              page: page,
                              clearDate: true ,);
                          }else {
                            SearchCubit.get(context).getSearchItem(title:SearchCubit.get(context).searchController.text,
                              page: page,
                              clearDate: true ,
                              categoryId: SearchCubit.get(context).categoryId,);
                          }
                          setState(() {

                          });
                          _refreshController
                              .refreshCompleted();
                        },
                        controller: _refreshController,
                        onLoading: () async {
                          page++;
                          if(SearchCubit.get(context).categoryId ==-1)
                          {
                            SearchCubit.get(context).getSearchItem(title: SearchCubit.get(context).searchController.text,
                              page: page,
                              clearDate: false ,);
                          }else {
                            SearchCubit.get(context).getSearchItem(title:SearchCubit.get(context).searchController.text,
                              page: page,
                              clearDate: false ,
                              categoryId: SearchCubit.get(context).categoryId,);
                          }
                          setState(() {});
                          _refreshController
                              .loadComplete();
                        },child: SingleChildScrollView(child:

                      _buildAdsItems(data: SearchCubit.get(context).data)))),
                  ],
                );
              },
            ),
        ),
        ),
      ),
    );
  }

  Widget _buildAdsItems(
      {
       required List<DataProductBannerModel> data,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          data.isEmpty ? textNormal(text: 'لايوجد نتائج ..'): Align(
            alignment: Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {

                      switch (data[index].type) {
                        case 'A':
                          if (data[index].inOut == '1') {
                            final Uri url = Uri.parse(data[index].url.toString());
                            launchUrl(url,mode: LaunchMode.externalApplication);
                          } else {
                            navigatorToPush(
                                context: context,
                                pageName: DetailsProduct(
                                  detailsProduct: data[index],
                                  categoryId: data[index].categoryId.toString(),
                                  adsName:  data[index].name,
                                  idAds:  data[index].adsId.toString(),
                                  isBanner: true,

                                  idBannerOrProduct: int.parse(data[index].bannerId!),
                                  idAdOnwerCompany: int.parse(data[index].userId!),
                                ));
                          }
                          break;
                        case 'B':
                          navigatorToPush(
                              context: context,
                              pageName: DetailsProduct(
                                adsName: data[index].name,
                                categoryId: data[index].categoryId.toString(),
                                detailsProduct: data[index],
                                idAds:  data[index].adsId.toString(),
                                idBannerOrProduct: int.parse(data[index].adsId!),
                                idAdOnwerCompany: int.parse(data[index].userId!),
                              ));
                          break;
                        case 'C':
                          navigatorToPush(
                              context: context,
                              pageName: UrlWebViewPage(
                                titleAppBer: data[index].videoName.toString(),
                                urlPage: data[index].videoLink.toString(),
                              ));
                          break;
                        default:
                          print('Invalid fruit selection.');
                      }

                    },
                    child: AdsProductWidget(
                      dataProductItem: data[index],
                      isVideo: data[index].type == 'C'?true:false,
                    ));
              },
            ),
          ),

        ],
      ),
    );
  }
}
