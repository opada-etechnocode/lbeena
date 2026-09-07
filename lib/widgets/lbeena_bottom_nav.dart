import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/ui/screens/cart/cubit/cart_cubit.dart';
import 'package:syrians_in_uae/ui/screens/cart/cubit/cart_state.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/states.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

class LbeenaBottomNav extends StatelessWidget {
  const LbeenaBottomNav({
    super.key,
    required this.selectScreen,
    required this.onSelect,
    required this.chatBloc,
  });

  /// `-1` home, `0` cart, `1` chats, `2` settings, `3` directory.
  final int selectScreen;
  final ValueChanged<int> onSelect;
  final ChatCubitFirebase chatBloc;

  static const double barHeight = 62;

  static const _selectToGlass = {-1: 2, 1: 1, 0: 3, 2: 0, 3: 4};
  static const _glassToSelect = [2, 1, -1, 0, 3];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    final screenWidth = MediaQuery.sizeOf(context).width;
    final barWidth = (screenWidth - 28).clamp(300.0, 560.0);

    if (DIManager.findDep<SharedPrefs>().getToken() != null) {
      chatBloc.getNotifications(
        user_id: DIManager.findDep<SharedPrefs>().getUserID(),
      );
    }

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, _) {
        return BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
          bloc: chatBloc,
          listener: (context, state) {},
          builder: (context, state) {
            final chatCount = chatBloc.notification.length;
            final cartCount = CartCubit.get(context).lengthListCart;
            final ink = isDark ? LbeenaColors.white : const Color(0xFF121215);

            final items = <LiquidGlassTabBarItem>[
              _glassTab(
                icon: Icons.settings_rounded,
                label: l10n.settings,
              ),
              _glassTab(
                icon: Icons.chat_rounded,
                selectedIcon: Icons.chat_bubble_rounded,
                label: l10n.chat,
                badge: chatCount,
              ),
              _glassTab(
                icon: Icons.home_rounded,
                label: isAr ? 'الرئيسية' : 'Home',
              ),
              _glassTab(
                icon: Icons.shopping_bag_outlined,
                selectedIcon: Icons.shopping_bag_rounded,
                label: isAr ? 'السلة' : 'Cart',
                badge: cartCount,
              ),
              _glassTab(
                icon: Icons.menu_book_rounded,
                label: isAr ? 'الدليل' : 'Directory',
              ),
            ];
            final barItems = isRtl ? items.reversed.toList() : items;
            final logicalIndex = _selectToGlass[selectScreen] ?? 2;
            final barIndex = isRtl ? items.length - 1 - logicalIndex : logicalIndex;

            return Directionality(
              textDirection: TextDirection.ltr,
              child: LiquidGlassTabBar.withImpeller(
                items: barItems,
                selectedIndex: barIndex,
                onChanged: (index) {
                  final logical = isRtl ? items.length - 1 - index : index;
                  onSelect(_glassToSelect[logical]);
                },
                width: barWidth,
                height: barHeight,
                itemPadding: 4,
                margin: const EdgeInsets.only(bottom: 8),
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
            );
          },
        );
      },
    );
  }

  static LiquidGlassTabBarItem _glassTab({
    required IconData icon,
    required String label,
    IconData? selectedIcon,
    int badge = 0,
  }) {
    return LiquidGlassTabBarItem(
      icon: icon,
      selectedIcon: selectedIcon,
      label: label,
      iconBuilder: (context, i) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(
              i.selected ? (selectedIcon ?? icon) : icon,
              size: i.size,
              color: i.color,
              shadows: i.selected
                  ? [
                      Shadow(
                        color: i.color.withValues(alpha: 0.85),
                        blurRadius: 14,
                      ),
                    ]
                  : null,
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
