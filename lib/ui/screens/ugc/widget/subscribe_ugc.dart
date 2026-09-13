import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/components.dart';

import '../../auth/login/model_home_page.dart';
import '../subscribe_ugc_page.dart';

class SubscribeUGCWidget extends StatelessWidget {
  SubscribeUGCWidget({super.key, required this.dateHomePage});

  HomePageLoginModel dateHomePage;

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            navigatorToPush(
              context: context,
              pageName: SubscribeSgcPage(dateHomePage: dateHomePage),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: LbeenaColors.cardWith(
              color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: LbeenaColors.orange.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.clapperboard,
                        size: 18,
                        color: LbeenaColors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'انضم إلى صناع المحتوى',
                          style: TextStyle(
                            color: isDark
                                ? LbeenaColors.white
                                : LbeenaColors.tealDark,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Cairo',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'شارك محتواك عبر نظام UGC واظهر للجمهور',
                          style: TextStyle(
                            color: isDark
                                ? LbeenaColors.fieldHint
                                : LbeenaColors.muted,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: LbeenaColors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'اشترك',
                      style: TextStyle(
                        color: LbeenaColors.white,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
