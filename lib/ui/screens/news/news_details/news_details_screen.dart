import 'dart:developer';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/news/news_related_model.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/news/cubit/news_bloc_cubit.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../data/models/news/news_model.dart';
import '../../../../widgets/ads_product_widget.dart';
import '../../../../widgets/page_loading_shimmer.dart';
import '../../../../widgets/top_curved_item.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../widget/url_webview.dart';
import '../../company/info_company.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const String routeName = "/news-details-screen";

  NewsDetailsScreen({super.key, required this.news, required this.idNews});

  dynamic news;
  int? idNews;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  // NewsDetailsScreenArgs args = NewsDetailsScreenArgs();
  // final NewsRemoteDataSource newsRemoteDataSource = NewsRemoteDataSource();

  bool _isInit = false;
  bool isLoading = false;
  bool isRelatedLoading = true;


  Future<void> onRefresh() async {
    if (widget.news == null) return;
    // await setById(id: widget.news!.id);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
  }

  setById({String? id, bool isLoading_ = true}) async {
    if (isLoading_) {
      setState(() => isLoading = true);
    }
    log("isLoading --- $isLoading");
    // News? news = await newsRemoteDataSource.fetchNewsById(newsId: id ?? widget.id!);
    if (isLoading_) {
      setState(() => isLoading = false);
    }
    log("isLoading$isLoading");

    // if (news != null) {
    //   widget.news = news;
    //   log("news fetched from id");
    //   setState(() {});
    // }
  }
List<RelatedNew> relatedNews =[];
  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text:   isLoading || widget.news == null
            ? ""
            : widget.news!.title ?? "-",isShowBack: true,context: context),
        body: BlocProvider(
          create: (context) => NewsBlocCubit()..getRelatedNews(idNew: widget.idNews!),
          child: BlocConsumer<NewsBlocCubit, NewsBlocState>(
            listener: (context, state) {
              if (state is SuccessGetNewState) {
                widget.news = state.data;
                isLoading = false;
              }

              if (state is SuccessRelatedNewsState) {
                relatedNews = state.newsModel.relatedNews;
                isRelatedLoading = false;
              }

             if(state is LoadingRelatedNewsState){
               isRelatedLoading = true;
             }

              if (state is LoadingGetAllNewsState) {
                isLoading = true;
              }
            },
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () {
                  NewsBlocCubit.get(context).getRelatedNews(idNew: widget.idNews!);
                  return NewsBlocCubit.get(context)
                      .getItemNews(idNew: widget.idNews!);
                },
                color: appTheme.greenColor,
                backgroundColor: appTheme.lightBlue100,
                child: isLoading
                    ? const PageLoadingShimmer()
                    : widget.news == null
                        ? Container()
                        : SingleChildScrollView(
                            // physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),
                                  if (widget.news!.image != null) ...{
                                    InkWell(
                                        onTap: () {
                                          if (widget.news.image != null) {
                                            // navigatorToPush(
                                            //     context: context,
                                            //     pageName: UrlWebViewPage(
                                            //       titleAppBer: news.title.toString(),
                                            //       urlPage: news.image.toString(),
                                            //     ));

                                            navigatorToPush(context: context,
                                                pageName: ShowCommercialLicense(
                                                  commercialLicense:  widget.news.image.toString(),
                                                  isPdf: false,
                                                  isNotNeedTitleAppbar: true,));
                                          }
                                        },
                                      child:
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child:  AspectRatio(
                                        aspectRatio: 1080 / 1350,
                                        child: CustomImageView(
                                          imagePath: widget.news!.image!.toString().contains('http')? widget.news!.image!: AppEndpoints.baseUrlWithoutApi +
                                              widget.news!.image!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    )),
                                    SizedBox(height: 10.h),
                                  },
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                widget.news!.title ?? "-",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ),
                                            if (widget.news!.isTape == 1)
                                              Icon(
                                                Icons.local_fire_department,
                                                color: Colors.orange,
                                                size: 25.fSize,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.news!.createdAt != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Text(
                                        // widget.news!.createdAt!.toString().ago(),
                                        formatDateTime(widget.news!.createdAt!),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.news!.description ?? "-",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(overflow: TextOverflow.visible),
                                  ),
                                  if (widget.news!.source != null)
                                    GestureDetector(
                                      onTap: () {
                                        if(widget.news?.link !=null){
                                          navigatorToPush(
                                              context: context,
                                              pageName: UrlWebViewPage(
                                                titleAppBer:
                                                widget.news!.source.toString(),
                                                urlPage:
                                                widget.news!.link.toString(),
                                              ));
                                        }

                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Text(
                                          widget.news!.source!.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.blue),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
      //

                                  isRelatedLoading
                                      ? PageLoadingShimmer()
                                      : relatedNews.isEmpty ?Container(): Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          sizeHeightNormal(
                                            height: 20.h,
                                          ),
                                          textNormal(
                                            text: 'المزيد من الاخبار',
                                            fontSize: AppFontSize.fontSize_18,
                                            fontWeight: FontWeight.w600,
                                            color: appTheme.deepPurpleA100,
                                          ),
                                          sizeHeightNormal(),
                                          relatedNewsWidget(
                                                                            context,news: relatedNews,
                                            ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                          ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget relatedNewsWidget(context,{required List<RelatedNew>? news}) {
  return Container(
      height: 900.h,
      child: ListView.builder(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        itemCount: news!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              navigatorToPush(
                  context: context,
                  pageName: NewsDetailsScreen(
                    news: news[index],
                    idNews: int.parse(news[index].id!),
                  ));
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                width: double.infinity,
                // height: 140.h,
                decoration: BoxDecoration(
                  color: appTheme.lightBlue100,
                  borderRadius:
                  BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 9.h),
                  child: Row(
                    children: [
                      news[index].image == null?Container():    Container(
                        width: 140.w,
                        height: 140.h,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              20.r),
                          child: news![index].image == null?Container(): CustomImageView(
                            imagePath: news![index].image!.toString().contains('http')? news![index].image!: AppEndpoints
                                .baseUrlWithoutApi +
                                news![index].image!,
                            fit: BoxFit.cover,
                            height: 140.h,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.all(8.0),
                        child: Container(
                          width:news![index].image == null?320.w: 200.w,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            news![index]
                                                .title ??
                                                "-",
                                            style: Theme.of(
                                                context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                              fontSize:
                                              AppFontSize.fontSize_16,
                                            ),
                                          ),
                                        ),
                                        if (news![index]
                                            .isTape ==
                                            1)
                                          Icon(
                                            Icons
                                                .local_fire_department,
                                            color: Colors
                                                .orange,
                                            size: 25
                                                .fSize,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (news![index]
                                  .createdAt !=
                                  null)
                                Padding(
                                  padding:
                                  EdgeInsets.only(
                                      top: 5.h),
                                  child: Text(
                                    // news![index].createdAt!.toString().ago(),
                                    formatDateTime(news![index]
                                        .createdAt!),
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style: Theme.of(
                                        context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                      fontWeight:
                                      FontWeight
                                          .w400,
                                    ),
                                  ),
                                ),
                              sizeHeightNormal(
                                  height: 4.h),
                              Text(
                                news![index]
                                    .description ??
                                    "-",
                                maxLines: 3,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    fontSize:
                                    AppFontSize.fontSize_11),
                              ),
                              if (news[index].source !=
                                  null)
                                GestureDetector(
                                  onTap: () {
                                    navigatorToPush(
                                        context:
                                        context,
                                        pageName:
                                        UrlWebViewPage(
                                          titleAppBer: news![index]
                                              .source
                                              .toString(),
                                          urlPage: news![index]
                                              .link
                                              .toString(),
                                        ));
                                  },
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(
                                        top: 10.h),
                                    child: Text(
                                    news![index].source!
                                          .toString(),
                                      style: Theme.of(
                                          context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          color: Colors
                                              .blue),
                                      maxLines: 3,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ));
}