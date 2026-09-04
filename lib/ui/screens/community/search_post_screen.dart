import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/custom_search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../data/models/community/hashtag_model.dart';
import '../../../widgets/community_shimmer.dart';
import '../../../widgets/components.dart';
import '../../../widgets/main_parts_shimmer.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/theme_helper.dart';
import 'cubit/community_cubit.dart';
import 'list_coummunity.dart';

class SearchPostScreen extends StatefulWidget {
  SearchPostScreen({super.key,});


  @override
  State<SearchPostScreen> createState() => _SearchPostScreenState();
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  TextEditingController controllerNew = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController? controllerUrlAds = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> idHashtag = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final FocusNode _secondFocusNode = FocusNode();
  List<CommunityModelDatum>? communityPostModel = [];
  bool isLoading = false;
  int page = 1;
  String? idHashtagNew;
  // String? controllerNew.text;
  String? hashtagName;
  bool isLoadingHashtag = true;
  bool isError = false;
  List<bool> isSelectAvailableList = List.generate(100, (index) => false);
  bool isSelectAvailable=false;
  int checkIndexColors = 0;
  String colorsChoose = '#f52323';
  AllHashtagModel? allHashtagModel;
  List<CommunityModelDatum> filteredCommunityPosts = [];

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: BlocProvider(
        create: (context) => CommunityCubit()
          ..getAllHashtagPost(),
        child: BlocConsumer<CommunityCubit, CommunityState>(
          listener: (context, state) {
            if (state is ErrorGetAllCommunityPostState) {
              SnackBarHelper.mySnackBarError(state.message, context);
              isLoading = false;
              isError = true;
            }

            if (state is ErrorGetAllHashtagPostState) {
              // isLoadingHashtag = false;
            }

            if (state is SuccessGetAllHashtagPostState) {
              allHashtagModel = state.data;
              isLoadingHashtag = false;
            }

            if (state is LoadingGetAllHashtagPostState) {
              isLoadingHashtag = true;
            }

            if (state is SuccessGetAllCommunityPostState) {

              communityPostModel!.addAll(state.data.data!.data);

            //   communityPostModel= communityPostModel!.where((post) {
            // return post.hashtags.contains(widget.hashtagName);
            // }).toList();
              isLoading = false;
              isError = false;
            }

            if (state is LoadingGetAllCommunityPostState) {
              communityPostModel!.clear();
              isLoading = true;
              isError = false;
            }


            if (state is ErrorLikePostState) {
              SnackBarHelper.mySnackBarError(state.message, context);
            }

            /// state delete post
            if (state is ErrorDeletePostState) {
              SnackBarHelper.mySnackBarError(state.message, context);
            }
          },
          builder: (context, state) {
            return HandelAndroidApp(
              child: Scaffold(
                appBar: appBarNormalWithIcon(text:  'سوشال', context: context,isShowBack: true) ,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sizeHeightNormal(),
                   CustomSearchView(
                     width: 350.w,
                     focusNode: _secondFocusNode,
                     controller: controllerNew,
                     hintText: 'ابحث هنا ..',
                     contentPadding: EdgeInsets.all(5.sp),
                     textInputAction: TextInputAction.search,
                     onFieldSubmitted: (value){
                       // controllerNew.text =value;

                       if(idHashtagNew =='-1'){     BlocProvider.of<CommunityCubit>(context).searchPost(page: page,
                         content: controllerNew.text,
                       );}else {
                         BlocProvider.of<CommunityCubit>(context).searchPost(page: page,hashtagId:idHashtagNew,
                           content: controllerNew.text,
                         );
                       }
                     },
                     // onChanged: (value){
                     //   if(value.length >3){
                     //     controllerNew.text =value;
                     //
                     //     if(idHashtagNew =='-1'){     BlocProvider.of<CommunityCubit>(context).searchPost(page: page,
                     //       content: controllerNew.text,
                     //     );}else {
                     //       BlocProvider.of<CommunityCubit>(context).searchPost(page: page,hashtagId:idHashtagNew,
                     //         content: controllerNew.text,
                     //       );
                     //     }
                     //   }else {
                     //    setState(() {
                     //      controllerNew.text =value;
                     //    });
                     //   }
                     // },
                   ),
                    sizeHeightNormal(),
                  isLoadingHashtag ?MainPartsShimmer(
                    isFromAddAds: true,
                  ): allHashtagModel ==null?Container():Container(
                    width: 400.w,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(

                         children: <Widget>[
                           InkWell(
                             onTap: () {
                               controllerNew.clear();
                               setState(() {
                                 // قم بتحديد العنصر الحالي فقط عن طريق جعل جميع العناصر الأخرى غير محددة
                                 for (int i = 0; i < isSelectAvailableList.length; i++) {
                                   isSelectAvailableList[i] = i == -1;

                                 }
                                 idHashtagNew = '-1';
                                 hashtagName = '';
                                 BlocProvider.of<CommunityCubit>(context).searchPost(page: 1,
                                     content: controllerNew.text);
                               });
                             },
                             child: Chip(
                               backgroundColor: idHashtagNew =='-1'
                                   ? appTheme.deepPurpleA100
                                   : Colors.grey,
                               label: textNormal(
                                 text: '#الكل',
                                 fontSize: AppFontSize.fontSize_12,
                               ),
                             ),
                           ),
                           for (int index = 0; index < allHashtagModel!.hashtag!.length; index++)
                             Padding(
                               padding:  EdgeInsets.symmetric(horizontal: 3.w),
                               child: InkWell(
                                 onTap: () {
                                   setState(() {
                                     controllerNew.clear();
                                     // قم بتحديد العنصر الحالي فقط عن طريق جعل جميع العناصر الأخرى غير محددة
                                     for (int i = 0; i < isSelectAvailableList.length; i++) {
                                       isSelectAvailableList[i] = i == index;

                                     }
                                     idHashtagNew = allHashtagModel!.hashtag[index].id;
                                     hashtagName = allHashtagModel!.hashtag[index].hashtag;
                                     BlocProvider.of<CommunityCubit>(context).searchPost(page: 1,hashtagId:allHashtagModel!.hashtag[index].id ,
                                         content: controllerNew.text);

                                   });
                                 },
                                 child: Chip(
                                   backgroundColor: isSelectAvailableList[index]
                                       ? appTheme.deepPurpleA100
                                       : Colors.grey,
                                   label: textNormal(
                                     text: allHashtagModel!.hashtag[index].hashtag!,
                                     fontSize: AppFontSize.fontSize_12,
                                   ),
                                 ),
                               ),
                             ),


                         ],
                       ),
                    ),
                  ),

                    Expanded(
                      child: SmartRefreshWidget(
                        onRefresh: () async {
                          page = 1;

                          if(idHashtagNew =='-1'){     BlocProvider.of<CommunityCubit>(context).searchPost(page: page,
                              content: controllerNew.text,
                          );}else {
                            BlocProvider.of<CommunityCubit>(context).searchPost(page: page,hashtagId:idHashtagNew,
                                content: controllerNew.text,
                         );
                          }
                          _refreshController.refreshCompleted();
                        },

                        controller: _refreshController,
                        onLoading: () async {
                          if(communityPostModel!.isNotEmpty){
                            page++;
                            if(idHashtagNew =='-1'){     BlocProvider.of<CommunityCubit>(context).searchPost(page: page,
                                content: controllerNew.text,
                                isNeedShimmer: false);}else {
                              BlocProvider.of<CommunityCubit>(context).searchPost(page: page,hashtagId:idHashtagNew,
                                  content: controllerNew.text,
                                  isNeedShimmer: false);
                            }
                          }


                          setState(() {});
                          _refreshController.loadComplete();
                        },
                        child: SingleChildScrollView(
                          child: isLoading
                              ? CommunityShimmer()
                              : isError
                                  ? Column(
                                      children: [
                                        textNormal(
                                            text: 'حدث خطأ ما',  fontSize: AppFontSize.fontSize_20,),
                                        CommunityShimmer()
                                      ],
                                    )
                                  : Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          sizeHeightNormal(height: 4.h),
                                        if( communityPostModel!.length == 0) ...{
                                          sizeHeightNormal(height: 15.h),
                                          Container(child: Center(
                                            child: textNormal(text: 'لايوجد نتائج للبجث ..'),
                                          ),)
                                        },
                                          ListCommunity(
                                            communityPostModel: communityPostModel!,
                                            page: page,
                                            isFromUserPage: false,
                                            // hashTagModel: allHashtagModel,
                                            hashtag: hashtagName,
                                            isFromHashtagScreen: true,
                                          ),
                                          if (state is LoadingGetLoaderPostState) ...[
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
                      ),
                    ),
                  ],
                ),
                // bottomSheet: bottomNavigationBarWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}
