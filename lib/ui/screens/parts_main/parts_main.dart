import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/home_page/categorie_part.dart';
import 'package:syrians_in_uae/data/models/home_page/categories_main.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_page_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/add_ad_new/category_details_model.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/add_ad_new/cities_model.dart';
import '../../../data/models/home_page/banner_product_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/main_parts_widget.dart';
import '../../../widgets/ads_product_widget.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../widget/url_webview.dart';
import '../details_product/details_product.dart';

class PartsMainNewPage extends StatefulWidget {
  PartsMainNewPage({
    super.key,
    required this.idCategoryPart,
    required this.titleAppBar,
    required this.subcategories,
  });

  final int idCategoryPart;
  String? titleAppBar;
  List<SubCategoryModel> subcategories;

  @override
  State<PartsMainNewPage> createState() => _PartsMainNewPageState();
}

class _PartsMainNewPageState extends State<PartsMainNewPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _showWordTimer() async {
    _showWord = true;
    await Future.delayed(Duration(milliseconds: 1500));
    _showWord = false;
    if (mounted) setState(() {});
    _refreshController.resetNoData();
  }

  int page = 1;

  List<Video> videoList = [];
  List<DataProductBannerModel> adsList = [];
  bool _showWord = false;
  bool isShowAllBanner = false;
  String? selectedEmara;
  int? cityId;
  bool isLoadingData = true;

  @override
  Widget build(BuildContext context) {
    print(
        'PartsMainNewPage: ____________________________________________________________');
    print(
        'PartsMainNewPage: package:syrians_in_uae/ui/screens/parts_main/parts_main.dart');
    print(widget.idCategoryPart);
    print(
        'PartsMainNewPage: ____________________________________________________________');

    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(
            text: widget.titleAppBar!, context: context, isShowBack: true),
        body: BlocProvider(
          create: (context) => HomeCubit()
            ..getCategoriesPartsNewApi(
                idCategoryPart: widget.idCategoryPart, page: page)
            ..getCategoryMainAndSubCategory(),
          child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {
              if (state is SuccessCategoriesPartsNewState) {
                isLoadingData = false;
                categoriesPartModel = state.categoriesPartsModel;
                dataBannerList.addAll(state.categoriesPartsModel.adsBanner!.data!.data);
                if (state.categoriesPartsModel.adsProduct!.data.isEmpty) {
                  _showWordTimer();
                } else {
                  adsList.addAll(state.categoriesPartsModel.adsProduct!.data);
                }
              }
              if (state is ErrorCategoriesPartsState) {
                isLoadingData = false;
              }
              if (state is LoadingCategoriesPartsState) {
                isLoadingData = true;
              }

              if (state is SuccessFilterCategoriesPartsState) {
                // isLoadingData =false;
                if (state.categoriesPartsModel.adsProduct!.data.isEmpty) {
                  if (page == 1) {
                    adsList.clear();
                  }
                  _showWordTimer();
                } else {
                  if (page == 1) {
                    adsList.clear();
                  }
                  adsList.addAll(state.categoriesPartsModel.adsProduct!.data);
                }
              }
              if (state is ErrorFilterCategoriesPartsState) {
                // isLoadingData =false;
              }
              if (state is LoadingFilterCategoriesState) {
                // isLoadingData =true;
              }
            },
            builder: (context, state) {
              return SmartRefreshWidget(
                onRefresh: () async {
                  page = 1;
                  adsList.clear();
                  dataBannerList.clear();
                  isFilter = false;
                  await HomeCubit.get(context).getCategoriesPartsNewApi(
                      idCategoryPart: widget.idCategoryPart, page: 1);
                  setState(() {
                    isShowAllBanner = false;
                  });
                  _refreshController.refreshCompleted();
                },
                controller: _refreshController,
                onLoading: () async {
                  page++;
                  isLoadingData = false;
                  if (isFilter) {
                    await HomeCubit.get(context).filterCategoriesPartsNewApi(
                        idCategory: widget.idCategoryPart,
                        idSubCategory: categoriesLastId,
                        idCity: cityId,
                        page: page,
                        isLoading: false);
                  } else {
                    await HomeCubit.get(context).getCategoriesPartsNewApi(
                        idCategoryPart: widget.idCategoryPart,
                        page: page,
                        isLoading: false);
                  }

                  setState(() {});
                  _refreshController.loadComplete();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      sizeHeightNormal(),
                      if (isLoadingData) ...[
                        const CustomPageShimmer(),
                      ] else ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.6,
                                    height: 40.h,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            child: PopupMenuButton<Cities>(
                                              color: appTheme.whiteA700,
                                              onSelected: (Cities newValue) {
                                                setState(() {
                                                  selectedEmara =
                                                      newValue.title;
                                                  cityId = newValue.id!;
                                                });
                                                print('cityId: $cityId');
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return HomeCubit.get(context)
                                                    .citiesModel!
                                                    .data
                                                    .map((Cities value) {
                                                  return PopupMenuItem<Cities>(
                                                    value: value,
                                                    child: Text(
                                                        value.title ?? '',
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
                                                        color: appTheme
                                                            .whiteA700),
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
                                                        selectedEmara ??
                                                            "اختر الإمارة",
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            child: PopupMenuButton<
                                                SubCategoryModel>(
                                              color: appTheme.whiteA700,
                                              onSelected:
                                                  (SubCategoryModel newValue) {
                                                setState(() {
                                                  selectedCategory = newValue
                                                      .title; // قم بتخزين العنوان أو الكائن كما تحتاج
                                                  isHaveSubCategory = newValue
                                                      .hasSubcategory!; // قم بتخزين العنوان أو الكائن كما تحتاج
                                                  subCategoryList =
                                                      newValue.subcategories;
                                                  selectedCategories = [];
                                                  currentCategories = [];
                                                  categoriesId.clear();
                                                  havePrice =
                                                      newValue.have_price;
                                                  print('havePrice $havePrice');
                                                  if (categoriesId.contains(
                                                      newValue.categoryId
                                                          .toString())) {
                                                    categoriesId.remove(newValue
                                                        .categoryId
                                                        .toString());
                                                    print(
                                                        'categoriesId :$categoriesId');
                                                  } else {
                                                    categoriesId.add(newValue
                                                        .categoryId
                                                        .toString());
                                                    print(
                                                        'categoriesId :$categoriesId');
                                                  }
                                                  int selectedIndex = widget
                                                      .subcategories
                                                      .indexOf(newValue);

                                                  indexList = selectedIndex;
                                                  categoriesLastId =
                                                      newValue.categoryId;
                                                  print(
                                                      'categoriesLastId : $categoriesLastId');
                                                });
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return widget.subcategories.map(
                                                    (SubCategoryModel
                                                        category) {
                                                  return PopupMenuItem<
                                                      SubCategoryModel>(
                                                    value: category,
                                                    child: Text(
                                                      category.title ??
                                                          "غير معروف",
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
                                                        color: appTheme
                                                            .whiteA700),
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
                                                          "اختر الصنف",
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
                                          HomeCubit.get(context)
                                                          .categoriesAddPostModel ==
                                                      null ||
                                                  categoriesId.isEmpty
                                              ? Container()
                                              : ListView(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 7.h),
                                                      child: buildPopupMenu(
                                                        widget.subcategories[
                                                            indexList],
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
                                  Spacer(),
                                  (state is LoadingFilterCategoriesState)
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child:
                                              LoadingAnimationWidget.fallingDot(
                                                  size: 25,
                                                  color: appTheme.greenColor),
                                        )
                                      : Row(
                                          children: [
                                            textNormal(
                                                text: adsList.length.toString(),
                                                fontSize: 10.fSize),
                                            sizeWidthNormal(),
                                            CustomElevatedButton(
                                              text: 'عرض النتائج',
                                              height: 25.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.2,
                                              onPressed: () {
                                                page = 1;
                                                setState(() {
                                                  isFilter = true;
                                                });
                                                BlocProvider.of<HomeCubit>(
                                                        context)
                                                    .filterCategoriesPartsNewApi(
                                                        idCategory: widget
                                                            .idCategoryPart,
                                                        idSubCategory:
                                                            categoriesLastId,
                                                        idCity: cityId,
                                                        page: 1);
                                              },
                                              buttonStyle: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(appTheme
                                                            .deepPurpleA10001),
                                              ),
                                              buttonTextStyle: themeLite
                                                  .textTheme.bodySmall!
                                                  .copyWith(fontSize: 10.fSize, color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              categoriesPartModel == null
                                  ? Container()
                                  : dataBannerList.isNotEmpty
                                      ? _buildBannerItem(
                                          context,dataBannerList)
                                      : Container(),
                              categoriesPartModel == null
                                  ? Container()
                                  : _buildAdsItems(context,
                                      adsProduct: adsList),
                              adsList.isNotEmpty && _showWord
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: 20.h,
                                      ),
                                      child: textNormal(
                                          text: 'لايوجد إعلانات أكثر',
                                          color: appTheme.buttonColor),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool isFilter = false;
  CategoriesDetailsModel? categoriesPartModel;
  List<DataProductBannerModel> dataBannerList = [];
  Product? banner;
  bool isHaveSubCategory = false;

  /// Section Widget
  int? havePrice;
  List? selectedCategoriesNew = [];
  String? selectedCategory;
  int indexListNew = 0;
  int indexList = 0;
  List<SubCategoryModel>? subCategoryList;
  Map<int, int> indexMap =
      {}; // لتخزين الفهرس لكل عنصر بناءً على count_id أو id
  Map<int, int> counterIdAndCategoriesId =
      {}; // لتخزين الفهرس لكل عنصر بناءً على count_id أو id
  Set<int> currentCategoriesIds = {}; // لتخزين معرفات الفئات الفرعية
  int? count_id;
  List<SubCategoryModel> selectedCategories =
      []; // List of selected subcategories
  List<SubCategoryModel> currentCategories =
      []; // List of currently displayed categories
  List<String> categoriesId = [];
  int? categoriesLastId;

  List<String> categoriesCounterId = [];

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

            categoriesLastId = newValue.categoryId;

            print("categoriesLastId $categoriesLastId");
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
          decoration: AppDecoration.dropdownButtonChoose
              .copyWith(color: appTheme.whiteA700),
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

  /// Section Widget
  Widget _buildAdsItems(
    BuildContext context, {
    required List<DataProductBannerModel> adsProduct,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (adsProduct.isEmpty) ...{
          sizeHeightNormal(height: MediaQuery.of(context).size.height / 3),
          textNormal(text: 'لا يوجد إعلانات في القسم')
        },
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: adsProduct.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  navigatorToPush(
                      context: context,
                      pageName: DetailsProduct(
                        detailsProduct: adsProduct[index],
                        categoryId: adsProduct[index].categoryId.toString(),
                        adsName: adsProduct[index].name,
                        idAds: adsProduct[index].adsId.toString(),
                        idBannerOrProduct: int.parse(adsProduct[index].adsId!),
                        idAdOnwerCompany: int.parse(adsProduct[index].userId!),
                      ));
                },
                child: AdsProductWidget(
                  dataProductItem: adsProduct[index],
                ));
          },
        ),
        adsProduct.isNotEmpty ? sizeHeightNormal(height: 10.h) : Container(),
      ],
    );
  }

  /// Section Widget
  Widget _buildBannerItem(
      BuildContext context, List<DataProductBannerModel> dataBanner) {
    return Column(
      children: [
        dataBanner.length == 1
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: InkWell(
                  onTap: () {
                    if (dataBanner[0].inOut == '1') {
                      final Uri url = Uri.parse(dataBanner[0].url.toString());
                      launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      navigatorToPush(
                          context: context,
                          pageName: DetailsProduct(
                            detailsProductFromBanner: dataBanner[0],
                            isBanner: true,
                            adsName: dataBanner[0].name,
                            idAds: dataBanner[0].adsId.toString(),
                            categoryId: dataBanner[0].categoryId.toString(),
                            idBannerOrProduct:
                                int.parse(dataBanner[0].bannerId!),
                            idAdOnwerCompany: int.parse(dataBanner[0].userId!),
                          ));
                    }
                  },
                  child: Container(
                    // width: 350.w,
                    height: 140.h,
                    // margin: EdgeInsets.only(left: 2.h, right: 2.h),
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: 15.h,
                    //   vertical: 1.v,
                    // ),
                    decoration: AppDecoration.fillWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder7,
                      color: appTheme.lightBlue100,
                    ),
                    child: CustomImageView(
                      imagePath: dataBanner[0].image.toString().contains('http')
                          ? dataBanner[0].image.toString()
                          : AppEndpoints.baseUrlWithoutApi +
                              dataBanner[0].image.toString(),
                      width: MediaQuery.of(context).size.width,
                      height: 140.h,
                      alignment: Alignment.center,
                      radius: BorderRadius.circular(
                        7.r,
                      ),
                      fit: BoxFit.cover,
                      placeHolder: ImageConstant.imgLogoApp,
                    ),
                  ),
                ),
              )
            : CarouselSlider.builder(
                itemCount: dataBanner.length,
                itemBuilder: (context, index, realIndex) {
                  return buildBannerItem(context, dataBanner[index]);
                },
                options: CarouselOptions(
                  height: 150.h,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {},
                ),
              ),
        sizeHeightNormal(height: 15.h),
      ],
    );
  }
}
