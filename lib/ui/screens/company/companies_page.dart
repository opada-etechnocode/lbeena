import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/company/company_model.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import '../../theme/lbeena_colors.dart';
import '../../theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/app_shimmer/custom_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/custom_search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/add_ad_new/cities_model.dart';
import '../../../data/models/company/activity_company_model.dart';
import '../../../data/models/profile_company/profile_company_model.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/main_parts_shimmer.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import 'company_details_page.dart';

class CompaniesPage extends StatefulWidget {
   CompaniesPage({super.key,this.isNeedBack =false});
bool isNeedBack =false;
  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage>with AutomaticKeepAliveClientMixin {
  int page = 1;
  int order = 0;
  List<ActivityCompanyList> activityCompanyList=[];
 int activityCompanyId =-1;
  @override
  bool get wantKeepAlive => true;
  Future<void> loadData() async {
    print("bbbbbbbbbbbbbbbb");
    HomeCubit.get(context).activityCompanyModel = await getCompaniesData();
    if (HomeCubit.get(context).activityCompanyModel != null) {
      print("activityCompanyModel : ${HomeCubit.get(context).activityCompanyModel!.data.length}");
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }

  bool isShowAllBanner = false;
  String? selectedEmara;
  int? cityId;
  String? cityName;

  String? selectedCategory;
  int? selectedSubCategoryId;
  int indexSubCategory =-1;
  bool isLoadingData =true;
  List<bool> isSelectAvailableList = List.generate(100, (index) => false);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final FocusNode _firstFocusNode = FocusNode();
  TextEditingController searchCompanyController = TextEditingController();


  @override
  void initState() {
    loadData();
    // if(HomeCubit.get(context).dataCompaniesList.isEmpty){
       HomeCubit.get(context).getCompanies(page: page,
          order: order);
    // }
    if(HomeCubit.get(context).citiesModel ==null){
      HomeCubit.get(context).getCity();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: Scaffold(
          appBar: appBarNormalWithIcon(
            text: 'الدليل',context: context,isShowBack: widget.isNeedBack),
          body: MultiBlocProvider(providers: [
              BlocProvider(
              create: (context) {
                if(HomeCubit.get(context).activityCompanyModel ==null){
                 return RegisterCubit()..getActivityCompany();
                }else{
                  activityCompanyList = HomeCubit.get(context).activityCompanyModel!.data;
                  return RegisterCubit()..getActivityCompany();
                }
              }),
            // BlocProvider(
            //   create: (context) => RegisterCubit()..getActivityCompany(),lazy: false,),
          ], child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                // if (state is SuccessCompaniesState) {
                //   data.addAll(state.companyModel.data!.companies!.data);
                // }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: SizedBox(
                        height: 44,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: CustomSearchView(
                                controller: searchCompanyController,
                                focusNode: _firstFocusNode,
                                hintText: 'ابحث في الدليل',
                                fillColor: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'
                                    ? LbeenaColors.cardDark
                                    : LbeenaColors.white,
                                textInputAction: TextInputAction.search,
                                contentPadding: const EdgeInsetsDirectional.only(
                                  start: 4,
                                  end: 12,
                                ),
                                prefixConstraints: const BoxConstraints.tightFor(
                                  width: 44,
                                  height: 44,
                                ),
                                borderDecoration: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                isDense: false,
                                prefix: const SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: 18,
                                      color: LbeenaColors.teal,
                                    ),
                                  ),
                                ),
                                onChanged: (_) {},
                                onFieldSubmitted: (v) {
                                  if (activityCompanyId == -1) {
                                    HomeCubit.get(context).searchCompanies(
                                      page: 1,
                                      order: order,
                                      title: v,
                                    );
                                  } else {
                                    HomeCubit.get(context).searchCompanies(
                                      page: 1,
                                      order: order,
                                      title: v,
                                      businessActivitiesId: activityCompanyId,
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                HomeCubit.get(context).dataCompaniesList.clear();
                                page = 1;
                                setState(() {
                                  order == 0 ? order = 1 : order = 0;
                                });
                                if (activityCompanyId == -1) {
                                  HomeCubit.get(context).searchCompanies(
                                    page: 1,
                                    order: order,
                                    title: searchCompanyController.text,
                                    isNeedClear: true,
                                    city_name: selectedEmara,
                                  );
                                  return;
                                }
                                HomeCubit.get(context).searchCompanies(
                                  page: 1,
                                  order: order,
                                  title: searchCompanyController.text,
                                  subcategory_id: selectedSubCategoryId,
                                  isNeedClear: true,
                                  city_name: selectedEmara,
                                  businessActivitiesId: activityCompanyId,
                                );
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: LbeenaColors.orange,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    order == 0
                                        ? FontAwesomeIcons.arrowDown
                                        : FontAwesomeIcons.arrowUp,
                                    size: 16,
                                    color: LbeenaColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                     BlocConsumer<RegisterCubit, RegisterStates>(
                    listener: (context,stateNew){
                      if(stateNew is SuccessActivityCompanyState){
                        activityCompanyList =stateNew.activityCompanyModel.data;
                      }
                    },
                      builder: (context,stateNew){
                      return stateNew is LoadingActivityCompanyState
                          ? SizedBox(
                              height: 42,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: 8,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return CustomShimmer(
                                    child: Container(
                                      width: 72,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : activityCompanyList.isEmpty
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  height: 42,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: activityCompanyList.length + 1,
                                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return _directoryChip(
                                          label: 'الكل',
                                          selected: activityCompanyId == -1,
                                          onTap: () {
                                            setState(() {
                                              for (int i = 0; i < isSelectAvailableList.length; i++) {
                                                isSelectAvailableList[i] = i == -1;
                                              }
                                              activityCompanyId = -1;
                                              selectedSubCategoryId = null;
                                              selectedCategory = null;
                                              cityId = null;
                                              selectedEmara = null;
                                              searchCompanyController.clear();
                                              HomeCubit.get(context).searchCompanies(
                                                page: 1,
                                                order: order,
                                                title: searchCompanyController.text,
                                              );
                                            });
                                          },
                                        );
                                      }
                                      final item = activityCompanyList[index - 1];
                                      return _directoryChip(
                                        label: item.name ?? '',
                                        selected: isSelectAvailableList[index - 1],
                                        onTap: () {
                                          setState(() {
                                            for (int i = 0; i < isSelectAvailableList.length; i++) {
                                              isSelectAvailableList[i] = i == index - 1;
                                            }
                                            indexSubCategory = index - 1;
                                            activityCompanyId = item.id!;
                                            selectedSubCategoryId = null;
                                            selectedCategory = null;
                                            cityId = null;
                                            selectedEmara = null;
                                            searchCompanyController.clear();
                                            HomeCubit.get(context).searchCompanies(
                                              page: 1,
                                              order: order,
                                              title: searchCompanyController.text,
                                              businessActivitiesId: activityCompanyId,
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                );
                    },),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: PopupMenuButton<Cities>(
                              color: appTheme.whiteA700,
                              onSelected: (Cities newValue) {
                                setState(() {
                                  selectedEmara = newValue.title;
                                  cityId = newValue.id!;
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                final cities = HomeCubit.get(context).citiesModel?.data ?? [];
                                return cities.map((Cities value) {
                                  return PopupMenuItem<Cities>(
                                    value: value,
                                    child: Text(value.title ?? '',
                                        style: Theme.of(context).textTheme.displaySmall),
                                  );
                                }).toList();
                              },
                              child: _filterPill(
                                icon: FontAwesomeIcons.locationDot,
                                label: selectedEmara ?? 'المدينة',
                              ),
                            ),
                          ),
                          if (indexSubCategory != -1 &&
                              activityCompanyList.isNotEmpty &&
                              activityCompanyList[indexSubCategory]
                                  .subcategories
                                  .isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: PopupMenuButton<SubCategoryModel>(
                                color: appTheme.whiteA700,
                                onSelected: (SubCategoryModel newValue) {
                                  setState(() {
                                    selectedCategory = newValue.title;
                                    selectedSubCategoryId = newValue.id;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return activityCompanyList[indexSubCategory]
                                      .subcategories
                                      .map((SubCategoryModel category) {
                                    return PopupMenuItem<SubCategoryModel>(
                                      value: category,
                                      child: Text(
                                        category.title ?? "غير معروف",
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    );
                                  }).toList();
                                },
                                child: _filterPill(
                                  icon: FontAwesomeIcons.layerGroup,
                                  label: selectedCategory ?? 'الصنف',
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          if (state is LoadingSearchCompaniesState)
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: Center(
                                child: LoadingAnimationWidget.fallingDot(
                                  size: 22,
                                  color: LbeenaColors.teal,
                                ),
                              ),
                            )
                          else
                            InkWell(
                              onTap: () {
                                page = 1;
                                if (activityCompanyId != -1) {
                                  HomeCubit.get(context).searchCompanies(
                                    page: 1,
                                    order: order,
                                    title: searchCompanyController.text,
                                    subcategory_id: selectedSubCategoryId,
                                    city_name: selectedEmara,
                                    businessActivitiesId: activityCompanyId,
                                  );
                                } else {
                                  HomeCubit.get(context).searchCompanies(
                                    page: 1,
                                    order: order,
                                    title: searchCompanyController.text,
                                    city_name: selectedEmara,
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: LbeenaColors.orange,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${HomeCubit.get(context).dataCompaniesList.length}',
                                      style: const TextStyle(
                                        color: LbeenaColors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'عرض',
                                      style: TextStyle(
                                        color: LbeenaColors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),


                    Expanded(
                      child: SmartRefreshWidget(
                        onRefresh: () async {
                          HomeCubit.get(context).dataCompaniesList.clear();
                          RegisterCubit.get(context).getActivityCompany();
                          page = 1;
                       selectedEmara=null;
                         cityId=null;
                           cityName=null;
searchCompanyController.clear();
                          for (int i = 0; i < isSelectAvailableList.length; i++) {
                            isSelectAvailableList[i] = i == -1;

                          }
                          activityCompanyId = -1;
                       selectedCategory=null;
                          selectedSubCategoryId=null;
                           indexSubCategory =-1;
                          await HomeCubit.get(context).getCompanies(page: page,order: order,
                          );
                          setState(() {});
                          _refreshController.refreshCompleted();
                        },
                        controller: _refreshController,
                        onLoading: () async {
                          page++;
                          if(searchCompanyController.text.isNotEmpty)
                          {
                            await HomeCubit.get(context).searchCompanies(page: page,order: order,isLoadingActive: false,title: searchCompanyController.text,businessActivitiesId: activityCompanyId);

                          }else {
                            await HomeCubit.get(context).getCompanies(page: page,order: order,isLoadingActive: false);

                          }
                          setState(() {});
                          _refreshController.loadComplete();
                        },
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 120),
                            child: Column(
                              children: [
                                activityCompanyList.length==0 ||activityCompanyId ==-1?Container():  activityCompanyList[indexSubCategory].banner_image !=null ?   bannerItem(activityCompanyList[indexSubCategory].banner_image):Container(),

                                HomeCubit.get(context).dataCompaniesList.length ==0 && !HomeCubit.get(context).isLoadingCompanyList?
                                  Padding(
                                    padding: const EdgeInsets.only(top: 80),
                                    child: Column(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.addressBook,
                                          size: 36,
                                          color: LbeenaColors.teal.withOpacity(0.45),
                                        ),
                                        const SizedBox(height: 12),
                                        textNormal(
                                          text: 'لا توجد شركات متاحة للعرض',
                                          fontSize: AppFontSize.fontSize_14,
                                          color: LbeenaColors.muted,
                                        ),
                                      ],
                                    ),
                                  ):Container(),
                                GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: isTypeIpad(context) ? 300.h : 228,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:HomeCubit.get(context).isLoadingCompanyList?10: HomeCubit.get(context).dataCompaniesList.length,
                                    itemBuilder: (context, index) {
                                      return HomeCubit.get(context).dataCompaniesList.length ==0&& HomeCubit.get(context).isLoadingCompanyList?
                                      Shimmer.fromColors(
                                          baseColor: appTheme.baseColorShimmer,
                                          highlightColor: appTheme.highlightColorShimmer,
                                          child:  CompanayWidgetShimmer()):
                                      CompanayWidget(
                                          data: HomeCubit.get(context).dataCompaniesList[index]
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),



                    if (state
                    is LoadingCompaniesPagState) ...[
                      Padding(
                        padding:  EdgeInsets.only(bottom: 70.h),
                        child: Center(
                          child: Container(
                              width: 20.h,
                              height: 20.h,

                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }
          ),)
        ),
      ),
    );
  }

  Widget _directoryChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? LbeenaColors.teal
              : (isDark ? LbeenaColors.cardDark : LbeenaColors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? LbeenaColors.teal : LbeenaColors.fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? LbeenaColors.white : LbeenaColors.teal,
          ),
        ),
      ),
    );
  }

  Widget _filterPill({required FaIconData icon, required String label}) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LbeenaColors.fieldBorder),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 12, color: LbeenaColors.orange),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: appTheme.black900,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: LbeenaColors.muted, size: 18),
        ],
      ),
    );
  }

  Widget CompanayWidget({
    required CompaniesListModel data,
  }) {
    final mapLink = data.links.firstWhere(
      (link) =>
          (link.url?.toLowerCase().contains("google") ?? false) ||
          (link.url?.toLowerCase().contains("maps") ?? false),
      orElse: () => LinkSocialMedia(id: null, name: '', url: null),
    );
    final image = data.profilePic.toString() == 'null'
        ? ImageConstant.imgPerson
        : data.profilePic.toString().contains('http')
            ? '${data.profilePic}'
            : '${AppEndpoints.baseUrlWithoutApi}${data.profilePic}';
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CompanyDetailsPage(
            idCompany: data.id!,
          );
        }));
      },
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: LbeenaColors.fieldBorder),
          boxShadow: [
            BoxShadow(
              color: LbeenaColors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: LbeenaColors.orange, width: 2),
                      ),
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: image,
                          fit: BoxFit.cover,
                          color: data.profilePic.toString() == 'null'
                              ? LbeenaColors.teal
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: mapIcon(mapLink),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.companyName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: LbeenaColors.teal,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: LbeenaColors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'عضوية ${data.membershipNumber ?? '-'}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: LbeenaColors.orange,
                  ),
                ),
              ),
              if ((data.business_activities_name ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  data.business_activities_name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: appTheme.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (data.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  data.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: appTheme.black900,
                  ),
                ),
              ],
              const Spacer(),
              iconsSocialMedia(data.links),
            ],
          ),
        ),
      ),
    );
  }

  List<String> iconsSocial=[
    ImageConstant.facebookIcon,
    ImageConstant.instagramIcon,
    ImageConstant.tiktokIcon,
    ImageConstant.webIcon,
    // ImageConstant.gpsIcon,
  ];
  Widget mapIcon(LinkSocialMedia? mapLink) {
    final hasMap = mapLink?.url?.trim().isNotEmpty ?? false;

    return InkWell(
      onTap: hasMap
          ? () async {
              final url = mapLink!.url!;
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              }
            }
          : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: hasMap
              ? LbeenaColors.orange.withOpacity(0.15)
              : Colors.grey.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.locationDot,
            size: 12,
            color: hasMap ? LbeenaColors.orange : Colors.grey,
          ),
        ),
      ),
    );
  }
  String? getIconForUrl(String url) {
    url = url.toLowerCase();

    if (url.contains('facebook')) return ImageConstant.facebookIcon;
    if (url.contains('instagram')) return ImageConstant.instagramIcon;
    if (url.contains('tiktok')) return ImageConstant.tiktokIcon;
    if (url.contains('web') || url.contains('http')) return ImageConstant.webIcon;

    return null; // إذا الرابط غير معروف
  }
  Widget iconsSocialMedia(List<LinkSocialMedia> linksCompany) {
    final filteredLinks = linksCompany.where((link) {
      final url = link.url?.toLowerCase() ?? '';
      return !(url.contains("google") || url.contains("maps"));
    }).toList();

    // إنشاء قائمة الروابط بحسب نوع كل منصة
    Map<String, String?> matchedLinks = {
      'facebook': null,
      'instagram': null,
      'tiktok': null,
      'web': null,
    };

    for (var link in filteredLinks) {
      final url = link.url?.toLowerCase() ?? '';
      if (url.contains('facebook')) matchedLinks['facebook'] = link.url;
      else if (url.contains('instagram')) matchedLinks['instagram'] = link.url;
      else if (url.contains('tiktok')) matchedLinks['tiktok'] = link.url;
      else if (url.contains('http') || url.contains('www')) matchedLinks['web'] = link.url;
    }

    // قائمة الأيقونات حسب الترتيب المطلوب
    final List<Map<String, dynamic>> iconsSocial = [
      {
        'type': 'facebook',
        'icon': FontAwesomeIcons.facebook,
      },
      {
        'type': 'instagram',
        'icon': FontAwesomeIcons.instagram,
      },
      {
        'type': 'tiktok',
        'icon': FontAwesomeIcons.tiktok,
      },
      {
        'type': 'web',
        'icon': FontAwesomeIcons.globe,
      },
    ];

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconsSocial.map((item) {
          final platform = item['type'] as String;
          final icon = item['icon'] as FaIconData;
          final url = matchedLinks[platform];
          final hasLink = url != null && url.trim().isNotEmpty;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: hasLink
                  ? () async {
                      if (await canLaunchUrl(Uri.parse(url!))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
                    }
                  : null,
              child: FaIcon(
                icon,
                size: 14,
                color: hasLink ? LbeenaColors.teal : Colors.grey.shade400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget CompanayWidgetShimmer(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
  String getDate({
    required DateTime date
  }){
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
