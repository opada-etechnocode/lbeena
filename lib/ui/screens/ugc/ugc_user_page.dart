import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/app_general_bloc/handel_android_app.dart';
import 'package:syrians_in_uae/ui/screens/ugc/cubit/ugc_cubit.dart';
import 'package:syrians_in_uae/ui/screens/ugc/widget/subscribe_ugc.dart';
import 'package:syrians_in_uae/ui/screens/ugc/widget/user_card_widget.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/add_ad_new/cities_model.dart';
import '../../../data/models/ugc/ugc_category_model.dart';
import '../../../data/models/ugc/ugc_users_model.dart';
import '../../../widgets/BoothShimmer.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../auth/login/model_home_page.dart';
import '../company/company_details_page.dart';
import '../home/cubit/cubit.dart';
import 'cubit/ugc_state.dart';

class UGCUsersPage extends StatefulWidget {
  UGCUsersPage({
    super.key,
    required this.dateHomePage,
  });

  HomePageLoginModel dateHomePage;

  @override
  State<UGCUsersPage> createState() => _UGCUsersPageState();
}

class _UGCUsersPageState extends State<UGCUsersPage>
    with SingleTickerProviderStateMixin {
  bool isLoadingUgcUsers = true;
  bool isLoadingUgcCategory = true;
  List<UgcUsersData> ugcUserList = [];
  List<UgcCategoryData> ugcCategoryList = [];
  String? selectedEmirate;
  int? cityId;
  int page = 1;
  String? selectedCategory;
  String? selectedGender;
  int? selectedCategoryId;
  bool isSelectedEmirateError = false;
  bool isSelectedCategoryError = false;
  bool isSelectedGenderError = false;
  bool isSelectedMore3000 = false;
  int isMore3000 = -1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: HandelAndroidApp(
        child: Scaffold(
          appBar: appBarNormalWithIcon(
              text: 'UGC', context: context, isShowBack: true),
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UgcCubit()
                  ..getUgcUsers(page: 1)
                  ..getUgcCategory(),
              ),
              BlocProvider(
                create: (context) =>
                    HomeCubit()..getCategoryMainAndSubCategory(),
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
                if (state is LoadingUgcUsersState) {
                  isLoadingUgcUsers = true;
                }
                if (state is SuccessUgcUsersState) {
                  isLoadingUgcUsers = false;
                  ugcUserList.addAll(state.ugcUsersModel!.data);
                }
                if (state is LoadingSearchUgcUsersState) {
                  isLoadingUgcUsers = true;
                  ugcUserList.clear();
                }

                if (state is ErrorSearchUgcUsersState) {
                  isLoadingUgcUsers = false;
                }
                if (state is SuccessSearchUgcUsersState) {
                  isLoadingUgcUsers = false;
                  ugcUserList.addAll(state.ugcUsersModel!.data);
                }
                if (state is ErrorUgcUsersState) {
                  isLoadingUgcUsers = false;
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Column(
                        children: [
                          _buildAppBarCoupons(context),
                          sizeHeightNormal(height: 5.h),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.6,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: PopupMenuButton<Cities>(
                                          color: appTheme.whiteA700,
                                          onSelected: (Cities newValue) {
                                            setState(() {
                                              selectedEmirate = newValue.title;
                                              cityId = newValue.id!;
                                              isSelectedEmirateError = false;
                                              print(
                                                  "$selectedEmirate : $cityId");
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
                                            decoration: AppDecoration
                                                .dropdownButtonChoose
                                                .copyWith(
                                                    color:
                                                        appTheme.whiteA700),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            height: 26.h,
                                            // width: 90.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  selectedEmirate ??
                                                      "اختر الإمارة",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                          color:
                                                              isSelectedEmirateError
                                                                  ? Colors.red
                                                                  : appTheme
                                                                      .black900),
                                                ),
                                                Icon(Icons.arrow_drop_down),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: PopupMenuButton<UgcCategoryData>(
                                          color: appTheme.whiteA700,
                                          onSelected:
                                              (UgcCategoryData newValue) {
                                            setState(() {
                                              selectedCategory = newValue.name;
                                              selectedCategoryId = newValue.id!;
                                              isSelectedCategoryError = false;
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return ugcCategoryList
                                                .map((UgcCategoryData data) {
                                              return PopupMenuItem<
                                                  UgcCategoryData>(
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
                                            decoration: AppDecoration
                                                .dropdownButtonChoose
                                                .copyWith(
                                                    color:
                                                        appTheme.whiteA700),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            height: 26.h,
                                            // width: 90.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  selectedCategory ??
                                                      "اختر صنف المحتوى",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                          color:
                                                              isSelectedCategoryError
                                                                  ? Colors.red
                                                                  : appTheme
                                                                      .black900),
                                                ),
                                                Icon(Icons.arrow_drop_down),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
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
                                            decoration: AppDecoration
                                                .dropdownButtonChoose
                                                .copyWith(
                                                    color:
                                                        appTheme.whiteA700),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            height: 26.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                          color:
                                                              isSelectedGenderError
                                                                  ? Colors.red
                                                                  : appTheme
                                                                      .black900),
                                                ),
                                                Icon(Icons.arrow_drop_down),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: PopupMenuButton<int>(
                                          color: appTheme.whiteA700,
                                          onSelected: (int newValue) {
                                            setState(() {
                                              isMore3000 = newValue;
                                              isSelectedMore3000 = false;
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              PopupMenuItem<int>(
                                                value: -1,
                                                child: Text(
                                                  "الكل",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: Text(
                                                  "أكثر أو يساوي 3000 متابع",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 0,
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
                                            decoration: AppDecoration
                                                .dropdownButtonChoose
                                                .copyWith(
                                                    color:
                                                        appTheme.whiteA700),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            height: 26.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  (isMore3000 == 1
                                                      ? "أكثر أو يساوي 3000 متابع"
                                                      : isMore3000 == 0
                                                          ? "أقل من 3000 متابع"
                                                          : "عدد المتابعين (الكل)"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                          color:
                                                              isSelectedMore3000
                                                                  ? Colors.red
                                                                  : appTheme
                                                                      .black900),
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
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  children: [
                                    textNormal(
                                        text: ugcUserList.length.toString(),
                                        fontSize: 10.fSize),
                                    sizeWidthNormal(),
                                    CustomElevatedButton(
                                      text: 'عرض النتائج',
                                      height: 25.h,
                                      width: 77.w,
                                      isDisabled:
                                          state is LoadingSearchUgcUsersState
                                              ? true
                                              : false,
                                      onPressed: () {
                                        ugcUserList.clear();
                                        if (searchController.text.isEmpty) {
                                          UgcCubit.get(context).searchUgcUsers(
                                            page: pageSearch,
                                            cityId: cityId,
                                            categoryUgcId: selectedCategoryId,
                                            gender: selectedGender,
                                            isMore3000: isMore3000,
                                          );
                                        } else {
                                          UgcCubit.get(context).searchUgcUsers(
                                            page: pageSearch,
                                            cityId: cityId,
                                            categoryUgcId: selectedCategoryId,
                                            gender: selectedGender,
                                            search: searchController.text,
                                            isMore3000: isMore3000,
                                          );
                                        }
                                      },
                                      buttonStyle: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                appTheme.deepPurpleA10001),
                                      ),
                                      buttonTextStyle: themeLite
                                          .textTheme.bodySmall!
                                          .copyWith(fontSize: 10.fSize, color: Colors.white,),
                                      child: state is LoadingSearchUgcUsersState
                                          ? LoadingAnimationWidget.fallingDot(
                                              size: 25,
                                              color: appTheme.whiteA700)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isLoadingUgcUsers) ...{
                      Expanded(
                        flex: 2,
                        child: SmartRefreshWidget(
                          onRefresh: () async {
                            page = 1;
                            pageSearch = 1;
                            cityId = null;
                            selectedCategoryId = null;
                            selectedCategory = null;
                            selectedGender = null;
                            selectedEmirate = null;

                            searchController.text = '';
                            ugcUserList.clear();
                            UgcCubit.get(context).getUgcUsers(page: 1);
                            setState(() {});
                            _refreshController.refreshCompleted();
                          },
                          controller: _refreshController,
                          onLoading: () async {
                            page++;
                            bool shouldSearch = cityId != null ||
                                selectedCategoryId != null ||
                                selectedGender != null ||
                                (searchController.text.isNotEmpty);
                            if (shouldSearch) {
                              pageSearch++;
                              UgcCubit.get(context).searchUgcUsers(
                                  page: pageSearch,
                                  cityId: cityId,
                                  categoryUgcId: selectedCategoryId,
                                  gender: selectedGender,
                                  search: searchController.text,
                                  isMore3000: isMore3000,
                                  isLoading: false);
                            } else {
                              UgcCubit.get(context)
                                  .getUgcUsers(page: page, isLoading: false);
                            }
                            setState(() {});
                            _refreshController.loadComplete();
                          },
                          child: ugcUserList.isEmpty
                              ? Center(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    textNormal(
                                        text: 'لا يوجد مستخدمين بعد ..',
                                        fontSize: 12.fSize),
                                    if (DIManager.findDep<SharedPrefs>()
                                                .getToken() !=
                                            null &&
                                        DIManager.findDep<SharedPrefs>()
                                                .getAccountType() ==
                                            'individual' &&
                                        DIManager.findDep<SharedPrefs>()
                                                .getStatusUGC() ==
                                            false)
                                      Center(
                                          child: SubscribeUGCWidget(
                                        dateHomePage: widget.dateHomePage,
                                      ))
                                  ],
                                ))
                              : DIManager.findDep<SharedPrefs>().getToken() !=
                                          null &&
                                      DIManager.findDep<SharedPrefs>()
                                              .getAccountType() ==
                                          'individual' &&
                                      DIManager.findDep<SharedPrefs>()
                                              .getStatusUGC() ==
                                          false
                                  ? ListView(
                                      shrinkWrap: true,
                                      children: [
                                        if (ugcUserList.isEmpty)
                                          Center(
                                              child: SubscribeUGCWidget(
                                            dateHomePage: widget.dateHomePage,
                                          )) // عرض زر الاشتراك إذا لم يكن هناك عناصر
                                        else ...[
                                          for (int i = 0;
                                              i < ugcUserList.length;
                                              i++) ...[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 10.w),
                                              child: InkWell(
                                                onTap: () {
                                                  navigatorToPush(
                                                    context: context,
                                                    pageName:
                                                        CompanyDetailsPage(
                                                      idCompany: ugcUserList[i]
                                                          .userId!,
                                                    ),
                                                  );
                                                },
                                                child: UserCardWidget(
                                                  data: ugcUserList[i],
                                                ),
                                              ),
                                            ),
                                            if (ugcUserList.length == 1)
                                              SubscribeUGCWidget(
                                                dateHomePage:
                                                    widget.dateHomePage,
                                              ),
                                            if (i == 1 &&
                                                ugcUserList.length > 1)
                                              SubscribeUGCWidget(
                                                dateHomePage:
                                                    widget.dateHomePage,
                                              ),
                                          ]
                                        ]
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: ugcUserList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 10.w),
                                          child: InkWell(
                                            onTap: () {
                                              navigatorToPush(
                                                  context: context,
                                                  pageName: CompanyDetailsPage(
                                                    idCompany:
                                                        ugcUserList[index]
                                                            .userId!,
                                                  ));
                                            },
                                            child: UserCardWidget(
                                              data: ugcUserList[index],
                                            ),
                                          ),
                                        );
                                      }),
                        ),
                      ),
                    } else ...{
                      SizedBox(
                        height: 250.h,
                        child: const BoothShimmer(),
                      ),
                    },
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController searchController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  int pageSearch = 1;

  Widget _buildAppBarCoupons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8.w, left: 10.w),
            child: CustomSearchView(
              autofocus: false,
              controller: searchController,
              focusNode: _firstFocusNode,
              borderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.h),
                borderSide: BorderSide.none,
              ),
              hintText: "ابحث عن مستخدم، رقم عضوية، مدينة، صنف ..",
              onChanged: (value) {},
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _startAnimation();
            page = 1;
            pageSearch = 1;
            cityId = null;
            selectedCategoryId = null;
            selectedCategory = null;
            selectedGender = null;
            selectedEmirate = null;

            searchController.text = '';
            ugcUserList.clear();
            UgcCubit.get(context).getUgcUsers(page: 1);
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.1415927, // 360° دوران
                child: child,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 29.w),
              child: Icon(Icons.refresh, color: appTheme.greenColor, size: 25),
            ),
          ),
        )
      ],
    );
  }

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  void _startAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
