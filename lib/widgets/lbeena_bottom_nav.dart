import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  static const double barHeight = 72;

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final barColor = isDark ? LbeenaColors.cardDark : LbeenaColors.white;

    return Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, 8 + bottomInset),
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? LbeenaColors.white.withOpacity(0.06)
                : LbeenaColors.black.withOpacity(0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: LbeenaColors.black.withOpacity(isDark ? 0.45 : 0.12),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: FontAwesomeIcons.gear,
                label: AppLocalizations.of(context)!.settings,
                isActive: selectScreen == 2,
                onTap: () => onSelect(2),
              ),
            ),
            Expanded(
              child: _ChatNavItem(
                chatBloc: chatBloc,
                isActive: selectScreen == 1,
                onTap: () => onSelect(1),
              ),
            ),
            Expanded(
              child: _HomeNavItem(
                isActive: selectScreen == -1,
                onTap: () => onSelect(-1),
              ),
            ),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return _NavItem(
                    icon: FontAwesomeIcons.bagShopping,
                    label: 'السلة',
                    isActive: selectScreen == 0,
                    badge: CartCubit.get(context).lengthListCart,
                    onTap: () => onSelect(0),
                  );
                },
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: FontAwesomeIcons.addressBook,
                label: 'الدليل',
                isActive: selectScreen == 3,
                onTap: () => onSelect(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [LbeenaColors.orange, LbeenaColors.orangeDeep],
              ),
              boxShadow: [
                BoxShadow(
                  color: LbeenaColors.orange.withOpacity(isActive ? 0.45 : 0.22),
                  blurRadius: isActive ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.house,
                size: 16,
                color: LbeenaColors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'الرئيسية',
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? LbeenaColors.orange : LbeenaColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? LbeenaColors.orange : LbeenaColors.muted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              FaIcon(icon, size: 18, color: color),
              if (badge > 0)
                PositionedDirectional(
                  top: -8,
                  start: -10,
                  child: _CountBadge(count: badge),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              height: 1.1,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatNavItem extends StatelessWidget {
  const _ChatNavItem({
    required this.chatBloc,
    required this.isActive,
    required this.onTap,
  });

  final ChatCubitFirebase chatBloc;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (DIManager.findDep<SharedPrefs>().getToken() != null) {
      chatBloc.getNotifications(
        user_id: DIManager.findDep<SharedPrefs>().getUserID(),
      );
    }

    return BlocProvider(
      create: (context) => ChatCubitFirebase(),
      child: BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return _NavItem(
            icon: isActive
                ? FontAwesomeIcons.solidComments
                : FontAwesomeIcons.comments,
            label: AppLocalizations.of(context)!.chat,
            isActive: isActive,
            badge: chatBloc.notification.length,
            onTap: onTap,
          );
        },
      ),
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

  final IconData icon;
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
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (icon != null) ...[
            FaIcon(icon, size: 14, color: LbeenaColors.teal),
            const SizedBox(width: 8),
          ],
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
                style: const TextStyle(
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
