import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/ugc/cubit/ugc_cubit.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/custom_text_form_field.dart';

import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/add_ad_new/cities_model.dart';
import '../../../data/models/home_page/categories_main.dart';
import '../../../data/models/home_page/home_page_model.dart';
import '../../../data/models/profile_company/profile_company_model.dart';
import '../../../data/models/ugc/ugc_category_model.dart';
import '../../../widgets/BoothShimmer.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../auth/login/model_home_page.dart';
import '../home/cubit/cubit.dart';
import 'cubit/ugc_state.dart';

class SubscribeSgcPage extends StatefulWidget {
  SubscribeSgcPage({
    super.key,
    this.isEditUGC = false,
    required this.dateHomePage ,
    List<Ugc>? ugcList,
  }) : ugcList = ugcList ?? [];

  bool isEditUGC;
  List<Ugc> ugcList;
  HomePageLoginModel? dateHomePage;
  @override
  State<SubscribeSgcPage> createState() => _SubscribeSgcPageState();
}

class _SubscribeSgcPageState extends State<SubscribeSgcPage> {
  bool isLoadingUgcCategory = true;
  List<UgcCategoryData> ugcCategoryList = [];
  String? selectedEmirate;
  int? cityId;
  String? selectedCategory;
  String? selectedGender;
  int? selectedCategoryId;
  bool isSelectedEmirateError = false;
  bool isSelectedCategoryError = false;
  bool isSelectedGenderError = false;

  List<String> ugcLinks = ["", "", "", ""];
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNode = [];

  @override
  void initState() {
    if (widget.isEditUGC && widget.ugcList.isNotEmpty) {
      selectedEmirate = widget.ugcList[0].city_name;
      cityId = widget.ugcList[0].cityId;
      selectedCategoryId = widget.ugcList[0].categoryUgcId;
      selectedCategory = widget.ugcList[0].category_name;
      selectedCategory = widget.ugcList[0].category_name;
      selectedGender = widget.ugcList[0].gender;
      if (widget.ugcList[0].links!.isNotEmpty) {
        controllers = List.generate(
          4,
          (index) => TextEditingController(
            text: index < widget.ugcList[0].links!.length
                ? widget.ugcList[0].links![index]
                : "",
          ),
        );
        focusNode = List.generate(
          4,
          (index) => FocusNode(),
        );
      } else {
        controllers = List.generate(4, (index) => TextEditingController());
        focusNode = List.generate(4, (index) => FocusNode());
      }
    } else {
      focusNode = List.generate(4, (index) => FocusNode());
      controllers = List.generate(4, (index) => TextEditingController());
    }
    super.initState();
  }

  bool isSelectedMore3000 = false;
  bool? isMore3000;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: Scaffold(
          appBar: appBarNormalWithIcon(
              text: 'UGC', context: context, isShowBack: true),
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UgcCubit()..getUgcCategory(),
              ),
              BlocProvider(
                create: (context) => HomeCubit()..getCategoryMainAndSubCategory(),
                lazy: false,
              ),
            ],
            child: BlocConsumer<UgcCubit, UgcState>(
              listener: (context, state) {
                if (state is LoadingUgcCategoryState) {
                  isLoadingUgcCategory = true;
                }
                if (state is SuccessUgcCategoryState) {
                  isLoadingUgcCategory = false;
                  ugcCategoryList = state.ugcCategoryModel.data;
                }
                if (state is ErrorUgcCategoryState) {
                  isLoadingUgcCategory = false;
                }
                if (state is SuccessSubscribeToUgcState) {
                  navigatorToPushReplacementUntil(
                    context: context, location: '/homePage',
                        extra: HomePageLoginModel(
                      homePageModel: widget.dateHomePage?.homePageModel,
                      categoriesMainModel:  widget.dateHomePage?.categoriesMainModel,
                      // adsRandomModel:  widget.dateHomePage?.adsRandomModel,
                    )
                  );
                  DIManager.findDep<SharedPrefs>().setStatusUGC(true);
                  SnackBarHelper.mySnackBarSuccess(
                      state.subscribeToUgcModel!.message, context);
                }
                if (state is ErrorSubscribeToUgcState) {
                  SnackBarHelper.mySnackBarError(state.error, context);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      sizeHeightNormal(),
                      CustomImageView(
                        imagePath: ImageConstant.ugcImage,
                        // width: 250.w,
                        // height: 250.w,
                        fit: BoxFit.fill,
                        radius: BorderRadiusStyle.circleBorder7,
                      ),
                      if (!isLoadingUgcCategory) ...{
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: PopupMenuButton<Cities>(
                                  color: appTheme.whiteA700,
                                  onSelected: (Cities newValue) {
                                    setState(() {
                                      selectedEmirate = newValue.title;
                                      cityId = newValue.id!;
                                      isSelectedEmirateError = false;
                                      print("$selectedEmirate : $cityId");
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
                                    decoration: AppDecoration.dropdownButtonChoose
                                        .copyWith(color: appTheme.whiteA700),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 35.h,
                                    // width: 90.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedEmirate ?? "اختر الإمارة",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: isSelectedEmirateError
                                                      ? Colors.red
                                                      : appTheme.black900),
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              sizeHeightNormal(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: PopupMenuButton<UgcCategoryData>(
                                  color: appTheme.whiteA700,
                                  onSelected: (UgcCategoryData newValue) {
                                    setState(() {
                                      selectedCategory = newValue.name;
                                      selectedCategoryId = newValue.id!;
                                      isSelectedCategoryError = false;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return ugcCategoryList
                                        .map((UgcCategoryData data) {
                                      return PopupMenuItem<UgcCategoryData>(
                                        value: data,
                                        child: Text(
                                          data.name ?? "غير معروف",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  child: Container(
                                    decoration: AppDecoration.dropdownButtonChoose
                                        .copyWith(color: appTheme.whiteA700),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 35.h,
                                    // width: 90.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedCategory ?? "اختر صنف المحتوى",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: isSelectedCategoryError
                                                      ? Colors.red
                                                      : appTheme.black900),
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              sizeHeightNormal(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: PopupMenuButton<String>(
                                  color: appTheme.whiteA700,
                                  onSelected: (String newValue) {
                                    setState(() {
                                      selectedGender = newValue;
                                      isSelectedGenderError = false;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: "male",
                                        child: Text(
                                          "ذكر",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: "female",
                                        child: Text(
                                          "أنثى",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      ),
                                    ];
                                  },
                                  child: Container(
                                    decoration: AppDecoration.dropdownButtonChoose
                                        .copyWith(
                                      color: appTheme.whiteA700,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 35.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (selectedGender == 'female'
                                              ? 'انثى'
                                              : selectedGender == 'male'
                                                  ? 'ذكر'
                                                  : "اختر الجنس"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: isSelectedGenderError
                                                      ? Colors.red
                                                      : appTheme.black900),
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              sizeHeightNormal(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: PopupMenuButton<bool>(
                                  color: appTheme.whiteA700,
                                  onSelected: (bool newValue) {
                                    setState(() {
                                      isMore3000 = newValue;
                                      isSelectedMore3000 = false;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<bool>(
                                        value:true,
                                        child: Text(
                                          "أكثر أو يساوي 3000 متابع",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      ),
                                      PopupMenuItem<bool>(
                                        value:false,
                                        child: Text(
                                          "أقل من 3000 متابع",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      ),
                                    ];
                                  },
                                  child: Container(
                                    decoration: AppDecoration.dropdownButtonChoose
                                        .copyWith(
                                      color: appTheme.whiteA700,
                                    ),
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 35.h,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (isMore3000 == true
                                              ?  "أكثر أو يساوي 3000 متابع"
                                              : isMore3000 == false
                                              ?   "أقل من 3000 متابع"
                                              : "عدد المتابعين"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                              color: isSelectedMore3000
                                                  ? Colors.red
                                                  : appTheme.black900),
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ugcLinks.length,
                          itemBuilder: (context, index) {
                            String label = "رابط إضافي ..";
                            if (index == 0) label = "رابط الفيسبوك ..";
                            if (index == 1) label = "رابط إنستغرام ..";
                            if (index == 2) label = "رابط تيك توك ..";

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      onChanged: (value) {
                                        ugcLinks[index] = value;

                                        print('ugcLinks $ugcLinks');
                                        print('ugcLinks $ugcLinks');
                                      },
                                      focusNode: focusNode[index],
                                      controller: controllers[index],
                                      hintText: label,
                                      hintStyle: themeLite.textTheme.bodyMedium!
                                          .copyWith(
                                              color: Colors.grey,
                                              fontSize: 12.fSize),
                                      borderDecoration: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7.r),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  ...{
                                    if (index >= 3) ...{
                                      sizeWidthNormal(width: 15.w),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (ugcLinks.length > 4) {
                                              ugcLinks.removeAt(index);
                                              controllers.remove(
                                                  TextEditingController());
                                              focusNode.remove(FocusNode());
                                            }
                                          });
                                        },
                                        child: Icon(Icons.remove_circle,
                                            color: Colors.red),
                                      ),
                                    },
                                    sizeWidthNormal(width: 5.w),
                                    if (ugcLinks.length < 10 && index > 2)
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              ugcLinks.add("");
                                              controllers.add(TextEditingController());
                                              focusNode.add(FocusNode());
                                            });
                                          },
                                          child: Icon(Icons.add_circle,
                                              color: Colors.blue)),
                                  }
                                ],
                              ),
                            );
                          },
                        ),
                        sizeHeightNormal(height: 40.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: CustomElevatedButton(
                            text: widget.isEditUGC ? 'تعديل' : 'اشترك',
                            isDisabled: state is LoadingSubscribeToUgcState
                                ? true
                                : false,
                            onPressed: () {
                              setState(() {
                                if (selectedEmirate == null) {
                                  isSelectedEmirateError = true;
                                  return;
                                }

                                if (selectedCategory == null) {
                                  isSelectedCategoryError = true;
                                  return;
                                }

                                if (selectedGender == null) {
                                  isSelectedGenderError = true;
                                  return;
                                }
                                if (isMore3000 == null) {
                                  isSelectedMore3000 = true;
                                  return;
                                }
                              });

                              if(ugcLinks.isEmpty || controllers.every((controller) => controller.text.isEmpty)) {
                                SnackBarHelper.mySnackBarError(
                                    "يرجى إضافة رابط واحد على الأقل", context);
                                return;
                              }
                              UgcCubit.get(context).subscribeToUgc(
                                cityId: cityId!,
                                categoryUgcId: selectedCategoryId!,
                                gender: selectedGender!,
                                isMore3000: isMore3000!,
                                ugcLinks: controllers
                                    .map((controller) => controller.text)
                                    .where((text) => text.isNotEmpty)
                                    .toList(),
                              );
                            },
                            child: state is LoadingSubscribeToUgcState
                                ? loadingButton(

                            )
                                : null,
                          ),
                        )
                      } else ...{
                        Container(
                          height: 250.h,
                          child: BoothShimmer(),
                        ),
                      },
                    ],
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
