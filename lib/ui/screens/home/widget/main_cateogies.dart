import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../data/models/add_ad_new/category_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/main_parts_shimmer.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../parts_main/parts_main.dart';
import '../../search/cubit/search_cubit.dart';

class MainCategories extends StatefulWidget {
  MainCategories(
      {super.key,
      this.isFromSearchPage = false,
      required this.categoriesMainModel});

  CategoriesAddPostModel? categoriesMainModel;
  bool isFromSearchPage = false;

  @override
  State<MainCategories> createState() => _MainCategoriesState();
}

class _MainCategoriesState extends State<MainCategories> {
  // تغيير هنا: جعل العنصر الأول (-1) هو المحدد افتراضيًا
  List<bool> isSelectAvailableList = List.generate(100, (index) => index == -1);

  @override
  void initState() {
    super.initState();

    if (widget.isFromSearchPage) {
      SearchCubit.get(context).categoryId = -1;
      SearchCubit.get(context).getSearchItem(
        title: SearchCubit.get(context).searchController.text,
        page: 1,
        clearDate: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.categoriesMainModel == null
        ? MainPartsShimmer(
            isFromAddAds: widget.isFromSearchPage,
          )
        : widget.isFromSearchPage? mainCategoriesSearch(): mainCategories();
    ;
  }

  Widget mainCategoriesSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        // تغيير هنا: تحديد "الكل" وإلغاء تحديد الباقي
                        for (int i = 0; i < isSelectAvailableList.length; i++) {
                          isSelectAvailableList[i] = i == -1;
                        }
                      });
                      SearchCubit.get(context).categoryId = -1;
                      SearchCubit.get(context).getSearchItem(
                        title: SearchCubit.get(context).searchController.text,
                        page: 1,
                        clearDate: true,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          height: 40.h,
                          decoration: AppDecoration.outlineButton.copyWith(
                            color: SearchCubit.get(context).categoryId == -1
                                ? appTheme.deepPurpleA100
                                : DIManager.findDep<SharedPrefs>()
                                            .getThemeApp() ==
                                        'd'
                                    ? appTheme.lightBlue100
                                    : Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Center(
                                child: textNormal(
                              text: 'الكل',
                            )),
                          )),
                    ),
                  ),
                for (int index = 0;
                    index < widget.categoriesMainModel!.data.length;
                    index++) ...{
                  InkWell(
                    onTap: () {
                      if (widget.isFromSearchPage) {
                        setState(() {
                          for (int i = 0;
                              i < isSelectAvailableList.length;
                              i++) {
                            isSelectAvailableList[i] = i == index;
                          }
                        });

                        SearchCubit.get(context).categoryId =
                            widget.categoriesMainModel!.data[index].categoryId;
                        SearchCubit.get(context).getSearchItem(
                          title: SearchCubit.get(context).searchController.text,
                          page: 1,
                          clearDate: true,
                          categoryId: SearchCubit.get(context).categoryId,
                        );
                      } else {
                        navigatorToPush(
                            context: context,
                            pageName: PartsMainNewPage(
                              idCategoryPart: int.parse(widget
                                  .categoriesMainModel!.data[index].categoryId!
                                  .toString()),
                              subcategories: widget.categoriesMainModel!
                                  .data[index].subcategories,
                              titleAppBar: widget
                                  .categoriesMainModel!.data[index].title!
                                  .toString(),
                            ));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.r),
                      child: Container(
                          height: 40.h,
                          decoration: AppDecoration.outlineButton.copyWith(
                            color: DIManager.findDep<SharedPrefs>()
                                        .getThemeApp() ==
                                    'd'
                                ? appTheme.lightBlue100
                                : !widget.isFromSearchPage
                                    ? (widget.categoriesMainModel!.data[index]
                                                .color !=
                                            null
                                        ? Color(int.parse(
                                            '0xff${widget.categoriesMainModel!.data[index].color}'))
                                        : appTheme.deepPurpleA100)
                                    : isSelectAvailableList[index]
                                        ? appTheme.deepPurpleA100
                                        : (widget.categoriesMainModel!
                                                    .data[index].color !=
                                                null
                                            ? Color(int.parse(
                                                '0xff${widget.categoriesMainModel!.data[index].color}'))
                                            : Colors.grey),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Center(
                                child: textNormal(
                                    text: widget
                                        .categoriesMainModel!.data[index].title
                                        .toString(),
                                    color: appTheme.black900)),
                          )),
                    ),
                  )
                },
              ],
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                textNormal(text: 'نتائج البحث : '),
                textNormal(
                    text: SearchCubit.get(context).data!.length.toString()),
              ],
            ),
          ),
      ],
    );
  }

  Widget mainCategories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categoriesMainModel!.data.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = widget.categoriesMainModel!.data[index];
            final icon = item.icon?.toString() ?? '';
            final imagePath = icon.contains('http')
                ? icon
                : '${AppEndpoints.baseUrlWithoutApi}$icon';

            return buildCategory(
              isScrollerCard: true,
              imagePath: imagePath,
              text: item.title.toString(),
              onTap: () {
                navigatorToPush(
                  context: context,
                  pageName: PartsMainNewPage(
                    idCategoryPart: int.parse(item.categoryId!.toString()),
                    subcategories: item.subcategories,
                    titleAppBar: item.title!.toString(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
