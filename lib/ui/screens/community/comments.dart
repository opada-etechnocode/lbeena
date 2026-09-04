import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/apis_chat_firebase.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/widgets/comments_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/community/comments__id_posts_model.dart';
import '../../theme/theme_text_form_field.dart';
import '../auth/login/login_screen.dart';
import '../company/company_details_page.dart';
import 'cubit/community_cubit.dart';
import '../details_product/details_product.dart';
import '../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';
import 'edit_post.dart';

class CommentsPostScreen extends StatefulWidget {
  CommentsPostScreen({
    super.key,
    required this.idPost,
    required this.isHaveGroup,
    required this.idUserCreatePost,
    this.commentsList = const [], this. isFromPostPage =false,
  });

  int idPost;
  int idUserCreatePost;
  int isHaveGroup;
  bool isFromPostPage =false;
  List<CommentsListModel> commentsList = [];

  @override
  State<CommentsPostScreen> createState() => _CommentsPostScreenState();
}

class _CommentsPostScreenState extends State<CommentsPostScreen> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Map<int, bool> editComment = {};

  final _formKey = GlobalKey<FormState>();
  String text =
      'وماذا لو استطعتَ أن تفكك ألغازي كلها وانتهت نشوتك، ومضيتَ كما مضوا كلهم أمام مرآي دون أنطق، منذ لاحت النية؟. نعم يُحاسِب على النية وحديث النفس؛ بل ويريها من يشاء. ماذا لو انتهى كلّ عتابي وشققته حتى نهايته  ظلمته ولمعت عيني من وقع مصادفاته. وماذا لو لم أكتب لك؛ هل تعتقد أنني من أولئك الذين لا يسمعون صدى حمامات قلبه؟';
  TextEditingController controller = TextEditingController();
  TextEditingController controllerEdit = TextEditingController();
  bool isLoadingComments = false;
  bool isComment = false;
  bool isPostLiked = false;
  bool isEditComment = true;
  List<CommentsListModel> commentsList = [];
  Map<int, bool> postAllLikes = {};
  Map<int, int> counterPostAllLikes = {};

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return BlocProvider(
        create: (context) {
          if(widget.commentsList.isNotEmpty){
            commentsList = widget.commentsList;
            return CommunityCubit();
          }else {
            if(widget.isFromPostPage ==true){
              return CommunityCubit();}else{

              return CommunityCubit()
                ..getCommentsByIdPosts(
                    idPost: widget.idPost.toString(), page: 1, isLoadMore: false);

            }
          }
           },
        child: BlocConsumer<CommunityCubit, CommunityState>(
          listener: (context, state) {
            if (state is ErrorGetCommentsByIdPostsState) {
              isLoadingComments = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.toString()),
                ),
              );
            }
            if (state is SuccessGetCommentsByIdPostsState) {
              if(widget.isFromPostPage !=true){
                commentsList.addAll(state.data.data!.data);}

              // print('commentsList: ${commentsList.length}');
              isLoadingComments = false;
              for (int index = 0; index < commentsList.length; index++) {
                controllerEdit.text = commentsList[index].content!;
              }
            }
            if(state is ErrorEditCommentState){
              SnackBarHelper.mySnackBarError( state.message.toString(),context);
            }
            if(state is ErrorDeleteCommentState){
              SnackBarHelper.mySnackBarError( state.message.toString(),context);
            }

            if(state is SuccessEditCommentState){
              commentsList[state.indexComment].content = state.data.comment!.content;
            }

            if (state is LoadingGetCommentsByIdPostsState) {
              commentsList=[];
              isLoadingComments = true;
            }
            if (state is SuccessDeleteCommentState) {
            commentsList.removeAt(state.indexComment);
              // isLoadingComments = true;
            }

            if (state is SuccessAddCommentState) {
              controller.clear();
              controller.text = '';

              commentsList.insert(0, state.data.comment!);
              print(commentsList);
              print('commentsList: ${commentsList.length}');

            }
          },
          builder: (context, state) {
            return widget.isFromPostPage?Column(
              children: [
                if (commentsList.isEmpty) Container(
                  height: 200.h,
                  child: Center(
                    child: textNormal(text:'لا يوجد تعليقات حتى الآن'),
                  ),
                ) else ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  // إضافة ScrollController هنا
                  itemCount: commentsList.length,
                  itemBuilder: (context, index) {
                    // controllerEdit = TextEditingController(text: commentsList[index].content);
                    isPostLiked =
                        postAllLikes[index] ?? false;
                    counterPostAllLikes[index] =
                        counterPostAllLikes[index] ?? 0;
                    bool isComment =
                        editComment[index] ?? false;
                    return Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                navigatorToPush(
                                    context:
                                    context,
                                    pageName:
                                    CompanyDetailsPage(
                                      idCompany: int.parse(commentsList[index]
                                          .userId
                                          .toString()),
                                    ));
                              },
                              child: CustomImageView(
                                imagePath: commentsList[index]
                                    .profilePic.toString().contains('http')?
                                commentsList[index]
                                    .profilePic.toString():AppEndpoints.baseUrlWithoutApi+commentsList[index].profilePic.toString(),
                                height: 30.fSize,
                                width: 30.fSize,
                                fit: BoxFit.cover,
                                radius:
                                BorderRadius.circular(
                                    900.r),
                                placeHolder: ImageConstant
                                    .imgCompanyD,
                              ),
                            ),
                            sizeWidthNormal(),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      commentsList[
                                      index]
                                          .name ??
                                          '',
                                      style: Theme.of(
                                          context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                        fontSize: AppFontSize.fontSize_12,
                                      ),
                                    ),
                                    sizeWidthNormal(),
                                    commentsList[index]
                                        .createdAt ==
                                        null
                                        ? Container()
                                        : Text(
                                      getComparedTime(
                                          commentsList[index]
                                              .createdAt!),
                                      style: Theme.of(
                                          context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                        color:
                                        Colors.grey,
                                        fontSize: AppFontSize.fontSize_8,
                                      ),
                                    ),
                                  ],
                                ),
                                if (editComment[
                                index] ??
                                    false)
                                  Container(
                                    width: 280.w,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          width: 180.w,
                                          // height: 30.h,
                                          child:
                                          ThemeTextFormField(
                                            child:  TextFormField(
                                              // initialValue:
                                              //   commentsList[
                                              //             index]
                                              //         .content,
                                              controller:
                                              controllerEdit,

                                              maxLines:
                                              null,
                                              maxLength:
                                              600,
                                              style:
                                              TextStyle(
                                                fontSize: AppFontSize.fontSize_10,
                                              ),
                                              onChanged:
                                                  (value) {
                                                setState(
                                                        () {
                                                      // commentsList[index].content = value;
                                                    });
                                              },
                                              decoration:
                                              InputDecoration(
                                                border: InputBorder
                                                    .none,
                                                counterStyle:
                                                TextStyle(
                                                  color: appTheme
                                                      .black900,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ),
                                                hintText:
                                                commentsList[index]
                                                    .content,
                                                hintStyle:
                                                TextStyle(
                                                  fontSize: AppFontSize.fontSize_10,
                                                ),
                                                contentPadding:
                                                EdgeInsets
                                                    .symmetric(
                                                  vertical:
                                                  2.h,
                                                  horizontal:
                                                  20.w,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomElevatedButton(
                                            width: 40.w,
                                            height:
                                            30.h,
                                            buttonTextStyle:
                                            TextStyle(
                                              fontSize: AppFontSize.fontSize_10,
                                              color: appTheme
                                                  .black900,
                                            ),
                                            text:
                                            'إلغاء',
                                            onPressed:
                                                () {
                                              setState(
                                                      () {
                                                    editComment[index] =
                                                    false;
                                                    isEditComment =
                                                    true;
                                                    controllerEdit
                                                        .clear();
                                                    // controllerEdit.text = commentsList[index].content!;
                                                  });
                                            }),
                                        sizeWidthNormal(
                                            width: 5.w),
                                        CustomElevatedButton(
                                            width: 40.w,
                                            height:
                                            30.h,
                                            buttonTextStyle:
                                            TextStyle(
                                              fontSize: AppFontSize.fontSize_10,
                                              color: appTheme
                                                  .black900,
                                            ),
                                            text:
                                            'تعديل',
                                            onPressed:
                                                () {
                                              BlocProvider.of<CommunityCubit>(context).editComments(
                                                  idComments: int.parse(commentsList[index]
                                                      .id
                                                      .toString()),
                                                  content: controllerEdit
                                                      .text,
                                                  indexComment: index,
                                                  idPost: widget
                                                      .idPost
                                                      .toString());
                                              setState(
                                                      () {
                                                    editComment[index] =
                                                    false;
                                                    isEditComment =
                                                    true;
                                                    controllerEdit
                                                        .clear();
                                                  });
                                            }),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    width: 250.w,
                                    child: textNormal(
                                      text: commentsList[
                                      index]
                                          .content ??
                                          '',

                                      fontSize: AppFontSize.fontSize_12,
                                      overflow:
                                      TextOverflow
                                          .visible,
                                      fontWeight:
                                      FontWeight
                                          .normal,
                                    ),
                                  )
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<
                                        CommunityCubit>(
                                        context)
                                        .likeComments(
                                        idComment: commentsList[
                                        index]
                                            .id
                                            .toString(),
                                        idPost: widget
                                            .idPost
                                            .toString(),
                                        page: page);

                                    setState(() {
                                      if (commentsList[index]
                                          .isLikeComment ==
                                          true) {
                                        commentsList[index]
                                            .isLikeComment = false;

                                        postAllLikes[
                                        index] =
                                        false;
                                      } else {
                                        commentsList[index]
                                            .isLikeComment = true;
                                        postAllLikes[
                                        index] =
                                        true;
                                      }
                                      _toggleLike(
                                          index,
                                          commentsList[index]
                                              .likesCount!);
                                    });
                                  },
                                  child: Icon(
                                    commentsList[index]
                                        .isLikeComment! ==
                                        true
                                        ? Icons.favorite
                                        : postAllLikes[index] ?? false
                                        ? Icons.favorite
                                        :Icons
                                        .favorite_border,

                                    color:     commentsList[index]
                                        .isLikeComment! ==
                                        true
                                        ? Colors.red
                                        : postAllLikes[index] ?? false
                                        ? Colors.red
                                        :Colors.grey,

                                    size: 15.sp,
                                  ),
                                ),
                                sizeHeightNormal(
                                    height: 4.h),
                                textNormal(
                                  text: '${sum(commentsList[
                                  index]
                                      .likesCount!,counterPostAllLikes[index]!)}'
                                  ,
                                  fontSize: AppFontSize.fontSize_8,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            if (commentsList[index]
                                .userId ==
                                DIManager.findDep<
                                    SharedPrefs>()
                                    .getUserID() &&
                                isEditComment) ...{
                              PopupMenuButton(
                                color: appTheme
                                    .lightBlueBottomNavigatorBar,
                                child: CustomImageView(
                                  imagePath:
                                  ImageConstant
                                      .iconList,
                                  height: 15.h,
                                  width: 15.h,
                                  color: appTheme
                                      .deepPurpleA10002,
                                ),
                                // Use a specific widget
                                itemBuilder:
                                    (BuildContext
                                context) =>
                                [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: textNormal(
                                        text: 'حذف',
                                      fontSize: AppFontSize.fontSize_10,),
                                  ),
                                  PopupMenuItem(
                                    value: 'Edit',
                                    child: textNormal(
                                        text: 'تعديل',
                                      fontSize: AppFontSize.fontSize_10,),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value ==
                                      "delete") {
                                    BlocProvider.of<
                                        CommunityCubit>(
                                        context)
                                        .deleteComments(
                                        idComments: int.parse(
                                            commentsList[index]
                                                .id
                                                .toString()),
                                        indexComment: index,
                                        idPost: widget
                                            .idPost
                                            .toString());
                                  }

                                  if (value == "Edit") {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext bc) {
                                        controllerEdit.text = commentsList[index].content!;
                                        return DraggableScrollableSheet(
                                          expand: false,  // يسمح بتصغير وتكبير المودال

                                          builder: (context2, scrollController) {
                                            return Container(
                                            // color: appTheme.lightBlue200,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).viewInsets.bottom,  // لضبط المساحة مع لوحة المفاتيح
                                                ),
                                                child: SingleChildScrollView(
                                                  controller: scrollController,  // لجعل المحتوى قابل للتمرير
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.sp),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        sizeHeightNormal(height: 20.h),
                                                        Container(
                                                          width: double.infinity,  // لضبط العرض بالكامل
                                                          child:  ThemeTextFormField(
                                                            child: TextFormField(
                                                              controller: controllerEdit,
                                                              maxLines: null,
                                                              maxLength: 600,
                                                              style: TextStyle(
                                                                fontSize: AppFontSize.fontSize_10,
                                                              ),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  // commentsList[index].content = value;
                                                                });
                                                              },
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                counterStyle: TextStyle(
                                                                  color: appTheme.black900,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                hintText: commentsList[index].content,
                                                                hintStyle: TextStyle(
                                                                  fontSize: AppFontSize.fontSize_10,
                                                                ),
                                                                contentPadding: EdgeInsets.symmetric(
                                                                  vertical: 2.h,
                                                                  horizontal: 20.w,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            CustomElevatedButton(
                                                              text: 'تعديل',
                                                              width: 100.w,
                                                              onPressed: () {
                                                                BlocProvider.of<CommunityCubit>(context).editComments(
                                                                  idComments: int.parse(commentsList[index].id.toString()),
                                                                  content: controllerEdit.text,
                                                                  idPost: widget.idPost.toString(),
                                                                  indexComment: index,
                                                                );
                                                                setState(() {
                                                                  editComment[index] = false;
                                                                  isEditComment = true;
                                                                  controllerEdit.clear();
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                            sizeWidthNormal(width: 10.w),
                                                            CustomElevatedButton(
                                                              text: 'إلغاء',
                                                              width: 100.w,
                                                              onPressed: () {
                                                                setState(() {
                                                                  editComment[index] = false;
                                                                  isEditComment = true;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );

                                  }
                                  // Handle menu item selection here
                                },
                              )
                            } else ...{
                              if(widget.isHaveGroup ==1)...{
                                if(widget.idUserCreatePost.toString() ==   DIManager.findDep<
                                    SharedPrefs>()
                                    .getUserID())...{
                                  PopupMenuButton(
                                    color: appTheme
                                        .lightBlueBottomNavigatorBar,
                                    child: CustomImageView(
                                      imagePath:
                                      ImageConstant
                                          .iconList,
                                      height: 15.h,
                                      width: 15.h,
                                      color: appTheme
                                          .deepPurpleA10002,
                                    ),
                                    // Use a specific widget
                                    itemBuilder:
                                        (BuildContext
                                    context) =>
                                    [
                                      PopupMenuItem(
                                        value: 'add',
                                        child: textNormal(
                                          text: 'أضف إلى المجموعة',
                                          fontSize: AppFontSize.fontSize_10,),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: textNormal(
                                          text: 'حذف',
                                          fontSize: AppFontSize.fontSize_10,),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value ==
                                          "delete") {
                                        BlocProvider.of<
                                            CommunityCubit>(
                                            context)
                                            .deleteComments(
                                            idComments: int.parse(
                                                commentsList[index]
                                                    .id
                                                    .toString()),
                                            indexComment: index,
                                            idPost: widget
                                                .idPost
                                                .toString());
                                      }

                                      if (value ==
                                          "add") {
                                        APIs.addMember(widget.idPost.toString(), commentsList[index]
                                            .userId!,{
                                          "userId": commentsList[index]
                                              .userId??"",
                                          "userName": commentsList[index]
                                              .name ??'',
                                          "profileImage":commentsList[index]
                                              .profilePic ??'',
                                          "joinDate":DateTime.now(),
                                        },context).then((value) {
CommunityCubit.get(context).sendNotification(userId: commentsList[index]
    .userId!);

                                        });

                                      }
                                    },
                                  )
                                }else...{
                                  Container(   height: 15.h,
                                    width: 15.h,),
                                }
                              }else ... {
                                if(widget.idUserCreatePost.toString() ==   DIManager.findDep<
                                    SharedPrefs>()
                                    .getUserID())...{
                                  PopupMenuButton(
                                    color: appTheme
                                        .lightBlueBottomNavigatorBar,
                                    child: CustomImageView(
                                      imagePath:
                                      ImageConstant
                                          .iconList,
                                      height: 15.h,
                                      width: 15.h,
                                      color: appTheme
                                          .deepPurpleA10002,
                                    ),
                                    // Use a specific widget
                                    itemBuilder:
                                        (BuildContext
                                    context) =>
                                    [
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: textNormal(
                                          text: 'حذف',
                                          fontSize: AppFontSize.fontSize_10,),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value ==
                                          "delete") {
                                        BlocProvider.of<
                                            CommunityCubit>(
                                            context)
                                            .deleteComments(
                                            idComments: int.parse(
                                                commentsList[index]
                                                    .id
                                                    .toString()),
                                            indexComment: index,
                                            idPost: widget
                                                .idPost
                                                .toString());
                                      }


                                      // Handle menu item selection here
                                    },
                                  )
                                }else...{
                                  Container(   height: 15.h,
                                    width: 15.h,),
                                }
                              }

                            },
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ): GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: appTheme.scaffoldBackgroundColor100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10.h),
                        if(!widget.isFromPostPage)...{
                          Column(
                            children: [
                              Container(
                                height: 5.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: appTheme.black900.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              sizeHeightNormal(),
                              Text(
                                'التعليقات',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        },
                        state is LoadingGetCommentsByIdPostsState
                            ? CommentsShimmer()
                            : commentsList.isEmpty
                                ? Container(
                                    height: 200.h,
                                    child: Center(
                                      child: textNormal(text:'لا يوجد تعليقات حتى الآن'),
                                    ),
                                  )
                                : Container(
                                    height: 300.h,
                                    child: SmartRefresher(
                                      onRefresh: () async {
                                        commentsList = [];
                                        page = 1;
                                        await BlocProvider.of<CommunityCubit>(
                                                context)
                                            .getCommentsByIdPosts(
                                                idPost:
                                                    widget.idPost.toString(),
                                                page: page,
                                                isLoadMore: false);
                                        _refreshController.refreshCompleted();
                                      },
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      scrollDirection: Axis.vertical,
                                      controller: _refreshController,
                                      physics: BouncingScrollPhysics(),
                                      header: ClassicHeader(
                                        refreshingIcon: Container(
                                            width: 20.h,
                                            height: 20.h,
                                            child: CircularProgressIndicator(color: appTheme.greenColorApp,
                                              strokeWidth: 1.5,
                                            )),
                                        idleIcon: Center(
                                          child: Icon(
                                            Icons.arrow_downward,
                                            color: appTheme.greenColorApp,
                                          ),
                                        ),
                                        completeIcon: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: appTheme.greenColorApp,
                                            size: 30.h,
                                          ),
                                        ),
                                        releaseIcon: Center(
                                          child: Icon(
                                            Icons.change_circle_sharp,
                                            color: appTheme.greenColorApp,
                                            size: 30.h,
                                          ),
                                        ),
                                        completeText: "",
                                        idleText: '',
                                        refreshingText: "",
                                        canTwoLevelText: '',
                                        releaseText: '',
                                        textStyle: TextStyle(
                                            color: appTheme.greenColorApp,),
                                      ),
                                      footer: ClassicFooter(
                                        height: 80.h,
                                        noMoreIcon: Container(
                                            width: 20.h,
                                            height: 20.h,
                                            child: CircularProgressIndicator(color: appTheme.greenColorApp,
                                              strokeWidth: 1.5,
                                            )),
                                        idleIcon: const Center(),
                                        loadingIcon: Container(),
                                        canLoadingIcon: Center(
                                          child: Icon(
                                            Icons.change_circle_sharp,
                                            color: appTheme.greenColorApp,
                                            size: 30.h,
                                          ),
                                        ),
                                        idleText: '',
                                        canLoadingText: 'اسحب لمشاهدة المزيد ..',
                                        loadingText: 'جاري التحميل ..',
                                        noDataText: 'انتهى ',
                                        textStyle: TextStyle(
                                            color: appTheme.greenColorApp,),
                                      ),
                                      onLoading: () async {
                                        page++;
                                        await BlocProvider.of<CommunityCubit>(
                                                context)
                                            .getCommentsByIdPosts(
                                                idPost:
                                                    widget.idPost.toString(),
                                                page: page,
                                                isLoadMore: true);
                                        setState(() {});
                                        _refreshController.loadComplete();
                                      },
                                      child: SingleChildScrollView(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          controller: _scrollController,
                                          // إضافة ScrollController هنا
                                          itemCount: commentsList.length,
                                          itemBuilder: (context, index) {
                                            // controllerEdit = TextEditingController(text: commentsList[index].content);
                                            isPostLiked =
                                                postAllLikes[index] ?? false;
                                            counterPostAllLikes[index] =
                                                counterPostAllLikes[index] ?? 0;
                                            bool isComment =
                                                editComment[index] ?? false;

                                            return Padding(
                                              padding: EdgeInsets.all(8.sp),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        navigatorToPush(
                                                            context:
                                                            context,
                                                            pageName:
                                                            CompanyDetailsPage(
                                                              idCompany: int.parse(commentsList[index]
                                                                  .userId
                                                                  .toString()),
                                                            ));
                                                      },
                                                      child: CustomImageView(
                                                        imagePath: commentsList[index]
                                                            .profilePic.toString().contains('http')?
                                                            commentsList[index]
                                                                    .profilePic.toString():AppEndpoints.baseUrlWithoutApi+commentsList[index].profilePic.toString(),
                                                        height: 30.fSize,
                                                        width: 30.fSize,
                                                        fit: BoxFit.cover,
                                                        radius:
                                                            BorderRadius.circular(
                                                                900.r),
                                                        placeHolder: ImageConstant
                                                            .imgCompanyD,
                                                      ),
                                                    ),
                                                    sizeWidthNormal(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              commentsList[
                                                                          index]
                                                                      .name ??
                                                                  '',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                  fontSize: AppFontSize.fontSize_12,
                                                                  ),
                                                            ),
                                                            sizeWidthNormal(),
                                                            commentsList[index]
                                                                        .createdAt ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    getComparedTime(
                                                                        commentsList[index]
                                                                            .createdAt!),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                          color:
                                                                              Colors.grey,
                                                                      fontSize: AppFontSize.fontSize_8,
                                                                        ),
                                                                  ),
                                                          ],
                                                        ),
                                                        if (editComment[
                                                                index] ??
                                                            false)
                                                          Container(
                                                            width: 280.w,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 180.w,
                                                                  // height: 30.h,
                                                                  child:
                                                                  ThemeTextFormField(
                                                                    child: TextFormField(
                                                                                                                                            // initialValue:
                                                                                                                                            //   commentsList[
                                                                                                                                            //             index]
                                                                                                                                            //         .content,
                                                                                                                                            controller:
                                                                          controllerEdit,

                                                                                                                                            maxLines:
                                                                          null,
                                                                                                                                            maxLength:
                                                                          600,
                                                                                                                                            style:
                                                                          TextStyle(
                                                                            fontSize: AppFontSize.fontSize_10,
                                                                                                                                            ),
                                                                                                                                            onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          // commentsList[index].content = value;
                                                                        });
                                                                                                                                            },
                                                                                                                                            decoration:
                                                                          InputDecoration(
                                                                        border: InputBorder
                                                                            .none,
                                                                        counterStyle:
                                                                            TextStyle(
                                                                          color: appTheme
                                                                              .black900,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                        hintText:
                                                                            commentsList[index]
                                                                                .content,
                                                                        hintStyle:
                                                                            TextStyle(
                                                                              fontSize: AppFontSize.fontSize_10,
                                                                        ),
                                                                        contentPadding:
                                                                            EdgeInsets
                                                                                .symmetric(
                                                                          vertical:
                                                                              2.h,
                                                                          horizontal:
                                                                              20.w,
                                                                        ),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                      ),
                                                                ),
                                                                CustomElevatedButton(
                                                                    width: 40.w,
                                                                    height:
                                                                        30.h,
                                                                    buttonTextStyle:
                                                                        TextStyle(
                                                                          fontSize: AppFontSize.fontSize_10,
                                                                      color: appTheme
                                                                          .black900,
                                                                    ),
                                                                    text:
                                                                        'إلغاء',
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        editComment[index] =
                                                                            false;
                                                                        isEditComment =
                                                                            true;
                                                                        controllerEdit
                                                                            .clear();
                                                                        // controllerEdit.text = commentsList[index].content!;
                                                                      });
                                                                    }),
                                                                sizeWidthNormal(
                                                                    width: 5.w),
                                                                CustomElevatedButton(
                                                                    width: 40.w,
                                                                    height:
                                                                        30.h,
                                                                    buttonTextStyle:
                                                                        TextStyle(
                                                                          fontSize: AppFontSize.fontSize_10,
                                                                      color: appTheme
                                                                          .black900,
                                                                    ),
                                                                    text:
                                                                        'تعديل',
                                                                    onPressed:
                                                                        () {
                                                                      BlocProvider.of<CommunityCubit>(context).editComments(
                                                                          idComments: int.parse(commentsList[index]
                                                                              .id
                                                                              .toString()),
                                                                          content: controllerEdit
                                                                              .text,
                                                                          indexComment: index,
                                                                          idPost: widget
                                                                              .idPost
                                                                              .toString());
                                                                      setState(
                                                                          () {
                                                                        editComment[index] =
                                                                            false;
                                                                        isEditComment =
                                                                            true;
                                                                        controllerEdit
                                                                            .clear();
                                                                      });
                                                                    }),
                                                              ],
                                                            ),
                                                          )
                                                        else
                                                          Container(
                                                            width: 250.w,
                                                            child: textNormal(
                                                              text: commentsList[
                                                                          index]
                                                                      .content ??
                                                                  '',
                                                              fontSize: AppFontSize.fontSize_12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if(DIManager.findDep<SharedPrefs>().getToken() == null)
                                                            {
                                                              navigatorToPush(
                                                                  context: context,
                                                                  pageName: LoginScreen(
                                                                    isNeedIconBac: true,
                                                                  ));
                                                            }else {
                                                              BlocProvider.of<
                                                                  CommunityCubit>(
                                                                  context)
                                                                  .likeComments(
                                                                  idComment: commentsList[
                                                                  index]
                                                                      .id
                                                                      .toString(),
                                                                  idPost: widget
                                                                      .idPost
                                                                      .toString(),
                                                                  page: page);

                                                              setState(() {
                                                                if (commentsList[index]
                                                                    .isLikeComment ==
                                                                    true) {
                                                                  commentsList[index]
                                                                      .isLikeComment = false;

                                                                  postAllLikes[
                                                                  index] =
                                                                  false;
                                                                } else {
                                                                  commentsList[index]
                                                                      .isLikeComment = true;
                                                                  postAllLikes[
                                                                  index] =
                                                                  true;
                                                                }
                                                                _toggleLike(
                                                                    index,
                                                                    commentsList[index]
                                                                        .likesCount!);
                                                              });
                                                            }

                                                          },
                                                          child: Icon(
                                                            commentsList[index]
                                                                .isLikeComment! ==
                                                                true
                                                                ? Icons.favorite
                                                                : postAllLikes[index] ?? false
                                                                ? Icons.favorite
                                                                :Icons
                                                                .favorite_border,

                                                            color:     commentsList[index]
                                                                .isLikeComment! ==
                                                                true
                                                                ? Colors.red
                                                                : postAllLikes[index] ?? false
                                                                ? Colors.red
                                                                :Colors.grey,

                                                            size: 15.sp,
                                                          ),
                                                        ),
                                                        sizeHeightNormal(
                                                            height: 4.h),
                                                        textNormal(
                                                          text: '${sum(commentsList[
                                                          index]
                                                              .likesCount!,counterPostAllLikes[index]!)}'
                                                              ,
                                                          fontSize: AppFontSize.fontSize_8,
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),

                                                    if (commentsList[index]
                                                        .userId ==
                                                        DIManager.findDep<
                                                            SharedPrefs>()
                                                            .getUserID() &&
                                                        isEditComment) ...{
                                                      PopupMenuButton(
                                                        color: appTheme
                                                            .lightBlueBottomNavigatorBar,
                                                        child: CustomImageView(
                                                          imagePath:
                                                          ImageConstant
                                                              .iconList,
                                                          height: 15.h,
                                                          width: 15.h,
                                                          color: appTheme
                                                              .deepPurpleA10002,
                                                        ),
                                                        // Use a specific widget
                                                        itemBuilder:
                                                            (BuildContext
                                                        context) =>
                                                        [
                                                          PopupMenuItem(
                                                            value: 'delete',
                                                            child: textNormal(
                                                              text: 'حذف',
                                                              fontSize: AppFontSize.fontSize_10,),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 'Edit',
                                                            child: textNormal(
                                                              text: 'تعديل',
                                                              fontSize: AppFontSize.fontSize_10,),
                                                          ),
                                                        ],
                                                        onSelected: (value) {
                                                          if (value ==
                                                              "delete") {
                                                            BlocProvider.of<
                                                                CommunityCubit>(
                                                                context)
                                                                .deleteComments(
                                                                idComments: int.parse(
                                                                    commentsList[index]
                                                                        .id
                                                                        .toString()),
                                                                indexComment: index,
                                                                idPost: widget
                                                                    .idPost
                                                                    .toString());
                                                          }

                                                          if (value == "Edit") {
                                                            //
                                                            // showModalBottomSheet(
                                                            //     context:
                                                            //     context,
                                                            //     isScrollControlled:
                                                            //     true,
                                                            //     builder:
                                                            //         (BuildContext
                                                            //     bc) {
                                                            //       controllerEdit
                                                            //           .text = commentsList[
                                                            //       index]
                                                            //           .content!;
                                                            //       return Container(
                                                            //         height:
                                                            //         200.h,
                                                            //         width: MediaQuery.of(
                                                            //             context)
                                                            //             .size
                                                            //             .width,
                                                            //         color: appTheme
                                                            //             .scaffoldBackgroundColor100,
                                                            //         child:
                                                            //         Padding(
                                                            //           padding: EdgeInsets
                                                            //               .all(8
                                                            //               .sp),
                                                            //           child:
                                                            //           Column(
                                                            //             crossAxisAlignment:
                                                            //             CrossAxisAlignment.start,
                                                            //             mainAxisAlignment:
                                                            //             MainAxisAlignment.start,
                                                            //             children: [
                                                            //               sizeHeightNormal(
                                                            //                   height: 20.h),
                                                            //               Container(
                                                            //                 width:
                                                            //                 400.w,
                                                            //                 height:
                                                            //                 80.h,
                                                            //                 child:
                                                            //                 TextFormField(
                                                            //                   // initialValue:
                                                            //                   //   commentsList[
                                                            //                   //             index]
                                                            //                   //         .content,
                                                            //                   controller: controllerEdit,
                                                            //
                                                            //                   maxLines: null,
                                                            //                   maxLength: 600,
                                                            //                   style: TextStyle(
                                                            //                     fontSize: AppFontSize.fontSize_10,
                                                            //                   ),
                                                            //                   onChanged: (value) {
                                                            //                     setState(() {
                                                            //                       // commentsList[index].content = value;
                                                            //                     });
                                                            //                   },
                                                            //                   decoration: InputDecoration(
                                                            //                     border: InputBorder.none,
                                                            //                     counterStyle: TextStyle(
                                                            //                       color: appTheme.black900,
                                                            //                       fontWeight: FontWeight.w500,
                                                            //                     ),
                                                            //                     hintText: commentsList[index].content,
                                                            //                     hintStyle: TextStyle(
                                                            //                       fontSize: AppFontSize.fontSize_10,
                                                            //                     ),
                                                            //                     contentPadding: EdgeInsets.symmetric(
                                                            //                       vertical: 2.h,
                                                            //                       horizontal: 20.w,
                                                            //                     ),
                                                            //                   ),
                                                            //                 ),
                                                            //               ),
                                                            //               Row(
                                                            //                 children: [
                                                            //                   CustomElevatedButton(
                                                            //                     text: 'تعديل',
                                                            //                     width: 100.w,
                                                            //                     onPressed: () {
                                                            //                       BlocProvider.of<CommunityCubit>(context).editComments(idComments: int.parse(commentsList[index].id.toString()), content: controllerEdit.text, idPost: widget.idPost.toString(), indexComment: index);
                                                            //                       setState(() {
                                                            //                         editComment[index] = false;
                                                            //                         isEditComment = true;
                                                            //                         controllerEdit.clear();
                                                            //                       });
                                                            //                       Navigator.pop(context);
                                                            //                     },
                                                            //                   ),
                                                            //                   sizeWidthNormal(width: 10.w),
                                                            //                   CustomElevatedButton(
                                                            //                     text: 'إلغاء',
                                                            //                     width: 100.w,
                                                            //                     onPressed: () {
                                                            //                       setState(() {
                                                            //                         editComment[index] = false;
                                                            //                         isEditComment = true;
                                                            //                         // controllerEdit.clear();
                                                            //                       });
                                                            //                       Navigator.pop(context);
                                                            //                     },
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     });

                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled: true,
                                                              builder: (BuildContext bc) {
                                                                controllerEdit.text = commentsList[index].content!;
                                                                return DraggableScrollableSheet(
                                                                  expand: false,  // يسمح بتصغير وتكبير المودال

                                                                  builder: (context2, scrollController) {
                                                                    return Container(
                                                                      // color: appTheme.lightBlue200,
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(
                                                                          bottom: MediaQuery.of(context).viewInsets.bottom,  // لضبط المساحة مع لوحة المفاتيح
                                                                        ),
                                                                        child: SingleChildScrollView(
                                                                          controller: scrollController,  // لجعل المحتوى قابل للتمرير
                                                                          child: Padding(
                                                                            padding: EdgeInsets.all(8.sp),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                sizeHeightNormal(height: 20.h),
                                                                                Container(
                                                                                  width: double.infinity,  // لضبط العرض بالكامل
                                                                                  child: ThemeTextFormField(
                                                                                    child: TextFormField(
                                                                                      controller: controllerEdit,
                                                                                      maxLines: null,
                                                                                      maxLength: 600,
                                                                                      style: TextStyle(
                                                                                        fontSize: AppFontSize.fontSize_10,
                                                                                      ),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          // commentsList[index].content = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        border: InputBorder.none,
                                                                                        counterStyle: TextStyle(
                                                                                          color: appTheme.black900,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                        hintText: commentsList[index].content,
                                                                                        hintStyle: TextStyle(
                                                                                          fontSize: AppFontSize.fontSize_10,
                                                                                        ),
                                                                                        contentPadding: EdgeInsets.symmetric(
                                                                                          vertical: 2.h,
                                                                                          horizontal: 20.w,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    CustomElevatedButton(
                                                                                      text: 'تعديل',
                                                                                      width: 100.w,
                                                                                      onPressed: () {
                                                                                        BlocProvider.of<CommunityCubit>(context).editComments(
                                                                                          idComments: int.parse(commentsList[index].id.toString()),
                                                                                          content: controllerEdit.text,
                                                                                          idPost: widget.idPost.toString(),
                                                                                          indexComment: index,
                                                                                        );
                                                                                        setState(() {
                                                                                          editComment[index] = false;
                                                                                          isEditComment = true;
                                                                                          controllerEdit.clear();
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    sizeWidthNormal(width: 10.w),
                                                                                    CustomElevatedButton(
                                                                                      text: 'إلغاء',
                                                                                      width: 100.w,
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          editComment[index] = false;
                                                                                          isEditComment = true;
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            );

                                                          }
                                                          // Handle menu item selection here
                                                        },
                                                      )
                                                    } else ...{
                                                      if(widget.isHaveGroup ==1)...{
                                                        if(widget.idUserCreatePost.toString() ==   DIManager.findDep<
                                                            SharedPrefs>()
                                                            .getUserID())...{
                                                          PopupMenuButton(
                                                            color: appTheme
                                                                .lightBlueBottomNavigatorBar,
                                                            child: CustomImageView(
                                                              imagePath:
                                                              ImageConstant
                                                                  .iconList,
                                                              height: 15.h,
                                                              width: 15.h,
                                                              color: appTheme
                                                                  .deepPurpleA10002,
                                                            ),
                                                            // Use a specific widget
                                                            itemBuilder:
                                                                (BuildContext
                                                            context) =>
                                                            [
                                                              PopupMenuItem(
                                                                value: 'add',
                                                                child: textNormal(
                                                                  text: 'أضف إلى المجموعة',
                                                                  fontSize: AppFontSize.fontSize_10,),
                                                              ),
                                                              PopupMenuItem(
                                                                value: 'delete',
                                                                child: textNormal(
                                                                  text: 'حذف',
                                                                  fontSize: AppFontSize.fontSize_10,),
                                                              ),
                                                            ],
                                                            onSelected: (value) {
                                                              if (value ==
                                                                  "delete") {
                                                                BlocProvider.of<
                                                                    CommunityCubit>(
                                                                    context)
                                                                    .deleteComments(
                                                                    idComments: int.parse(
                                                                        commentsList[index]
                                                                            .id
                                                                            .toString()),
                                                                    indexComment: index,
                                                                    idPost: widget
                                                                        .idPost
                                                                        .toString());
                                                              }

                                                              if (value ==
                                                                  "add") {
                                                                APIs.addMember(widget.idPost.toString(), commentsList[index]
                                                                    .userId!,{
                                                                  "userId": commentsList[index]
                                                                      .userId??"",
                                                                  "userName": commentsList[index]
                                                                      .name ??'',
                                                                  "profileImage":commentsList[index]
                                                                      .profilePic ??'',
                                                                  "joinDate":DateTime.now(),
                                                                },context).then((value) {
                                                                  CommunityCubit.get(context).sendNotification(userId: commentsList[index]
                                                                      .userId!);

                                                                });

                                                              }
                                                            },
                                                          )
                                                        }else...{
                                                          Container(   height: 15.h,
                                                            width: 15.h,),
                                                        }
                                                      }else ... {
          if(widget.idUserCreatePost.toString() ==   DIManager.findDep<
          SharedPrefs>()
              .getUserID())...{
            PopupMenuButton(
              color: appTheme
                  .lightBlueBottomNavigatorBar,
              child: CustomImageView(
                imagePath:
                ImageConstant
                    .iconList,
                height: 15.h,
                width: 15.h,
                color: appTheme
                    .deepPurpleA10002,
              ),
              // Use a specific widget
              itemBuilder:
                  (BuildContext
              context) =>
              [
                PopupMenuItem(
                  value: 'delete',
                  child: textNormal(
                    text: 'حذف',
                    fontSize: AppFontSize.fontSize_10,),
                ),
              ],
              onSelected: (value) {
                if (value ==
                    "delete") {
                  BlocProvider.of<
                      CommunityCubit>(
                      context)
                      .deleteComments(
                      idComments: int.parse(
                          commentsList[index]
                              .id
                              .toString()),
                      indexComment: index,
                      idPost: widget
                          .idPost
                          .toString());
                }


                // Handle menu item selection here
              },
            )
          }else...{
            Container(   height: 15.h,
              width: 15.h,),
          }
                                                      }

                                                    },
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                        if (state is LoadingGetLoaderCommentsState) ...[
                          Center(
                            child: Container(
                                width: 10.h,
                                height: 10.h,
                                child: CircularProgressIndicator(
                                  color: appTheme.greenColorApp,
                                  strokeWidth: 1.2,
                                )),
                          ),
                        ],
                        // sizeHeightNormal(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h, left: 5.w, right: 5.w),
                          child:   Container(
                            width: MediaQuery.of(context).size.width ,
                            // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: AppDecoration.pointChoose.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10.r)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child:  ThemeTextFormField(
                                child: TextFormField(
                                  controller: controller,
                                  focusNode: _focusNode,
                                  maxLines: controller.text.split('\n').length > 3 || controller.text.length > 150 ? 4 : null,
                                  style: themeLite.textTheme.titleSmall!.copyWith(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'إضافة تعليق ..',
                                    hintStyle: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey                                        ),
                                    prefixIcon: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(
                                        minWidth: 24.w, // عرض صغير للأيقونة
                                        minHeight: 24.h, // ارتفاع صغير للأيقونة
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<CommunityCubit>(context).addComment(
                                          idPost: int.parse(widget.idPost.toString()),
                                          content: controller.text,
                                        );
                                        controller.clear();
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.black,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 2.h,
                                      horizontal: 5.w, // تقليل المسافة بين النص والأيقونة
                                    ),
                                    counterStyle: TextStyle(
                                      color: appTheme.black900,
                                      fontSize: 10,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
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
        ),
      );
    });
  }

  bool isClickLikePost = false;

  void _toggleLike(int index, int likesCount) {
    bool isTrueLikePost = commentsList[index]
        .isLikeComment!;

    setState(() {
      if (likesCount == 0) {
        counterPostAllLikes[index] = isTrueLikePost ? 1 : 0;
      } else {
        if (likesCount != 0 && !isTrueLikePost) {
          if (!isClickLikePost) {
            counterPostAllLikes[index] = -1;
          } else {
            counterPostAllLikes[index] = 0;
          }
          isClickLikePost = !isClickLikePost;
        } else {
          if (!isClickLikePost) {
            counterPostAllLikes[index] = 1;
          } else {
            counterPostAllLikes[index] = 0;
          }
          isClickLikePost = !isClickLikePost;
        }
      }
    });
  }

  int sum(int a, int b) {
    return a + b;
  }
}
