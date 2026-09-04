import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/following/following_general_model.dart';
import '../../../../widgets/app_shimmer/custom_shimmer.dart';
import '../../../../widgets/smart_refresh_widget.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/theme_helper.dart';
import '../../profile/cubit/cubit.dart';
import '../../profile/cubit/status.dart';
import '../company_details_page.dart';
import 'card_user_follow.dart';

class FollowingUsersPage extends StatefulWidget {
  String titleAppBar;
  bool isFollowers;
  int userId;

  FollowingUsersPage(
      {super.key,
      required this.titleAppBar,
      required this.isFollowers,
      required this.userId});

  @override
  State<FollowingUsersPage> createState() => _FollowingUsersPageState();
}

class _FollowingUsersPageState extends State<FollowingUsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget.isFollowers) {
          return ProfileCubit()
            ..followersForUser(userId: widget.userId, page: 1);
        } else {
          return ProfileCubit()
            ..followingsForUser(userId: widget.userId, page: 1);
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) => listenerBloc(context, state),
        builder: (context, state) => screenPage(context, state),
      ),
    );
  }
  List<FollowingList> dataList = [];

  /// Listener state for Bloc
  void listenerBloc(context, state) {
    if(state is SuccessFollowingUserState) {
      dataList.addAll(state.followingGeneralModel!.data);
    }
  }
  /// Screen Page
  Widget screenPage(context, state) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(
            text: widget.titleAppBar, context: context, isShowBack: true),
        body: SmartRefreshWidget(
            onRefresh: () {
              refreshData (context, state);
            },
            controller: _refreshController,
            onLoading: (){
              paginationData(context, state);
            },
            child: Column(
              children: [
                sizeHeightNormal(),

                listUsers(state),
              ],
            )),
      ),
    );
  }
  /// Refresh Data in Page
  void refreshData(context, state) async {
    page =1;
    dataList.clear();
    if (widget.isFollowers) {
      await ProfileCubit.get(context).followersForUser(userId: widget.userId, page: page);
    } else {
      await ProfileCubit.get(context).followingsForUser(userId: widget.userId, page: page);
    }
    _refreshController.refreshCompleted();
  }
  /// Loading Data in Page
  void paginationData(context, state) async {
  page++;
  if (widget.isFollowers) {
  await ProfileCubit.get(context)
      .followersForUser(userId: widget.userId, page: page,isLoading: false);
  } else {
  await ProfileCubit.get(context)
      .followingsForUser(userId: widget.userId, page: page,isLoading: false);
  }
  setState(() {});
  _refreshController.loadComplete();
}
  /// List Users
  Widget listUsers(state){
    return Expanded(
      flex: 3,
      child: (state is LoadingFollowingUserState) ? ListView.builder(
        shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context,index){
          return usersFollowingShimmer();
        }): dataList.isEmpty ? notFoundData(): ListView.builder(
          shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
          itemCount: dataList.length,
          itemBuilder: (context,index){
            return UserCardFollowing(
              dataList: dataList[index],
            );
          }),
    );
  }
  /// Not Found Data
  Widget notFoundData(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(widget.isFollowers)...{
          textNormal(text: 'لايوجد متابعين بعد ..')
        }else ...{
          textNormal(text: 'لايوجد متابعون بعد ..')
        }
      ],
    );
  }
}
