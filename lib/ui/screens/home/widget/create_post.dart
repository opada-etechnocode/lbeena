import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/helper/snack_bar_helper.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/add_ad_new/category_model.dart';
import '../../../../data/models/add_ad_new/cities_model.dart';
// import '../../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../../widgets/components.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/file_compress.dart';
import '../../../../widgets/user_image_profile.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../../theme/theme_text_form_field.dart';
import '../../auth/login/login_screen.dart';
import '../../community/community.dart';
import '../cubit/cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerCoupon = TextEditingController();
  TextEditingController controllerDateController = TextEditingController();
  TextEditingController? controllerUrlAds = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  String? selectedEmara;
  String? selectedCategory;
  List<SubCategoryModel>? subCategoryList;
  bool isHaveSubCategory = false;
  String? selectedBranch;
  List<String> categoriesId = [];
  List<String> categoriesCounterId = [];
  int checkBoxIndex = 4;
  int checkIndexColors = 5;
  int checkBoxIndex1 = 0;
  List? selectedCategoriesNew = [];
  int indexList = 0;
  int? cityId;
  List<SubCategoryModel> selectedCategories =
      []; // List of selected subcategories
  List<SubCategoryModel> currentCategories =
      []; // List of currently displayed categories

  List<File> _imagesAddProduct = [];

  bool loadingAddAd = false;

  // bool isLoadingCategoriesAddPostModel = true;
  String? colorsChoose = 'null';

  @override
  void initState() {
    super.initState();
    controllerPrice.addListener(() {
      setState(() {}); // تحديث الواجهة عند تغيير النص
    });

    if(HomeCubit.get(context)
        .citiesModel ==null && HomeCubit.get(context).categoriesAddPostModel ==null)
    {
      HomeCubit.get(context)
          .getCategoryMainAndSubCategory();
    }
  }

  @override
  void dispose() {
    controllerPrice.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is LoadingAddAdState) {
          loadingAddAd = true;
        }
        if (state is SuccessAddAdState) {
          loadingAddAd = false;
          SnackBarHelper.mySnackBarPending(
              state.adModel.message.toString(), context);
          controller.clear();
          controllerPrice.clear();
          _imagesAddProduct.clear();
          categoriesId.clear();
          categoriesCounterId.clear();
          selectedBranch = null;

          selectedEmara = null;
          selectedCategory = null;
          checkBoxIndex = 4;
          checkBoxIndex1 = 0;

          checkIndexColors = 5;
          Navigator.pop(context);
        }
        if (state is ErrorAddAdState) {
          loadingAddAd = false;
        }
        if (state is ChangeCouponState) {
          isCoupon = !isCoupon;
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: HandelAndroidApp(
            child: Scaffold(
              appBar: appBarNormalWithIcon(
                  text: 'إنشاء إعلان', isShowBack: true, context: context),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    createPost(context),

                    sizeHeightNormal(height: 170.h),

                    HomeCubit.get(context)
                        .citiesModel?.titleAds ==null?Container():

                    Container(width: 240.w,
                      child: Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(HomeCubit.get(context)
                                .citiesModel!.titleAds.toString(),
                              textStyle: TextStyle(
                                  fontSize: 12.fSize,
                                  fontWeight: FontWeight.bold,

                                  color: appTheme.black900.withOpacity(.5)),
                              speed: const Duration(milliseconds: 50),
                            ),
                          ],
                          totalRepeatCount: 1,
                          onFinished: () {
                            // يمكنك تنفيذ إجراء آخر هنا بعد الانتهاء
                          },

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
    );
  }

  int? havePrice;

  Widget createPost(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: AppDecoration.createPostUi,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // sizeHeightNormal(height: 10.h),

              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                child: Row(
                  children: [
                    UserImageProfile(
                        imageUrl: DIManager.findDep<SharedPrefs>()
                            .getImageProfile()
                            .toString(),
                      onTap: (){},
                    ),

                    sizeWidthNormal(),
                    Container(
                        width: 200.w,
                        child: textNormal(
                            text: DIManager.findDep<SharedPrefs>()
                                        .getAccountType() ==
                                    'company'
                                ? DIManager.findDep<SharedPrefs>()
                                    .getUserNameCompany()
                                    .toString()
                                : DIManager.findDep<SharedPrefs>()
                                    .getUserName()
                                    .toString()))
                  ],
                ),
              ),
        ThemeTextFormField(
                child: TextFormField(
                  controller: controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: DIManager.findDep<SharedPrefs>().getToken() == null
                        ? "يجب تسجيل الدخول حتى تستطيع المشاركة .."
                        : DIManager.findDep<SharedPrefs>()
                                    .getStatusUserIsBlocked() ==
                                0
                            ? 'الحساب محظور لا يمكنك النشر ..'
                            : 'اكتب تفاصيل إعلانك هنا ..',
                    hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color:
                            DIManager.findDep<SharedPrefs>().getToken() == null ||
                                    DIManager.findDep<SharedPrefs>()
                                            .getStatusUserIsBlocked() ==
                                        0
                                ? Colors.red
                                : appTheme.black900),
                    counterStyle: TextStyle(
                      color: appTheme.black900,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.h),
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  onChanged: (value) {
                    setState(() {
                      // aboutMeValue = value;
                    });
                  },
                ),
              ),

              sizeHeightNormal(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Divider(
                  height: 10.h,
                  thickness: 1.5,
                  color: Colors.grey.withOpacity(.3),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (HomeCubit.get(context).categoriesAddPostModel?.data.length !=0) ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.h,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: PopupMenuButton<Cities>(
                                color: appTheme.whiteA700,
                                onSelected: (Cities newValue) {
                                  setState(() {
                                    selectedEmara = newValue.title;
                                    cityId = newValue.id!;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return HomeCubit.get(context)
                                      .citiesModel!
                                      .data
                                      .map((Cities value) {
                                    return PopupMenuItem<Cities>(
                                      value: value,
                                      child: Text(value.title ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall),
                                    );
                                  }).toList();
                                },
                                child: Container(
                                  decoration:
                                      AppDecoration.dropdownButtonChoose,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  height: 26.h,
                                  // width: 90.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(selectedEmara ?? "اختر الإمارة",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: PopupMenuButton<SubCategoryModel>(
                                color: appTheme.whiteA700,
                                onSelected: (SubCategoryModel newValue) {
                                  setState(() {
                                    selectedCategory = newValue
                                        .title; // قم بتخزين العنوان أو الكائن كما تحتاج
                                    isHaveSubCategory = newValue
                                        .hasSubcategory!; // قم بتخزين العنوان أو الكائن كما تحتاج
                                    subCategoryList = newValue.subcategories;
                                    selectedCategories = [];
                                    currentCategories = [];
                                    categoriesId.clear();
                                    havePrice = newValue.have_price;
                                    print('havePrice $havePrice');
                                    // if(categoriesCounterId.contains(newValue.count_id.toString())) {
                                    //   categoriesId.remove(newValue.id.toString());
                                    //   print('categoriesId :$categoriesId');
                                    // }else {
                                    //   categoriesCounterId.add(newValue.count_id.toString());
                                    //   print('categoriesId :$categoriesId');
                                    // }
                                    if (categoriesId.contains(
                                        newValue.categoryId.toString())) {
                                      categoriesId.remove(
                                          newValue.categoryId.toString());
                                      print('categoriesId :$categoriesId');
                                    } else {
                                      categoriesId
                                          .add(newValue.categoryId.toString());
                                      print('categoriesId :$categoriesId');
                                    }
                                    int selectedIndex = HomeCubit.get(context)
                                        .categoriesAddPostModel!
                                        .data
                                        .indexOf(newValue);

                                    indexList = selectedIndex;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return HomeCubit.get(context)
                                      .categoriesAddPostModel!
                                      .data
                                      .map((SubCategoryModel category) {
                                    return PopupMenuItem<SubCategoryModel>(
                                      value: category,
                                      child: Text(
                                        category.title ?? "غير معروف",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    );
                                  }).toList();
                                },
                                child: Container(
                                  decoration:
                                      AppDecoration.dropdownButtonChoose,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  height: 26.h,
                                  // width: 90.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedCategory ?? "اختر الصنف",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if(HomeCubit.get(context)
                                .isLoadingCategoriesAddPostModel)...{
    LoadingAnimationWidget.threeRotatingDots(
    color: appTheme.black900,
    size: 15,
    )
                            },
                            HomeCubit.get(context).categoriesAddPostModel ==
                                        null ||
                                    categoriesId.isEmpty
                                ? Container()
                                : ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7.h),
                                        child: buildPopupMenu(
                                          HomeCubit.get(context)
                                              .categoriesAddPostModel!
                                              .data[indexList],
                                        ),
                                      ),
                                      // Display subcategories based on selection
                                      ...selectedCategories
                                          .map(
                                            (subCategory) =>
                                                buildSubCategoryWidget(
                                                    subCategory),
                                          )
                                          .toList(),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      checkBoxIcon(
                        text: 'لون الخلفية',
                        isChecked: checkBoxIndex == 0 ? true : false,
                        onPressed: () {
                          setState(() {
                            if (checkBoxIndex != 0) {
                              checkBoxIndex = 0;
                            } else {
                              checkBoxIndex = 4;
                            }
                          });
                        },
                      ),
                      checkBoxIndex == 0
                          ? Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: HomeCubit.get(context).colorsPost == null
                                  ? Container()
                                  : Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              checkIndexColors = 0;
                                              colorsChoose =
                                                  HomeCubit.get(context)
                                                      .colorsPost!
                                                      .color1!;
                                              // colorsChoose = '0xfff52323';
                                            });
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 20.h,
                                                width: 20.h,
                                                color: Color(int.parse(
                                                    '0xff${colorWithoutHashtag(HomeCubit.get(context).colorsPost!.color1!)}')),
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

                                              colorsChoose =
                                                  HomeCubit.get(context)
                                                      .colorsPost!
                                                      .color2!;
                                              // colorsChoose = '0xffF5A623';
                                            });
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 20.h,
                                                width: 20.h,
                                                color: Color(int.parse(
                                                    '0xff${colorWithoutHashtag(HomeCubit.get(context).colorsPost!.color2!)}')),
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
                                              colorsChoose =
                                                  HomeCubit.get(context)
                                                      .colorsPost!
                                                      .color3!;
                                            });
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 20.h,
                                                width: 20.h,
                                                color: Color(int.parse(
                                                    '0xff${colorWithoutHashtag(HomeCubit.get(context).colorsPost!.color3!)}')),
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
                  if (havePrice == 1) ...{
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            checkBoxIcon(
                              text: 'يحتوي سعر ',
                              width: 120.w,
                              isChecked: checkBoxIndex1 == 1 ? true : false,
                              onPressed: () {
                                setState(() {
                                  if (checkBoxIndex1 != 1) {
                                    checkBoxIndex1 = 1;
                                  } else {
                                    checkBoxIndex1 = 4;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        checkBoxIndex1 == 1
                            ? Container(
                                width: 90.w,
                                decoration:
                                    AppDecoration.dropdownButtonChoose.copyWith(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.r)),
                                  boxShadow: [],
                                  color: appTheme.scaffoldBackgroundColor100
                                      .withOpacity(.1),
                                ),
                                height: 30.h,
                                child: CustomTextFormField(
                                  controller: controllerPrice,
                                  focusNode: _focusNode2,
                                  fillColor: Colors.black12,
                                  height: 30.h,
                                  borderDecoration: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  textStyle: themeLite.textTheme.titleSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10.fSize),
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.number,
                                  isMobile: true,
                                ))
                            : Container(),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            checkBoxIcon(
                              text: 'يحتوي خصم ',
                              width: 120.w,
                              isChecked: isCoupon,
                              onPressed: () {
                                setState(() {
                                  isCoupon = !isCoupon;
                                });
                              },
                            ),
                          ],
                        ),
                        isCoupon
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 90.w,
                                    decoration: AppDecoration
                                        .dropdownButtonChoose
                                        .copyWith(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      boxShadow: [],
                                      color: appTheme.scaffoldBackgroundColor100
                                          .withOpacity(.1),
                                    ),
                                    height: 30.h,
                                    child: CustomTextFormField(
                                      width: 100.w,
                                      height: 45.h,
                                      controller: controllerCoupon,
                                      // fillColor: appTheme.whiteA700,
                                      hintText: "نسبة الخصم %",

                                      hintStyle: themeLite.textTheme.bodySmall!
                                          .copyWith(
                                        fontSize: 9.fSize,
                                        overflow: TextOverflow.visible,
                                        color: Colors.grey,
                                      ),
                                      autofocus: false,
                                      isMobile: true,
                                      maxLength: 2,
                                      fillColor: Colors.black12,
                                      borderDecoration: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.number,
                                      focusNode: _focusNode3,
                                      counterText: '',
                                      validator: (text) {
                                        // if (text == null || text.isEmpty) {
                                        //   return AppLocalizations.of(context)!.field_is_empty;
                                        // }
                                        // if (text!.length > 10 || text.length < 9) {
                                        //   return 'يرجى التأكد من الرقم';
                                        // }

                                        return null;
                                      },

                                      textStyle: themeLite.textTheme.titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10.fSize),
                                    ),
                                  ),
                                  sizeWidthNormal(),
                                  Container(
                                    width: 90.w,
                                    decoration: AppDecoration
                                        .dropdownButtonChoose
                                        .copyWith(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      boxShadow: [],
                                      color: appTheme.scaffoldBackgroundColor100
                                          .withOpacity(.1),
                                    ),
                                    height: 30.h,
                                    child: CustomTextFormField(
                                      width: 100.w,
                                      height: 45.h,
                                      borderDecoration: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      fillColor: Colors.black12,
                                      controller: controllerDateController,
                                      counterText: '',
                                      hintStyle: themeLite.textTheme.bodySmall!
                                          .copyWith(
                                        fontSize: 9.fSize,
                                        overflow: TextOverflow.visible,
                                        color: Colors.grey,
                                      ),
                                      hintText: "عدد ايام الخصم",
                                      autofocus: false,
                                      isMobile: true,
                                      maxLength: 3,
                                      // alignment: Alignment.center,
                                      textInputAction: TextInputAction.done,
                                      textInputType: TextInputType.number,
                                      focusNode: _focusNode4,

                                      validator: (text) {
                                        // if (text == null || text.isEmpty) {
                                        //   return AppLocalizations.of(context)!.field_is_empty;
                                        // }

                                        // if (int.parse(text.toString()) <= 365) {
                                        //   return 'يرجى التأكد من الرقم';
                                        // }

                                        return null;
                                      },

                                      textStyle: themeLite.textTheme.titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10.fSize),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),

                      ],
                    ),
                  },
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            checkBoxIcon(
                              text: 'يحتوي صورة',
                              isChecked: checkBoxIndex == 2 ? true : false,
                              onPressed: () {
                                setState(() {
                                  if (checkBoxIndex != 2) {
                                    checkBoxIndex = 2;
                                  } else {
                                    checkBoxIndex = 4;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      _imagesAddProduct.isEmpty && checkBoxIndex == 2
                          ? Container(
                              width: 200,
                              child: InkWell(
                                onTap: () {
                                  // loadImages();
                                  _pickImages(context);
                                },
                                child: Container(
                                  // width: 320.h,
                                  height: 50.h,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      // physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h, vertical: 6.w),
                                          child: Container(
                                            width: 60.sp,
                                            height: 70.sp,
                                            decoration: AppDecoration
                                                .outlinePurple
                                                .copyWith(
                                                    borderRadius:
                                                        BorderRadius.zero),
                                            child: Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: appTheme.deepPurpleA100,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            )
                          : checkBoxIndex == 2
                              ? Container(
                                  height: 50.h,
                                  width: 200.w,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (int i = 0;
                                            i < _imagesAddProduct.length;
                                            i++) ...[
                                          InkWell(
                                            onTap: () {
                                              showStatusImages(context, i);
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.h,
                                                  vertical: 6.w),
                                              child: Container(
                                                width: 60.w,
                                                height: 70.h,
                                                decoration: AppDecoration
                                                    .outlinePurple
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadius.zero),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 350.w,
                                                      height: 150.h,
                                                      child: Image.file(
                                                        File(
                                                            _imagesAddProduct[i]
                                                                .path),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .change_circle_rounded,
                                                      color: appTheme
                                                          .defaultPrimaryColor,
                                                      size: 30.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        _imagesAddProduct.length < 5
                                            ? sizeWidthNormal(width: 10.h)
                                            : Container(),
                                        _imagesAddProduct.length < 5
                                            ? InkWell(
                                                onTap: () {
                                                  // loadImages();
                                                  _pickImages(context);
                                                },
                                                child: textNormal(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .add))
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                      // sizeHeightNormal(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Divider(
                      height: 10.h,
                      thickness: 1.5,
                      color: Colors.grey.withOpacity(.3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loadingAddAd
                            ? Container(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  color: appTheme.greenColor,
                                ),
                              )
                            : CustomElevatedButton(
                                text: 'نشر',
                                isDisabled: cityId == null || categoriesId.isEmpty||controller.text.isEmpty ?true:false,
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (DIManager.findDep<SharedPrefs>()
                                          .getStatusUser() ==
                                      '2') {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarHelper.mySnackBarError(
                                        'الشركة مرفوضة لايمكنك النشر ..',
                                        context);
                                    return;
                                  }
                                  if (DIManager.findDep<SharedPrefs>()
                                          .getStatusUserIsBlocked() ==
                                      0) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarHelper.mySnackBarError(
                                        'الحساب محظور لايمكنك النشر ..',
                                        context);
                                    return;
                                  }
                                  if (DIManager.findDep<SharedPrefs>()
                                          .getToken() ==
                                      null) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarHelper.mySnackBarError(
                                        'الرجاء تسجيل دخول', context);
                                    return;
                                  }
                                  if (controller.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarHelper.mySnackBarError(
                                        'الرجاء ملئ الوصف', context);

                                    return;
                                  }
                                  if (cityId == null) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarHelper.mySnackBarError(
                                        'الرجاء إضافة المدينة', context);
                                    return;
                                  }
                                  if (categoriesId.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarHelper.mySnackBarError(
                                        'الرجاء إضافة صنف', context);
                                    return;
                                  }

                                  if (isCoupon) {
                                    if (controllerPrice.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      SnackBarHelper.mySnackBarError(
                                          'الرجاء إضافة سعر', context);
                                      return;
                                    }

                                    if (controllerCoupon.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      SnackBarHelper.mySnackBarError(
                                          'الرجاء إضافة نسبة الخصم', context);
                                      return;
                                    }

                                    if (controllerDateController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      SnackBarHelper.mySnackBarError(
                                          'الرجاء إضافة عدد أيام الخصم',
                                          context);
                                      return;
                                    }

                                    if (controllerDateController.text != null &&
                                        int.parse(
                                                controllerDateController.text) >
                                            365) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      SnackBarHelper.mySnackBarError(
                                          'الرجاء اختيار مدة أقل من سنة',
                                          context);
                                      return;
                                    }
                                    if (controllerCoupon.text != null &&
                                        int.parse(controllerCoupon!.text) >
                                            100) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      SnackBarHelper.mySnackBarError(
                                          'الرجاء اختيار النسبة أقل من 100',
                                          context);
                                      return;
                                    }
                                  }
                                  if (checkBoxIndex == 0) {
                                    BlocProvider.of<HomeCubit>(context).addAd(
                                        description: controller.text,
                                        categories: categoriesId,
                                        cityId: cityId.toString(),
                                        image: _imagesAddProduct,
                                        price: controllerPrice.text,
                                        isAddCoupon: isCoupon ? 1 : 0,
                                        daysAddCoupon:
                                            controllerDateController.text,
                                        couponPercent: controllerCoupon.text,
                                        background_color: colorsChoose);
                                  } else {
                                    BlocProvider.of<HomeCubit>(context).addAd(
                                        description: controller.text,
                                        categories: categoriesId,
                                        cityId: cityId.toString(),
                                        image: _imagesAddProduct,
                                        price: controllerPrice.text,
                                        isAddCoupon: isCoupon ? 1 : 0,
                                        daysAddCoupon:
                                            controllerDateController.text,
                                        couponPercent: controllerCoupon.text,
                                        background_color: null);
                                  }
                                },
                                width: 70.w,
                                height: 30.h,
                                buttonTextStyle: themeLite.textTheme.bodySmall!
                                    .copyWith(color: Colors.white),
                                buttonStyle: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                        cityId == null || categoriesId.isEmpty||controller.text.isEmpty?Colors.grey:      appTheme.greenColor,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),

              sizeHeightNormal(height: 5.h),

            ],
          ),
        ),
      ),
    );
  }

  bool isCoupon = false;
  String? couponNumber;
  String? couponDateNumber;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  void showCoupon(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context3) {
        return StatefulBuilder(
            builder: (BuildContext context2, StateSetter setState) {
          return Form(
            key: _formKey2,
            child: AlertDialog(
              backgroundColor: appTheme.buttonColor,
              title: Text(
                'حدد نسبة الخصم:',
                style: themeLite.textTheme.titleSmall,
              ),
              content: Container(
                height: 140.h,
                child: Column(
                  children: [
                    CustomTextFormField(
                      width: 208.h,
                      controller: controllerCoupon,
                      fillColor: appTheme.whiteA700,
                      hintText: "",
                      autofocus: false,
                      maxLength: 2,
                      // alignment: Alignment.center,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      // focusNode: focusNode,

                      validator: (text) {
                        // if (text == null || text.isEmpty) {
                        //   return AppLocalizations.of(context)!.field_is_empty;
                        // }
                        // if (text!.length > 10 || text.length < 9) {
                        //   return 'يرجى التأكد من الرقم';
                        // }

                        return null;
                      },

                      textStyle: themeLite.textTheme.titleSmall!
                          .copyWith(fontWeight: FontWeight.w300),

                      contentPadding: EdgeInsets.only(
                          left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
                    ),
                    // sizeHeightNormal(),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 25.h),
                          child: textNormal(text: 'مدة الخصم: '),
                        ),
                        sizeWidthNormal(),
                        CustomTextFormField(
                          width: 100.w,
                          controller: controllerDateController,
                          fillColor: appTheme.whiteA700,
                          hintText: "",
                          autofocus: false,
                          maxLength: 3,
                          // alignment: Alignment.center,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.number,
                          // focusNode: focusNode,

                          validator: (text) {
                            // if (text == null || text.isEmpty) {
                            //   return AppLocalizations.of(context)!.field_is_empty;
                            // }

                            // if (int.parse(text.toString()) <= 365) {
                            //   return 'يرجى التأكد من الرقم';
                            // }

                            return null;
                          },

                          textStyle: themeLite.textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w300),

                          contentPadding: EdgeInsets.only(
                              left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    if (isCoupon) {
                      couponNumber = '';
                      couponDateNumber = '';
                      controllerDateController!.text = '';
                      controllerCoupon!.text = '';
                      HomeCubit.get(context)
                          .changeVariable(isChangeCoupon: true);
                      Navigator.pop(context);
                    } else {
                      if (controllerCoupon?.text == null ||
                          controllerCoupon!.text.isEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        SnackBarHelper.mySnackBarError(
                            'الرجاء تحديد نسبة للخصم', context);
                        return;
                      }
                      if (controllerDateController.text == null ||
                          controllerDateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        SnackBarHelper.mySnackBarError(
                            'الرجاء تحديد مدة للخصم', context);
                        return;
                      }
                      if (controllerDateController.text != null &&
                          int.parse(controllerDateController.text) > 365) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        SnackBarHelper.mySnackBarError(
                            'الرجاء اختيار مدة أقل من سنة', context);
                        return;
                      }
                      if (controllerCoupon.text != null &&
                          int.parse(controllerCoupon!.text) > 100) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        SnackBarHelper.mySnackBarError(
                            'الرجاء اختيار النسبة أقل من 100', context);
                        return;
                      }
                      if (_formKey2.currentState!.validate()) {
                        couponNumber = controllerCoupon.text;
                        couponDateNumber = controllerDateController.text;
                        HomeCubit.get(context)
                            .changeVariable(isChangeCoupon: true);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Center(
                      child: Container(
                    width: 120.h,
                    height: 40.h,
                    decoration: AppDecoration.outlineSelectedLite
                        .copyWith(borderRadius: BorderRadius.circular(30.h)),
                    child: Center(
                      child: isCoupon
                          ? textNormal(
                              text: 'إلغاء الخصم',
                            )
                          : textNormal(
                              text: AppLocalizations.of(context)!.save,
                            ),
                    ),
                  )),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void showStatusImages(BuildContext context, i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: appTheme.buttonColor,
            title: Text(
              'تعديل حالة الصورة',
              style: themeLite.textTheme.titleSmall
                  ?.copyWith(color: appTheme.whiteA700),
            ),
            content: Container(
              height: 80.h,
              // width: 80.w,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _imagesAddProduct.removeAt(i);
                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Container(
                      width: 110.h,
                      height: 40.h,
                      decoration: AppDecoration.outlineSelectedLite
                          .copyWith(borderRadius: BorderRadius.circular(30.h)),
                      child: Center(
                        child: textNormal(text: 'حذف'),
                      ),
                    )),
                  ),
                  sizeWidthNormal(),
                  InkWell(
                    onTap: () {
                      loadImages(i, context);
                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Container(
                      width: 110.h,
                      height: 40.h,
                      decoration: AppDecoration.outlineSelectedLite
                          .copyWith(borderRadius: BorderRadius.circular(30.h)),
                      child: Center(
                        child: textNormal(text: 'تعديل'),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> loadImages(i, context) async {
    final picker = ImagePicker();
    XFile? result = await picker.pickImage(source: ImageSource.gallery
        // imageQuality: 50,
        );
    if (result != null) {
      File file = File(result.path);
      int fileSizeInBytes = File(result.path).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print(fileSizeInMb);
      if (fileSizeInMb > 1) {
        // SnackBarHelper.mySnackBarError(AppLocalizations.of(context)!.error_size_photo, context);
        //   return;
        final compressedFile = await FileManager.compressFile(file, false);
        if (compressedFile != null) {
          setState(() {
            // fileLicenseListImage = compressedFile;
            _imagesAddProduct[i] = File(compressedFile.path);
          });
        }
      } else {
        fileLicenseListImage = result;
        _imagesAddProduct[i] = File(fileLicenseListImage!.path);
      }
    }
    setState(() {});
  }

  XFile? fileLicenseListImage;
  bool isImageNull = false;

  Future<void> _pickImages(BuildContext context) async {
    // permissionPhoto(context: context,isCamera: false);
    try {
      final picker = ImagePicker();
      final pickedImages = await picker.pickMultiImage(
        imageQuality: 50,
      );

      if (pickedImages == null || pickedImages.isEmpty) {
        // إذا لم يتم اختيار أي صور، توقف عن العملية
        return;
      }

      if (pickedImages.length >= 6) {
        SnackBarHelper.mySnackBarError(
            'لا يمكن اختيار أكثر من 5 صور ..', context);
        return;
      }

      isImageNull = false;
      for (var image in pickedImages) {
        final File file = File(image.path);
        final fileSize = await file.length();

        if (fileSize <= 1048576) {
          setState(() {
            _imagesAddProduct.add(file);
          });
        } else {
          // ضغط الصورة قبل إضافتها إلى القائمة
          final compressedFile = await FileManager.compressFile(file, false);
          if (compressedFile != null) {
            setState(() {
              _imagesAddProduct.add(compressedFile);
            });
          }
        }
      }
    } on PlatformException catch (e) {
      print(e);
      await permissionPhoto(context: context, isCamera: false);
    }
  }

  int indexListNew = 0;
  Map<int, int> indexMap =
      {}; // لتخزين الفهرس لكل عنصر بناءً على count_id أو id
  Map<int, int> counterIdAndCategoriesId =
      {}; // لتخزين الفهرس لكل عنصر بناءً على count_id أو id
  Set<int> currentCategoriesIds = {}; // لتخزين معرفات الفئات الفرعية
  int? count_id;

  Widget buildPopupMenu(SubCategoryModel subCategory) {
    if (subCategory.subcategories.isEmpty) {
      // إذا كانت القائمة الفرعية فارغة، عرض placeholder
      return Container();
    }

    // إعادة تعيين الفهرس إلى 0 عند تغيير الفئة الرئيسية
    int safeIndex = indexMap[subCategory.count_id] ?? 0;
    safeIndex = safeIndex.clamp(
        0,
        subCategory.subcategories.length -
            1); // تأكد من أن الفهرس ضمن الحدود الصحيحة

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: PopupMenuButton<SubCategoryModel>(
        color: appTheme.whiteA700,
        onSelected: (SubCategoryModel newValue) {
          setState(() {
            if (count_id != null) {
              if (subCategory.count_id! < count_id!) {
                // حذف القيم من categoriesId المرتبطة بالفئات الأكبر
                categoriesId.removeWhere((categoryId) {
                  return counterIdAndCategoriesId.entries.any((entry) =>
                      entry.key > subCategory.count_id! &&
                      entry.value.toString() == categoryId);
                });

                // حذف القيم من selectedCategories المرتبطة بالفئات الأكبر
                // selectedCategories.removeWhere((category) {
                //   return counterIdAndCategoriesId.entries.any((entry) => entry.key > subCategory.count_id! && entry.value == category.categoryId);
                // });
                if (selectedCategories.isNotEmpty) {
                  selectedCategories.removeLast(); // حذف آخر عنصر
                }
              }
            }
            print('count_id  $count_id');
            print('subCategory.count_id!  ${subCategory.count_id!}');
            // إزالة القيمة السابقة من categoriesId إذا كانت موجودة
            if (counterIdAndCategoriesId.containsKey(subCategory.count_id!)) {
              int previousCategoryId =
                  counterIdAndCategoriesId[subCategory.count_id!]!;
              categoriesId.remove(previousCategoryId.toString());
            }

            // إضافة العنصر الجديد إلى categoriesId
            if (!categoriesId.contains(newValue.categoryId.toString())) {
              categoriesId.add(newValue.categoryId.toString());
              count_id = newValue.count_id;
            }

            // تحديث الفهرس بناءً على الاختيار
            int newIndex = subCategory.subcategories
                .indexWhere((category) => category.id == newValue.id);
            indexMap[subCategory.count_id!] = (newIndex != -1) ? newIndex : 0;

            // تحديث الـ counterIdAndCategoriesId بالقيمة الجديدة
            counterIdAndCategoriesId[subCategory.count_id!] =
                newValue.categoryId!;

            // إذا كان العنصر الجديد مختلفًا عن العنصر المختار سابقًا، قم بتحديث currentCategories
            if (!selectedCategories.contains(newValue)) {
              currentCategories.clear(); // إعادة تعيين الفئات الفرعية الحالية
              currentCategoriesIds.clear(); // إعادة تعيين معرفات الفئات الفرعية
              selectedCategories.add(newValue);
              // if(count_id !=newValue.count_id!){
              //    // إضافة العنصر الجديد
              //
              // }
            }

            print("categoriesId $categoriesId");

            // إذا كانت الفئة المختارة تحتوي على فئات فرعية، أضفها
            if (newValue.hasSubcategory == true) {
              bool hasDuplicates = newValue.subcategories.any((subcategory) =>
                  currentCategoriesIds.contains(subcategory.categoryId));
              if (!hasDuplicates) {
                currentCategories.addAll(newValue.subcategories);
                currentCategoriesIds.addAll(newValue.subcategories.map(
                    (sub) => sub.categoryId!)); // تخزين معرفات الفئات الفرعية
              }
            }
          });
        },
        itemBuilder: (BuildContext context) {
          return subCategory.subcategories.map((SubCategoryModel category) {
            return PopupMenuItem<SubCategoryModel>(
              value: category,
              child: Text(
                category.title ?? "غير معروف", // معالجة النص في حالة كان null
                style: Theme.of(context).textTheme.displaySmall,
              ),
            );
          }).toList();
        },
        child: Container(
          decoration: AppDecoration.dropdownButtonChoose,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 26.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (subCategory.subcategories.isNotEmpty)
                Text(
                  subCategory.subcategories[safeIndex].title ?? "اختر الصنف",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubCategoryWidget(SubCategoryModel subCategory) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (subCategory.hasSubcategory == true)
          buildPopupMenu(subCategory), // بناء قائمة منسدلة للعناصر الفرعية
      ],
    );
  }

  Widget checkBoxIcon(
      {required void Function()? onPressed,
      required String text,
      double? width,
      required bool isChecked}) {
    return Container(
      width: width ?? 120.w,
      height: 35.h,
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
                color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

Widget createPostUi(
  context, {
  required Animation<double> opacity,
}) {
  return InkWell(
    onTap: () {

      if (DIManager.findDep<SharedPrefs>().getToken() == null) {
        navigatorToPush(context: context, pageName: LoginScreen());
      } else {
        if(DIManager.findDep<SharedPrefs>().getStatusUser() =='2')
        {
          SnackBarHelper.mySnackBarError(
              ' تم رفض حسابك الرجاء مراجعة الدعم ..', context);
          return;
        }
        if(DIManager.findDep<SharedPrefs>().getStatusUser() =='0')
        {
          SnackBarHelper.mySnackBarPending(
              'حساب شركتك قيد المراجعة يرجى الانتظار ..',
              context);
          return;
        }
        navigatorToPush(context: context, pageName: CreatePost());
      }
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 70.h,
          width: MediaQuery.of(context).size.width,
          color: appTheme.lightBlue100,
        ),
        Row(
          children: [
            sizeWidthNormal(width: 15.w),
            // CustomImageView(
            //   imagePath: ImageConstant.,
            //   height: 26.h,
            //   width: 26.h,
            //   radius: BorderRadius.circular(900.r),
            //   fit: BoxFit.fill,
            //   placeHolder: ImageConstant.imgPerson,
            // ),
            Container(
                decoration: AppDecoration
                    .outlinePurple
                    .copyWith(
                    borderRadius:
                    BorderRadius.circular(122),
                    boxShadow: [
                      BoxShadow(
                          color: appTheme.greenColorApp,
                          spreadRadius: 2.h,
                          blurRadius: 2.h,
                          offset: Offset(
                            0,
                            0,
                          ))
                    ]
                ),
                width: 30,height: 30,
                child: Icon(Icons.add,color: appTheme.greenColorApp,)),
            sizeWidthNormal(),
            FadeTransition(
              opacity: opacity,
              child: Shimmer.fromColors(
                // baseColor: appTheme.cyan400,
                // highlightColor: appTheme.blue600,
                baseColor: appTheme.black900,
                highlightColor: Colors.redAccent,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      DIManager.findDep<SharedPrefs>().getToken() == null
                          ? "يجب تسجيل الدخول حتى تستطيع المشاركة .."
                          : DIManager.findDep<SharedPrefs>()
                                      .getStatusUserIsBlocked() ==
                                  0
                              ? 'الحساب محظور لا يمكنك النشر ..'
                              : 'اضغط هنا لنشر إعلانك ..',
                      textStyle: TextStyle(
                          fontSize: 12.fSize,
                          fontWeight: FontWeight.bold,
                          color: DIManager.findDep<SharedPrefs>().getToken() ==
                                      null ||
                                  DIManager.findDep<SharedPrefs>()
                                          .getStatusUserIsBlocked() ==
                                      0
                              ? Colors.red
                              : appTheme.black900.withOpacity(.5)),
                      speed: const Duration(milliseconds: 150),
                    ),
                  ],
                  totalRepeatCount: 1,
                  onFinished: () {
                    // يمكنك تنفيذ إجراء آخر هنا بعد الانتهاء
                  },
                  onTap: () {
                    if (DIManager.findDep<SharedPrefs>().getToken() == null) {
                      navigatorToPush(
                          context: context, pageName: LoginScreen());
                    } else {
                      navigatorToPush(context: context, pageName: CreatePost());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
