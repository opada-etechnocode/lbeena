import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/ui/screens/search/search.dart';
import 'package:syrians_in_uae/ui/screens/store/store_page.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/lbeena_bottom_nav.dart';
import '../../../theme/lbeena_colors.dart';
import '../../auth/login/login_screen.dart';
import '../../auth/login/model_home_page.dart';
import '../../calendar/calendar_page.dart';
import '../../community/community.dart';
import '../../consulate/consulate_page.dart';
import '../../cuopon/coupon_ads_screen.dart';
import '../../cuopon/coupon_screen.dart';
import '../../events/events_page.dart';
import '../../parts_main/parts_main.dart';
import '../../radio_playlist/parts_voice_page.dart';
import '../../reminders/reminder_page.dart';
import '../../ugc/ugc_user_page.dart';

class MainCategoriesNew extends StatefulWidget {
  MainCategoriesNew({super.key, required this.dateHomePage});

  final HomePageLoginModel dateHomePage;

  @override
  State<MainCategoriesNew> createState() => _MainCategoriesNewState();
}

class _MainCategoriesNewState extends State<MainCategoriesNew> {
  List<Map<String, dynamic>> get categories => [
        {
          "imagePath": ImageConstant.jobsIcons,
          "text": "وظائف",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context) {
            final jobsCategory =
                widget.dateHomePage.categoriesMainModel?.data.isNotEmpty == true
                    ? widget.dateHomePage.categoriesMainModel!.data.first
                    : null;
            if (jobsCategory?.categoryId == null) {
              return;
            }
            navigatorToPush(
                context: context,
                pageName: PartsMainNewPage(
                  idCategoryPart:
                      int.parse(jobsCategory!.categoryId!.toString()),
                  subcategories: jobsCategory.subcategories,
                  titleAppBar: jobsCategory.title?.toString() ?? '',
                ));
          }
        },
        {
          "imagePath": ImageConstant.communityIcon,
          "text": "سوشال",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: CommunityPage());
          }
        },
        {
          "imagePath": ImageConstant.syrianIcon,
          "text": "سفارة",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: ConsulatePage());
          }
        },
        {
          "imagePath": ImageConstant.eventsNewIcon,
          "text": 'أنشطة',
          "color": LbeenaColors.orange,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: EventsPage());
          }
        },
        {
          "imagePath": ImageConstant.ugcIcon,
          "text": "مؤثرين",
          "color": LbeenaColors.orange,
          "onTap": (BuildContext context, dynamic widget) {
            navigatorToPush(
                context: context,
                pageName: UGCUsersPage(dateHomePage: widget.dateHomePage));
          }
        },
        {
          "imagePath": ImageConstant.adsIcons,
          "text": "إعلانات",
          "color": LbeenaColors.orange,
          "onTap": (BuildContext context, dynamic widget) {
            navigatorToPush(
                context: context,
                pageName: SearchPage(
                    categoriesMainModel:
                        widget.dateHomePage.categoriesMainModel));
          }
        },
        {
          "imagePath": ImageConstant.headphone,
          "text": "بودكاست",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: PlayListPage());
          }
        },
        {
          "imagePath": ImageConstant.storeIcon,
          "text": "المتجر",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: StorePage());
          }
        },
        {
          "imagePath": ImageConstant.offerIcon,
          "text": "خصومات",
          "color": LbeenaColors.orange,
          "onTap": (BuildContext context) {
            DIManager.findDep<SharedPrefs>().getToken() == null
                ? navigatorToPush(context: context, pageName: LoginScreen())
                : navigatorToPush(
                    context: context, pageName: CouponAdsScreen());
          }
        },
        {
          "imagePath": ImageConstant.imgCoupons,
          "text": "كوبونات",
          "color": LbeenaColors.orange,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: CouponScreen());
          }
        },
        {
          "imagePath": ImageConstant.reminderIcon2,
          "text": "تذكيرات",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context) {
            navigatorToPush(context: context, pageName: RemindersPage());
          }
        },
        {
          "imagePath": ImageConstant.calendarIcon,
          "text": "مناسبات",
          "color": LbeenaColors.teal,
          "onTap": (BuildContext context, dynamic widget) {
            navigatorToPush(
                context: context, pageName: FullScrollableCalendar());
          }
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          const LbeenaSectionHeader(
            title: 'الأقسام',
            icon: FontAwesomeIcons.grip,
            padding: EdgeInsets.fromLTRB(4, 4, 4, 10),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 98,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
            ),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return buildCategory(
                imagePath: category["imagePath"] as String,
                color: LbeenaColors.teal,
                text: category["text"] as String,
                onTap: () {
                  if (category["onTap"] is Function(BuildContext, dynamic)) {
                    category["onTap"](context, widget);
                  } else {
                    category["onTap"](context);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
