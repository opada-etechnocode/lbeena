import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/community/list_coummunity.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/widgets/comments_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/community/comments__id_posts_model.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../data/models/community/hashtag_model.dart';
// import '../../../l10n/app_localizations.dart';
import 'package:syrians_in_uae/core/link_app.dart';


import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/file_compress.dart';
import '../../../widgets/loader_for_page.dart';
import '../../app_general_bloc/handel_android_app.dart';
import 'community.dart';
import 'cubit/community_cubit.dart';
import '../details_product/details_product.dart';
import '../../theme/theme_helper.dart';


class EditPostScreen extends StatefulWidget {
  EditPostScreen({super.key, required this.postModel, this.communityPostModel, this.index,required this.isFromPostScreen});

  CommunityModelDatum postModel;
  List<CommunityModelDatum>? communityPostModel;
  int? index;
  bool isFromPostScreen;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  TextEditingController? controllerUrlAds = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String text =
      'وماذا لو استطعتَ أن تفكك ألغازي كلها وانتهت نشوتك، ومضيتَ كما مضوا كلهم أمام مرآي دون أنطق، منذ لاحت النية؟. نعم يُحاسِب على النية وحديث النفس؛ بل ويريها من يشاء. ماذا لو انتهى كلّ عتابي وشققته حتى نهايته  ظلمته ولمعت عيني من وقع مصادفاته. وماذا لو لم أكتب لك؛ هل تعتقد أنني من أولئك الذين لا يسمعون صدى حمامات قلبه؟';
  TextEditingController controller = TextEditingController();
  bool isLoadingComments = false;
  List<CommentsListModel> commentsList = [];

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the content of the post model
    if (widget.postModel.type == 'B') {
      checkBoxIndex = 2;
    }
    if (widget.postModel.type == 'A') {
      checkBoxIndex = widget.postModel.background == null ? 4 : 0;
      colorsChoose = widget.postModel.background ?? 'null';
      if (colorsChoose == widget.postModel.color[0].color1) {
        checkIndexColors = 0;
      } else if (colorsChoose == widget.postModel.color[0].color2) {
        checkIndexColors = 1;
      } else if (colorsChoose == widget.postModel.color[0].color3) {
        checkIndexColors = 2;
      }
      print('colorsChoose $colorsChoose');
      print('checkBoxIndex $checkBoxIndex');
    }
    if (widget.postModel.type == 'C') {
      checkBoxIndex = 1;
      controllerUrlAds!.text = widget.postModel.video ?? '';
    }
    idHashtag.addAll(widget.postModel.hashtagsWithId.map((e) => e.id ??'-1'));
    _focusNode.unfocus();
    controller = TextEditingController(text: widget.postModel.content);
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    controller.dispose();
    super.dispose();
  }

  bool _isSwitched = false;
  bool _isSwitchedChat = false;
  List<bool> isSelectAvailableList = List.generate(100, (index) => false);
  int isHaveComment = 1;
  int isHaveChat = 0;
  List<String> idHashtag = [];
  final FocusNode _secondFocusNode = FocusNode();
  int checkIndexColors = 5;
  String colorsChoose = 'null';

  List<Hashtag> findCommonHashtags(
      List<Hashtag> hashtags, List<Hashtag> hashtagData) {
    return hashtagData
        .where((data) => hashtags.any((tag) => tag.hashtag == data.hashtag))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        isHaveComment =
            widget.postModel.isHaveComment.toString() == '1' ? 1 : 0;
        isHaveChat = widget.postModel.is_have_chat.toString() == '1' ? 1 : 0;
        _isSwitchedChat =
            widget.postModel.is_have_chat.toString() == '1' ? true : false;
        _isSwitched =
            widget.postModel.isHaveComment.toString() == '1' ? true : false;
        return CommunityCubit();
      },
      child: BlocConsumer<CommunityCubit, CommunityState>(
        listener: (context, state) {
          if (state is SuccessEditPostState) {
            SnackBarHelper.mySnackBarSuccess(state.data.message, context);
            // BlocProvider.of<CommunityCubit>(context).getAllCommunityPost(
            //   page:
            // );
            _imagesAddProduct = null;
            // navigatorToPushReplacement(
            //     context: context, pageName: CommunityPage());
            if(widget.isFromPostScreen ==false){
              widget.communityPostModel!.removeWhere(
                      (element) => element.id.toString() == widget
                      .communityPostModel![
                  widget.index!]
                      .id
                      .toString()
              );

              notifier!.value = List.from(widget.communityPostModel!);
              Navigator.of(context).pop();
            }else {
              Navigator.of(context).pop();
            }

          }
          if (state is ErrorEditPostState) {
            SnackBarHelper.mySnackBarError(state.message, context);
          }
          if (state is SuccessDeletePostState) {
            Navigator.pop(context);
            navigatorToPushReplacement(
                context: context, pageName: CommunityPage());
            SnackBarHelper.mySnackBarSuccess(state.data.message, context);
          }
        },
        builder: (context, state) {

          return HandelAndroidApp(
            child: Scaffold(
              appBar:appBarNormalWithIcon(text: 'تعديل المنشور', context: context,isShowBack: true) ,
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: appTheme.scaffoldBackgroundColor100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sizeHeightNormal(height: 20.h),
                        Padding(
                          padding: EdgeInsets.all(8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageView(
                                imagePath: widget.postModel.profilePic
                                        .toString()
                                        .contains('http')
                                    ? widget.postModel.profilePic
                                    : AppEndpoints.baseUrlWithoutApi +
                                        widget.postModel.profilePic.toString(),
                                height: 30.fSize,
                                width: 30.fSize,
                                fit: BoxFit.fill,
                                radius: BorderRadius.circular(900.r),
                                placeHolder: ImageConstant.imgCompanyD,
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textNormal(
                                      text: widget.postModel.name ?? '',
                                      // color: AppColorsController().black900,
                                      fontSize: AppFontSize.fontSize_15,
                                      fontWeight: FontWeight.w500),
                                  // SizedBox(
                                  //   height: 5.sp,
                                  // ),s
                                  textNormal(
                                      text: widget.postModel.acceptDate == null
                                          ? ''
                                          : getComparedTime(
                                                  widget.postModel.acceptDate!) ??
                                              '',
                                      // color: AppColorsController().black900,
                                      fontSize: AppFontSize.fontSize_11,
                                      fontWeight: FontWeight.w300),
                                ],
                              ),
                              Spacer(),
                              widget.postModel.userId ==
                                      DIManager.findDep<SharedPrefs>().getUserID()
                                  ? PopupMenuButton(
                                      color: appTheme.lightBlueBottomNavigatorBar,
                                      child: CustomImageView(
                                        imagePath: ImageConstant.iconList,
                                        height: 15.h,
                                        width: 15.h,
                                        color: appTheme.deepPurpleA10002,
                                      ),
                                      // Use a specific widget
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: textNormal(text: 'حذف'),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == "delete") {
                                          showDeletePostPostEdit(context,widget
                                              .postModel.id
                                              .toString(),);
                                        }

                                        // Handle menu item selection here
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        sizeHeightNormal(height: 10.h),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              state is LoadingEditPostState
                                  ? Column(
                                      children: [
                                        sizeHeightNormal(height: 20.h),
                                        textNormal(
                                            text: 'جاري تعديل المنشور',
                                            fontSize: AppFontSize.fontSize_15,
                                            fontWeight: FontWeight.w500),
                                        loaderNormal(),
                                      ],
                                    )
                                  : Container(
                                      // height: 150.h,
                                      width: MediaQuery.of(context).size.width,
                                      // decoration: AppDecoration.outlineContainer,
                                      color: DIManager.findDep<SharedPrefs>()
                                                  .getThemeApp() ==
                                              'd'
                                          ? appTheme.borderImageColor
                                          : Colors.grey.withOpacity(.3),
                                      // color: Colors.grey.withOpacity(0.2),
                                      // margin: EdgeInsets.symmetric(
                                      //     horizontal: 10.sp, vertical: 12.sp),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //       horizontal: 10.w, vertical: 5.h),
                                          //   child: Container(
                                          //     width: 350.w,
                                          //     child: Row(
                                          //       children: [
                                          //         Spacer(),
                                          //
                                          //    CustomElevatedButton(text: 'نشر', onPressed: () {},width: 80.w,),
                                          //         SizedBox(
                                          //           width: 8.sp,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          sizeHeightNormal(height: 10.h),
                                          TextFormField(
                                            controller: controller,
                                            focusNode: _focusNode,

                                            // textDirection:
                                            //     DIManager.findDep<ApplicationCubit>()
                                            //                 .appLanguage
                                            //                 .languageCode ==
                                            //             AppConsts.LANG_AR
                                            //         ? TextDirection.rtl
                                            //         : TextDirection.ltr,

                                            maxLines: null,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLength: 1000,
                                            // cursorColor: AppColorsController().scaffoldBGColor,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'تعديل المنشور',

                                              // filled: true,
                                              hintStyle: TextStyle(
                                                fontSize: 12.sp,
                                              ),
                                              // counterText: '',
                                              counterStyle: TextStyle(
                                                color: appTheme.black900,
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 2.h,
                                                  horizontal: 20
                                                      .h), // زيادة التباعد الرأسي لزيادة ارتفاع الحقل
                                            ),

                                            onChanged: (value) {
                                              setState(() {
                                                // aboutMeValue = value;
                                              });
                                            },
                                          ),
                                          Container(
                                              width: 350.w,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0.w,
                                                    vertical: 5.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  checkBoxIcon(
                                                                    text:
                                                                        'منشور نصي',
                                                                    isChecked:
                                                                        checkBoxIndex ==
                                                                                0
                                                                            ? true
                                                                            : false,
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (checkBoxIndex !=
                                                                            0) {
                                                                          checkBoxIndex =
                                                                              0;
                                                                        } else {
                                                                          checkBoxIndex =
                                                                              4;
                                                                        }
                                                                      });
                                                                    },
                                                                  ),
                                                                  checkBoxIndex ==
                                                                          0
                                                                      ? Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 12.h),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    checkIndexColors = 0;
                                                                                    colorsChoose = widget.postModel.color[0].color1 ?? '#f52323';
                                                                                    print(colorsChoose);
                                                                                    print(colorsChoose);
                                                                                    print(colorsChoose);
                                                                                    print(colorsChoose);
                                                                                    // colorsChoose = '0xfff52323';
                                                                                  });
                                                                                },
                                                                                child: Stack(
                                                                                  alignment: Alignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 20.h,
                                                                                      width: 20.h,
                                                                                      color: Color(int.parse('0xff${colorWithoutHashtag(widget.postModel.color[0].color1 ?? colorsChoose)}')),
                                                                                    ),
                                                                                    if (checkIndexColors == 0)
                                                                                      Icon(
                                                                                        Icons.check_box_outlined,
                                                                                        color: Colors.white70,
                                                                                        size: 25.h,
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              sizeWidthNormal(),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    checkIndexColors = 1;
                                                                                    colorsChoose = widget.postModel.color[0].color2 ?? '#f52323';
                                                                                    print(colorsChoose);
                                                                                    // colorsChoose = '0xffF5A623';
                                                                                  });
                                                                                },
                                                                                child: Stack(
                                                                                  alignment: Alignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 20.h,
                                                                                      width: 20.h,
                                                                                      color: Color(int.parse('0xff${colorWithoutHashtag(widget.postModel.color[0].color2 ?? colorsChoose)}')),
                                                                                    ),
                                                                                    if (checkIndexColors == 1)
                                                                                      Icon(
                                                                                        Icons.check_box_outlined,
                                                                                        color: Colors.white70,
                                                                                        size: 25.h,
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              sizeWidthNormal(),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    checkIndexColors = 2;
                                                                                    // colorsChoose = '0xff6819b1';
                                                                                    colorsChoose = widget.postModel.color[0].color3 ?? '#f52323';
                                                                                  });
                                                                                },
                                                                                child: Stack(
                                                                                  alignment: Alignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 20.h,
                                                                                      width: 20.h,
                                                                                      color: Color(int.parse('0xff${colorWithoutHashtag(widget.postModel.color[0].color3 ?? colorsChoose)}')),
                                                                                    ),
                                                                                    if (checkIndexColors == 2)
                                                                                      Icon(
                                                                                        Icons.check_box_outlined,
                                                                                        color: Colors.white70,
                                                                                        size: 25.h,
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  checkBoxIcon(
                                                                    text:
                                                                        'يحتوي فيديو',
                                                                    isChecked:
                                                                        checkBoxIndex ==
                                                                                1
                                                                            ? true
                                                                            : false,
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (checkBoxIndex !=
                                                                            1) {
                                                                          checkBoxIndex =
                                                                              1;
                                                                        } else {
                                                                          checkBoxIndex =
                                                                              4;
                                                                        }
                                                                      });
                                                                    },
                                                                  ),
                                                                  checkBoxIndex ==
                                                                          1
                                                                      ? CustomTextFormField(
                                                                          width:
                                                                              200.w,
                                                                          contentPadding: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  10.w,
                                                                              vertical: 10.h),
                                                                          focusNode:
                                                                              _secondFocusNode,
                                                                          hintText:
                                                                              AppLocalizations.of(context)!.link_hint,
                                                                          controller:
                                                                              controllerUrlAds,
                                                                          validator:
                                                                              (text) {
                                                                            if (text == null ||
                                                                                text.isEmpty) {
                                                                              return AppLocalizations.of(context)!.field_is_empty;
                                                                            }

                                                                            if (isURLValid(text) !=
                                                                                true) {
                                                                              return AppLocalizations.of(context)!.should_link_active;
                                                                            }

                                                                            return null;
                                                                          },
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              checkBoxIcon(
                                                                text:
                                                                    'يحتوي صورة',
                                                                isChecked:
                                                                    checkBoxIndex ==
                                                                            2
                                                                        ? true
                                                                        : false,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (checkBoxIndex !=
                                                                        2) {
                                                                      checkBoxIndex =
                                                                          2;
                                                                    } else {
                                                                      checkBoxIndex =
                                                                          4;
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(right: 7.w),
                                            child: PopupMenuButton<String>(
                                              color: appTheme.whiteA700,
                                              onSelected: (String newValue) {
                                                final selectedId = widget.postModel
                                                    .hashtagData.firstWhere(
                                                        (hashtag) => hashtag.hashtag == newValue).id!;

                                                if (idHashtag.isNotEmpty && idHashtag.first == selectedId) {
                                                  return;
                                                }

                                                setState(() {
                                                  idHashtag
                                                    ..clear()
                                                    ..add(selectedId);
                                                });

                                                print(idHashtag);
                                              },
                                              itemBuilder: (BuildContext context) {
                                                return widget.postModel
                                                    .hashtagData.map((hashtag) {
                                                  return PopupMenuItem<String>(
                                                    value: hashtag.hashtag,
                                                    child: Text(
                                                      hashtag.hashtag!,
                                                      style: Theme.of(context).textTheme.displaySmall,
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              child: Container(
                                                decoration: AppDecoration.dropdownButtonChoose,
                                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                height: 26.h,
                                                width: 120.w,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      idHashtag.isNotEmpty
                                                          ? (widget.postModel.hashtagData.firstWhere(
                                                              (hashtag) => hashtag.id == idHashtag.first,
                                                          orElse: () => Hashtag(id: '', hashtag: "اختر قسم",color: '',image: '',isImage: '',postCount: '')) // أمان في حال لم يتم العثور
                                                          ?.hashtag ?? "اختر قسم")
                                                          : widget.postModel.hashtagData.isNotEmpty
                                                          ? widget.postModel.hashtagData.first.hashtag ?? "اختر قسم"
                                                          : "اختر قسم",
                                                      style: Theme.of(context).textTheme.displaySmall,
                                                    ),

                                                    Icon(Icons.arrow_drop_down),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //       horizontal: 10.w),
                                          //   child: Container(
                                          //     width: 400.w,
                                          //     height: 40.h,
                                          //     child: ListView.builder(
                                          //         shrinkWrap: true,
                                          //         itemCount:
                                          //         widget.postModel
                                          //             .hashtagData.length,
                                          //         scrollDirection:
                                          //         Axis.horizontal,
                                          //         itemBuilder:
                                          //             (context, index) {
                                          //           return Padding(
                                          //             padding: EdgeInsets
                                          //                 .symmetric(
                                          //                 horizontal:
                                          //                 4.w),
                                          //             child:  InkWell(
                                          //               onTap: () {
                                          //                 final selectedId = widget.postModel.hashtagData[index].id!;
                                          //
                                          //                 // إذا كان العنصر المحدد هو نفسه الحالي، فلا تفعل شيئًا
                                          //                 if (idHashtag.isNotEmpty && idHashtag.first == selectedId) {
                                          //                   return;
                                          //                 }
                                          //
                                          //                 // تحديث قائمة الـ ID لتحتوي فقط على العنصر الجديد
                                          //                 idHashtag
                                          //                   ..clear()
                                          //                   ..add(selectedId);
                                          //
                                          //                 // تحديث حالة القائمة بحيث يكون العنصر الحالي هو الوحيد المحدد
                                          //                 setState(() {
                                          //                   for (int i = 0; i < isSelectAvailableList.length; i++) {
                                          //                     isSelectAvailableList[i] = (i == index);
                                          //                   }
                                          //
                                          //                   // تحديث القائمة hashtags لإضافة العنصر الجديد فقط
                                          //                   widget.postModel.hashtags
                                          //                     ..clear()
                                          //                     ..add(widget.postModel.hashtagData[index].hashtag.toString());
                                          //                 });
                                          //                 //
                                          //                 // if (!isSelectAvailableList[
                                          //                 //         index] &&
                                          //                 //     !widget
                                          //                 //         .postModel.hashtags
                                          //                 //         .contains(widget
                                          //                 //             .postModel
                                          //                 //             .hashtagData[
                                          //                 //                 index]
                                          //                 //             .hashtag
                                          //                 //             .toString())) {
                                          //                 //   if(idHashtag.length ==3){
                                          //                 //     SnackBarHelper.mySnackBarError('لايمكن اختيار اكثر من 3 هاشتاغات', context);
                                          //                 //     return;
                                          //                 //   }
                                          //                 //   idHashtag.add(widget
                                          //                 //       .postModel
                                          //                 //       .hashtagData[index]
                                          //                 //       .id!);
                                          //                 //   print(idHashtag);
                                          //                 // } else if (widget
                                          //                 //         .postModel.hashtags
                                          //                 //         .contains(widget
                                          //                 //             .postModel
                                          //                 //             .hashtagData[
                                          //                 //                 index]
                                          //                 //             .hashtag
                                          //                 //             .toString()) ||
                                          //                 //     isSelectAvailableList[
                                          //                 //         index]) {
                                          //                 //   widget.postModel.hashtags
                                          //                 //       .remove(widget
                                          //                 //           .postModel
                                          //                 //           .hashtagData[
                                          //                 //               index]
                                          //                 //           .hashtag
                                          //                 //           .toString());
                                          //                 //   if (idHashtag.contains(
                                          //                 //       widget
                                          //                 //           .postModel
                                          //                 //           .hashtagData[
                                          //                 //               index]
                                          //                 //           .id!)) {
                                          //                 //     idHashtag.remove(widget
                                          //                 //         .postModel
                                          //                 //         .hashtagData[index]
                                          //                 //         .id!);
                                          //                 //   }
                                          //                 //
                                          //                 //   // idHashtag.remove(widget
                                          //                 //   //     .postModel
                                          //                 //   //     .hashtagData[index]
                                          //                 //   //     .id!);
                                          //                 // }
                                          //                 // print(idHashtag);
                                          //                 // setState(() {
                                          //                 //   isSelectAvailableList[
                                          //                 //           index] =
                                          //                 //       !isSelectAvailableList[
                                          //                 //           index];
                                          //                 // });
                                          //               },
                                          //               child: Chip(
                                          //                 backgroundColor: isSelectAvailableList[index] || widget.postModel.hashtags.contains(widget.postModel.hashtagData[index].hashtag.toString())
                                          //                     ? appTheme.deepPurpleA100
                                          //                     : Colors.grey,
                                          //
                                          //                 // avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
                                          //                 label: textNormal(
                                          //                   text: widget
                                          //                       .postModel
                                          //                       .hashtagData[index]
                                          //                       .hashtag
                                          //                       .toString(),
                                          //                   fontSize: AppFontSize
                                          //                       .fontSize_12,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           );
                                          //         }),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 5.h),
                                            child: Row(
                                              children: [
                                                // Spacer(),
                                                Row(
                                                  children: [
                                                    textNormal(
                                                      text: 'تفعيل التعليقات',
                                                      fontSize:
                                                          AppFontSize.fontSize_8,
                                                    ),
                                                    Switch(
                                                      value: _isSwitched,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _isSwitched =
                                                              !_isSwitched;
                                                          if (_isSwitched) {
                                                            isHaveComment = 1;
                                                          } else {
                                                            isHaveComment = 0;
                                                          }
                                                          print(isHaveComment);
                                                        });
                                                      },

                                                      activeColor: Colors.white,
                                                      // inactiveThumbColor: appTheme.white,
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                      activeTrackColor:
                                                          Colors.green,
                                                      trackOutlineWidth:
                                                          MaterialStateProperty
                                                              .all(3),

                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      trackOutlineColor:
                                                          WidgetStateColor.resolveWith(
                                                              (states) => appTheme
                                                                  .scaffoldBackgroundColor100),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    textNormal(
                                                      text: 'تفعيل الدردشة',
                                                      fontSize:
                                                          AppFontSize.fontSize_8,
                                                    ),
                                                    Switch(
                                                      value: _isSwitchedChat,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _isSwitchedChat =
                                                              !_isSwitchedChat;
                                                          if (_isSwitchedChat) {
                                                            isHaveChat = 1;
                                                          } else {
                                                            isHaveChat = 0;
                                                          }
                                                          print(isHaveChat);
                                                        });
                                                      },

                                                      activeColor: Colors.white,
                                                      // inactiveThumbColor: appTheme.white,
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                      activeTrackColor:
                                                          Colors.green,
                                                      trackOutlineWidth:
                                                          MaterialStateProperty
                                                              .all(3),

                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      trackOutlineColor:
                                                          MaterialStateColor.resolveWith(
                                                              (states) => appTheme
                                                                  .scaffoldBackgroundColor100),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                sizeWidthNormal(),
                                                checkBoxIndex == 2
                                                    ? _addImage()
                                                    : Container(),
                                                sizeWidthNormal(),
                                                CustomElevatedButton(
                                                    text: 'تعديل المنشور',
                                                    height: 35.h,
                                                    buttonTextStyle: themeLite
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            fontSize: AppFontSize
                                                                .fontSize_11),
                                                    onPressed: () {
                                                      if (controller
                                                          .text.isNotEmpty) {
                                                        FocusScope.of(context).unfocus();
                                                        if(idHashtag.first =='-1'){
                                                          SnackBarHelper.mySnackBarError(
                                                              'يجب اختيار قسم',
                                                              context);
                                                          return;
                                                        }
                                                        if (checkBoxIndex == 0 &&
                                                            colorsChoose !=
                                                                'null') {
                                                          BlocProvider.of<
                                                                      CommunityCubit>(
                                                                  context)
                                                              .editPost(
                                                            idPost: int.parse(
                                                                widget
                                                                    .postModel.id
                                                                    .toString()),
                                                            isHaveComment:
                                                                isHaveComment,
                                                            isHaveChat:
                                                                isHaveChat,
                                                            content:
                                                                controller.text,
                                                            type: 'A',
                                                            background:
                                                                colorsChoose,
                                                            hashtags: idHashtag,
                                                            image: null,
                                                            video: null,
                                                          );
                                                          // if (controller
                                                          //     .text
                                                          //     .length <
                                                          //     20) {
                                                          //   BlocProvider.of<CommunityCubit>(
                                                          //       context)
                                                          //       .createPost(
                                                          //     content:
                                                          //     controller
                                                          //         .text,
                                                          //     type: 'A',
                                                          //   );
                                                          // } else {
                                                          //   BlocProvider.of<CommunityCubit>(context).createPost(
                                                          //       content:
                                                          //       controller
                                                          //           .text,
                                                          //       type:
                                                          //       'A',
                                                          //       background:
                                                          //       colorsChoose);
                                                          // }
                                                        } else if (checkBoxIndex ==
                                                            1) {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            BlocProvider.of<
                                                                        CommunityCubit>(
                                                                    context)
                                                                .editPost(
                                                              idPost: int.parse(
                                                                  widget.postModel
                                                                      .id
                                                                      .toString()),
                                                              isHaveComment:
                                                                  isHaveComment,
                                                              isHaveChat:
                                                                  isHaveChat,
                                                              content:
                                                                  controller.text,
                                                              type: 'C',
                                                              hashtags: idHashtag,
                                                              video:
                                                                  controllerUrlAds!
                                                                      .text
                                                                      .toString(),
                                                              background: null,
                                                              image: null,
                                                            );
                                                          }
                                                        } else if (checkBoxIndex ==
                                                            2) {
                                                          if (widget.postModel
                                                                  .image !=
                                                              null) {
                                                            BlocProvider.of<
                                                                        CommunityCubit>(
                                                                    context)
                                                                .editPost(
                                                              idPost: int.parse(
                                                                  widget.postModel
                                                                      .id
                                                                      .toString()),
                                                              isHaveComment:
                                                                  isHaveComment,
                                                              isHaveChat:
                                                                  isHaveChat,
                                                              content:
                                                                  controller.text,
                                                              type: 'B',
                                                              hashtags: idHashtag,
                                                              background: null,
                                                              video: null,
                                                            );
                                                          } else {
                                                            if (_imagesAddProduct !=
                                                                null) {
                                                              BlocProvider.of<
                                                                          CommunityCubit>(
                                                                      context)
                                                                  .editPost(
                                                                idPost: int.parse(
                                                                    widget
                                                                        .postModel
                                                                        .id
                                                                        .toString()),
                                                                isHaveComment:
                                                                    isHaveComment,
                                                                isHaveChat:
                                                                    isHaveChat,
                                                                content:
                                                                    controller
                                                                        .text,
                                                                type: 'B',
                                                                hashtags:
                                                                    idHashtag,
                                                                image: File(
                                                                    _imagesAddProduct!
                                                                        .path),
                                                                background: null,
                                                                video: null,
                                                              );
                                                            } else {
                                                              SnackBarHelper
                                                                  .mySnackBarError(
                                                                      'يجب اختيار صورة',
                                                                      context);
                                                            }
                                                          }
                                                        } else if (checkBoxIndex ==
                                                            4) {
                                                          BlocProvider.of<
                                                                      CommunityCubit>(
                                                                  context)
                                                              .editPost(
                                                            idPost: int.parse(
                                                                widget
                                                                    .postModel.id
                                                                    .toString()),
                                                            isHaveComment:
                                                                isHaveComment,
                                                            isHaveChat:
                                                                isHaveChat,
                                                            content:
                                                                controller.text,
                                                            type: 'A',
                                                            hashtags: idHashtag,
                                                            image: null,
                                                            background: null,
                                                            video: null,
                                                          );
                                                        }
                                                      }
                                                    },
                                                    width: 100.w,
                                                    buttonStyle: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(appTheme
                                                                  .deepPurpleA100),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          if (checkBoxIndex == 2) ...{
                                            // widget.postModel.image == null
                                            //     ? Container()
                                            //     :
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.h, vertical: 6.w),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    _imagesAddProduct == null
                                                        ? CustomImageView(
                                                            imagePath: widget
                                                                .postModel.image,
                                                            // height: 200.h,
                                                            // width: 200.h,
                                                            fit: BoxFit.fill,
                                                            radius: BorderRadius
                                                                .circular(6.r),
                                                            placeHolder:
                                                                ImageConstant
                                                                    .imgCompanyD,
                                                          )
                                                        : Image.file(
                                                            File(
                                                                _imagesAddProduct!
                                                                    .path),
                                                            fit: BoxFit.fill,
                                                          ),
                                                    _imagesAddProduct == null &&
                                                            widget.postModel
                                                                    .image ==
                                                                null
                                                        ? Container()
                                                        : Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.sp),
                                                            child: Container(
                                                              // width: 100.w,

                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              // height: 80.h,
                                                              // width: 80.w,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      widget
                                                                          .postModel
                                                                          .image = null;
                                                                      _imagesAddProduct =
                                                                          null;
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 30.fSize,
                                                                      height:
                                                                          30.fSize,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: appTheme
                                                                            .deepPurpleA100,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                900.r),
                                                                      ),
                                                                      child: Center(
                                                                          child: Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: appTheme
                                                                            .black900,
                                                                        size:
                                                                            30.sp,
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  sizeWidthNormal(),
                                                                  InkWell(
                                                                      onTap: () {
                                                                        loadImages(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            30.fSize,
                                                                        height:
                                                                            30.fSize,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: appTheme
                                                                              .deepPurpleA100,
                                                                          borderRadius:
                                                                              BorderRadius.circular(900.r),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .edit,
                                                                            color:
                                                                                appTheme.black900,
                                                                            size:
                                                                                22.sp,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          },
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        sizeHeightNormal(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int checkBoxIndex = 4;

  bool isImageNull = false;

  Future<void> _pickImages(context) async {
    // permissionPhoto(context: context,isCamera: false);
    final picker = ImagePicker();
    try{
      final pickedImage = await picker.pickImage(
        imageQuality: 50,
        source: ImageSource.gallery,
      );
      // if (pickedImages.length >= 6) {
      //   SnackBarHelper.mySnackBarError('لايمكن اختيار أكثر من 5 صور ..', context);
      //   return;
      // }

      isImageNull = false;

      final File file = File(pickedImage!.path);
      final fileSize = await file.length();

      if (fileSize <= 1048576) {
        setState(() {
          widget.postModel.image = null;
          _imagesAddProduct = file;
          print(_imagesAddProduct!.path);
        });
      } else {
        // Compress the image before adding it to the list
        final compressedFile = await FileManager.compressFile(file, false);
        if (compressedFile != null) {
          setState(() {
            widget.postModel.image = null;
            _imagesAddProduct = compressedFile;
            print(_imagesAddProduct!.path);
          });
        }
      }
    }  on PlatformException catch (e){
      await permissionPhoto(context: context,isCamera: false);
  }

  }

  Widget checkBoxIcon(
      {required void Function()? onPressed,
      required String text,
      required bool isChecked}) {
    return Container(
      width: 120.w,
      child: Row(
        children: [
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                isChecked
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: appTheme.black900,
              )),
          Flexible(
            // Wrap the text widget with Flexible
            child: textNormal(
              text: text,
              fontSize: AppFontSize.fontSize_12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addImage() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: Icon(
        Icons.camera_alt_outlined,
        // color: AppColorsController().red,
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImages(context);
                    },
                    title: textNormal(text:'Gallery'),
                    leading: Icon(
                      Icons.image_sharp,
                      color: AppColorsController().primaryColor,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColorsController().primaryColor,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _openCamera(context);
                    },
                    title: textNormal(text:'Camera'),
                    leading: Icon(
                      Icons.camera,
                      color: AppColorsController().primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openCamera(BuildContext context) async {
    permissionPhoto(context: context,isCamera: true);
    final picker = ImagePicker();
    try{
      XFile? result = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      // if (images.length >= 1) {
      //   return;
      // }

      if (result != null) {
        File file = File(result.path);
        int fileSizeInBytes = File(result.path).lengthSync();
        double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
        // print(fileSizeInMb);
        if (fileSizeInMb > 1) {
          // SnackBarHelper.mySnackBarError(AppLocalizations.of(context)!.error_size_photo, context);
          //   return;
          final compressedFile = await FileManager.compressFile(file, false);
          if (compressedFile != null) {
            setState(() {
              // fileLicenseListImage = compressedFile;
              widget.postModel.image = null;
              _imagesAddProduct = File(compressedFile.path);
            });
          }
        } else {
          widget.postModel.image = null;

          fileLicenseListImage = result;
          _imagesAddProduct = File(fileLicenseListImage!.path);
        }
      }
      setState(() {});
    }  on PlatformException catch (e){
      await permissionPhoto(context: context,isCamera: false);
    }

  }

  File? _imagesAddProduct;

  XFile? fileLicenseListImage;

  Future<void> loadImages(context) async {
    final picker = ImagePicker();
    XFile? result = await picker.pickImage(source: ImageSource.gallery
        // imageQuality: 50,
        );
    if (result != null) {
      File file = File(result.path);
      int fileSizeInBytes = File(result.path).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      // print(fileSizeInMb);
      if (fileSizeInMb > 1) {
        // SnackBarHelper.mySnackBarError(AppLocalizations.of(context)!.error_size_photo, context);
        //   return;
        final compressedFile = await FileManager.compressFile(file, false);
        if (compressedFile != null) {
          setState(() {
            // fileLicenseListImage = compressedFile;
            _imagesAddProduct = File(compressedFile.path);
            widget.postModel.image = null;
          });
        }
      } else {
        fileLicenseListImage = result;
        _imagesAddProduct = File(fileLicenseListImage!.path);
        widget.postModel.image = null;
      }
    }
    setState(() {});
  }
}
