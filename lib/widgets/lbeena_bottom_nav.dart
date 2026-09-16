import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/states.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

class LbeenaBottomNav extends StatelessWidget {
  const LbeenaBottomNav({
    super.key,
    required this.selectScreen,
    required this.onSelect,
    required this.chatBloc,
  });

  /// `-1` home, `1` chats, `2` settings, `3` directory, `4` create ad.
  final int selectScreen;
  final ValueChanged<int> onSelect;
  final ChatCubitFirebase chatBloc;

  static const double barHeight = 62;

  static const _selectToGlass = {-1: 0, 1: 1, 4: 2, 3: 3, 2: 4};
  static const _glassToSelect = [-1, 1, 4, 3, 2];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    final screenWidth = MediaQuery.sizeOf(context).width;
    final barWidth = (screenWidth - 12).clamp(320.0, 620.0);
    final media = MediaQuery.of(context);
    final iOSBottomPad = media.padding.bottom > 0 ? 10.0 : 4.0;

    if (DIManager.findDep<SharedPrefs>().getToken() != null) {
      chatBloc.getNotifications(
        user_id: DIManager.findDep<SharedPrefs>().getUserID(),
      );
    }

    return BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
          bloc: chatBloc,
          listener: (context, state) {},
          builder: (context, state) {
            final chatCount = chatBloc.notification.length;
            final ink = isDark ? LbeenaColors.white : const Color(0xFF121215);

            final items = <LiquidGlassTabBarItem>[
              _glassTab(
                icon: Icons.home_rounded,
                svgPath: ImageConstant.navHome,
                label: isAr ? 'الرئيسية' : 'Home',
              ),
              _glassTab(
                icon: Icons.chat_rounded,
                svgPath: ImageConstant.imgChats,
                label: l10n.chat,
                badge: chatCount,
              ),
              _glassTab(
                icon: Icons.add,
                isAdd: true,
              ),
              _glassTab(
                icon: Icons.menu_book_rounded,
                svgPath: ImageConstant.mainIcons,
                label: isAr ? 'الدليل' : 'Directory',
              ),
              _glassTab(
                icon: Icons.settings_rounded,
                svgPath: ImageConstant.imgSetting,
                label: l10n.settings,
              ),
            ];
            final barItems = isRtl ? items.reversed.toList() : items;
            final logicalIndex = _selectToGlass[selectScreen] ?? 0;
            final barIndex = isRtl ? items.length - 1 - logicalIndex : logicalIndex;

            return MediaQuery(
              data: media.copyWith(
                padding: media.padding.copyWith(
                  bottom: Platform.isIOS ? iOSBottomPad : media.padding.bottom,
                ),
              ),
              child: Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  LiquidGlassTabBar.withImpeller(
                items: barItems,
                selectedIndex: barIndex,
                onChanged: (index) {
                  final logical = isRtl ? items.length - 1 - index : index;
                  onSelect(_glassToSelect[logical]);
                },
                width: barWidth,
                height: barHeight,
                itemPadding: 4,
                margin: EdgeInsets.only(bottom: Platform.isIOS ? 0 : 8),
                style: LiquidGlassTabBar.defaultStyle.copyWith(
                  shape: LiquidGlassShape.continuousRoundedRectangle(
                    cornerRadius: barHeight / 2,
                    clipQuality: LiquidGlassClipQuality.exact,
                    borderWidth: 0.7,
                    lightIntensity: 0.9,
                    lightDirection: 62,
                    borderType: const OpticalBorder(
                      borderSaturation: 1.1,
                      ambientIntensity: 0.85,
                      borderSolidity: 0.95,
                    ),
                  ),
                  appearance: LiquidGlassAppearance(
                    color: isDark
                        ? const Color(0x33FFFFFF)
                        : const Color(0x8FFFFFFF),
                    blur: const LiquidGlassBlur(sigmaX: 5, sigmaY: 5),
                    shadow: const LiquidGlassShadow(blur: 9, opacity: 0.13),
                  ),
                  refraction: const LiquidGlassRefraction(
                    distortion: 0.06,
                    distortionWidth: 26,
                  ),
                ),
                itemStyle: LiquidGlassTabItemStyle(
                  selectedColor: LbeenaColors.orange,
                  unselectedColor: ink,
                  iconSize: 20,
                  labelFontSize: 10,
                  iconLabelGap: 2,
                  underGlassIconSize: 24,
                  underGlassLabelFontSize: 10,
                  selectedFontWeight: FontWeight.w800,
                  unselectedFontWeight: FontWeight.w600,
                ),
                pillStyle: LiquidGlassTabPillStyle(
                  mode: LiquidGlassPillMode.both,
                  rest: LiquidGlassStyle(
                    shape: LiquidGlassShape.continuousRoundedRectangle(
                      cornerRadius: 28,
                      clipQuality: LiquidGlassClipQuality.exact,
                      borderWidth: 0.7,
                      lightIntensity: 0.9,
                      lightDirection: 62,
                      borderType: const OpticalBorder(
                        borderSaturation: 1.1,
                        ambientIntensity: 0.85,
                        borderSolidity: 0.95,
                      ),
                    ),
                    appearance: const LiquidGlassAppearance(
                      color: Color(0x2EAEAEB2),
                    ),
                  ),
                ),
              ),
                  Positioned(
                    bottom: (Platform.isIOS ? iOSBottomPad : media.padding.bottom) +
                        (Platform.isIOS ? 0 : 8) +
                        (barHeight - 48) / 2,
                    child: IgnorePointer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 56,
                            height: 32,
                            decoration: BoxDecoration(
                              color: LbeenaColors.teal,
                              borderRadius: BorderRadius.circular(barHeight),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add_rounded,
                              size: 22,
                              color: LbeenaColors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isAr ? 'رفع' : 'Post',
                            style: TextStyle(
                              color: selectScreen == 4
                                  ? LbeenaColors.orange
                                  : ink,
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              fontWeight: selectScreen == 4
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
            );
          },
    );
  }

  static LiquidGlassTabBarItem _glassTab({
    required IconData icon,
    String? label,
    String? svgPath,
    bool isAdd = false,
    int badge = 0,
  }) {
    return LiquidGlassTabBarItem(
      icon: icon,
      label: isAdd ? null : label,
      iconBuilder: (context, i) {
        if (isAdd) {
          return SizedBox(width: i.size, height: i.size);
        }

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CustomImageView(
              imagePath: svgPath,
              height: i.size,
              width: i.size,
              color: i.color,
              fit: BoxFit.contain,
            ),
            if (badge > 0)
              Positioned(
                top: -6,
                right: -8,
                child: _CountBadge(count: badge),
              ),
          ],
        );
      },
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: LbeenaColors.orange,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LbeenaColors.white, width: 1.2),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: LbeenaColors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
      ),
    );
  }
}

class LbeenaAppBarIcon extends StatelessWidget {
  const LbeenaAppBarIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.badge = 0,
  });

  final FaIconData icon;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LbeenaColors.white.withOpacity(0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              FaIcon(icon, size: 22, color: LbeenaColors.white),
              if (badge > 0)
                PositionedDirectional(
                  top: 4,
                  start: 4,
                  child: _CountBadge(count: badge),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LbeenaSectionHeader extends StatelessWidget {
  const LbeenaSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 8),
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final FaIconData? icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    return Padding(
      padding: padding,
      child: Row(
        children: [

          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: LbeenaColors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? LbeenaColors.white : LbeenaColors.tealDark,
              ),
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  color: LbeenaColors.orange,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
