import 'package:syrians_in_uae/core/utils/size_utils.dart';
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
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/theme_helper.dart';
import 'cubit/community_cubit.dart';
import 'list_coummunity.dart';

class HashtagScreen extends StatefulWidget {
  HashtagScreen({super.key, required this.hashtagName});

  String hashtagName;

  @override
  State<HashtagScreen> createState() => _HashtagScreenState();
}

class _HashtagScreenState extends State<HashtagScreen> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController? controllerUrlAds = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> idHashtag = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final FocusNode _secondFocusNode = FocusNode();
  List<CommunityModelDatum>? communityPostModel = [];
  bool isLoading = true;
  int page = 1;
  bool isLoadingHashtag = true;
  bool isError = false;
  List<bool> isSelectAvailableList = List.generate(100, (index) => false);
  int checkIndexColors = 0;
  String colorsChoose = '#f52323';
  AllHashtagModel? allHashtagModel;
  List<CommunityModelDatum> filteredCommunityPosts = [];
  @override
  Widget build(BuildContext context) {
    var lang = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: BlocProvider(
        create: (context) => CommunityCubit()
          ..getAllCommunityPost(page: 1,hashtag: widget.hashtagName,isSearchHashtag: true)
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
              // communityPostModel =[];
              communityPostModel = state.data.data!.data;
              communityPostModel= communityPostModel!.where((post) {
            return post.hashtags.contains(widget.hashtagName);
            }).toList();
              isLoading = false;
              isError = false;
            }
            if (state is SuccessGetLoaderPostState) {
              communityPostModel!.addAll(state.data.data!.data);
              communityPostModel= communityPostModel!.where((post) {
                return post.hashtags.contains(widget.hashtagName);
              }).toList();
            }

            if (state is LoadingGetAllCommunityPostState) {
              // SnackBarHelper.mySnackBarLoading('جاري تحميل البيانات', context);
              isLoading = true;
              isError = false;
            }

            if (state is ErrorCreatePostState) {
              SnackBarHelper.mySnackBarError(state.message, context);
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
            // BlocProvider.of<CommunityCubit>(context,listen: false).refreshAllCommunityPost();
            return HandelAndroidApp(
              child: Scaffold(
                appBar: appBarNormalWithIcon(text: 'سوشال', context: context,isShowBack: true) ,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: textNormal(
                          text: widget.hashtagName,
                          fontSize: AppFontSize.fontSize_20,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: SmartRefreshWidget(
                        onRefresh: () async {
                          page = 1;
                          await BlocProvider.of<CommunityCubit>(context)
                              .getAllCommunityPost(page: page,hashtag: widget.hashtagName,isSearchHashtag: true);
                          _refreshController.refreshCompleted();
                        },

                        controller: _refreshController,
                        onLoading: () async {
                          page++;
                          await BlocProvider.of<CommunityCubit>(context)
                              .getAllLoadingCommunityPost(page: page,hashtag: widget.hashtagName,isSearchHashtag: true);
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

                                          ListCommunity(
                                            communityPostModel: communityPostModel!,
                                            page: page,
                                            isFromUserPage: false,
                                            // hashTagModel: allHashtagModel,
                                            hashtag: widget.hashtagName,
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
