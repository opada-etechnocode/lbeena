import 'dart:developer';
import 'package:syrians_in_uae/data/models/news/news_model.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/app_colors.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/page_loading_shimmer.dart';
import '../../../widgets/top_curved_item.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/theme_helper.dart';
import 'components/news_card.dart';
import 'cubit/news_bloc_cubit.dart';
import '../../../widgets/smart_refresh_widget.dart';
class NewsListScreen extends StatefulWidget {
  static const String routeName = "/news-screen";

  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  // late ScrollController _scrollController;
  final TextEditingController searchTfController = TextEditingController();
  // final _debouncer = Debouncer(milliseconds: 600);

  String? keyWord;

  @override
  void initState() {
    // getData();
    initScroll();
    super.initState();
  }

  // getData() {
  //   AppBloc.newsBloc.add(const OnFetchNews());
  // }

  initScroll() {
    // _scrollController = ScrollController();
    //
    // _scrollController.addListener(() {
    //   final maxScrollExtent = _scrollController.position.maxScrollExtent;
    //   final currentScroll = _scrollController.position.pixels;
    //   final screenHeight = MediaQuery.of(context).size.height;
    //   final threshold = (3 / 4) * screenHeight;
    //   if (currentScroll >= threshold && currentScroll >= maxScrollExtent) {
    //     log("3/4 scroll reached");
    //     // AppBloc.newsBloc.add(OnPaginateNews(keyword: keyWord));
    //   }
    // });
  }


  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  // NewsModel? newsModel;
  List<NewsList> data = [];
int page = 1;
  bool isLoading =true;
  String? valueSearch;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: HandelAndroidApp(
        child: Scaffold(

          appBar: appBarNormalWithIcon(text:AppLocalizations.of(context)!.news,isShowBack: true,context: context),
          body: BlocProvider(
            create: (context) => NewsBlocCubit()..getAllNews(page: 1),
            child: BlocConsumer<NewsBlocCubit, NewsBlocState>(
              listener: (context, state) {
                if (state is SuccessGetAllNewsState) {
                  data.addAll(state.newsModel.news!.data);
                  isLoading =false;
                }
                if (state is LoadingGetAllNewsState){
                  isLoading =true;
                }
                if(state is SuccessSearchNewsState){
                  data.addAll(state.newsModel.news!.data);
                }
                if(state is LoadingSearchNewsState){
                  data.clear();
                }
              },
              builder: (context, state) {
                return SmartRefreshWidget(

                  onRefresh: () async {
                    data = [];
                    page = 1;
                    await BlocProvider.of<NewsBlocCubit>(context).getAllNews(page: page,);
                    _refreshController.refreshCompleted();
                  },
                  controller: _refreshController,
                  onLoading: () async {
                    page++;
                    if(valueSearch == null)
                    {
                      await BlocProvider.of<NewsBlocCubit>(context).getAllNews(page:page ,isLoading: true);

                    }else {
                      await BlocProvider.of<NewsBlocCubit>(context).getSearchNews(page:page ,title: valueSearch!,isLoading: true);

                    }
                      setState(() {});
                    _refreshController.loadComplete();
                  },
                  child: SingleChildScrollView(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    // controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.symmetric(),
                          //   child: AppTextField(
                          //     appTextFieldParameters: AppTextFieldParameters(
                          //       controller: searchTfController,
                          //       onChanged: (value) {
                          //         _debouncer.run(() => search(value: value));
                          //       },
                          //       hintText:
                          //           AppLocalizations.of(context)!.search_news_hint,
                          //       prefix: SvgPicture.asset(AppIcons.search),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 20),
                          Container(
                            width: 350.w,

                            child: CustomSearchView(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.h,),
                              controller: searchTfController,
                              hintText: AppLocalizations.of(context)!.search_news_hint,
                              onChanged: (value){
                                setState(() {
                                  valueSearch = value;
                                });

                                NewsBlocCubit.get(context).getSearchNews(title: valueSearch!,page: 1,isLoading: false);
                              },
                            ),
                          ),
                          if (isLoading) ...{
                            PageLoadingShimmer(),
                          },
                          if (!isLoading) ...{

                            ListView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                // primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                // reverse: true,
                                itemBuilder: (ctx, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 10.w),
                                    child: NewsCard(
                                      news: data[index],
                                    ),
                                  );
                                }),
                            data.length == 0 ?textNormal(text: AppLocalizations.of(context)!.dont_have_result):Container(),
                          },

                          if (state is LoadingGetLoaderNewsState) ...[
                            Center(
                              child: Container(
                                  width: 20.h,
                                  height: 20.h,
                                  child: CircularProgressIndicator(color: appTheme.greenColor,
                                    strokeWidth: 1.5,
                                  )),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
