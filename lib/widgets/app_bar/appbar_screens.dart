import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

import '../../core/di/di_manager.dart';
import '../../core/shared_prefs/shared_prefs.dart';

PreferredSizeWidget AppBarScreens(context,
    {required String title,
    double? height,
    bool isShowBack = false,
    bool isHaveIcons = false,
    bool isHaveOneIcons = false,
    bool isFromDetailsProfile = false,
    void Function()? onPressed,
    void Function()? onPressed2,
    String? imagePath}) {
  final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
  final isRtl = Directionality.of(context) == TextDirection.rtl;

  return AppBar(
    backgroundColor: isDark ? LbeenaColors.surfaceDark : LbeenaColors.teal,
    foregroundColor: LbeenaColors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: LbeenaColors.white,
            fontWeight: FontWeight.w700,
          ),
    ),
    leading: isShowBack
        ? IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(
              isRtl
                  ? FontAwesomeIcons.chevronRight
                  : FontAwesomeIcons.chevronLeft,
              color: LbeenaColors.white,
              size: 18,
            ),
          )
        : const SizedBox.shrink(),
    actions: [
      if (isHaveIcons)
        IconButton(
          onPressed: onPressed,
          icon: const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: LbeenaColors.white,
            size: 18,
          ),
        ),
      if (isHaveOneIcons)
        IconButton(
          onPressed: onPressed2,
          icon: imagePath == null
              ? const FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: LbeenaColors.white,
                  size: 18,
                )
              : CustomImageView(
                  imagePath: imagePath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: LbeenaColors.white,
                ),
        ),
      if (isFromDetailsProfile)
        IconButton(
          onPressed: onPressed2,
          icon: const FaIcon(
            FontAwesomeIcons.shareNodes,
            color: LbeenaColors.white,
            size: 18,
          ),
        ),
      const SizedBox(width: 4),
    ],
  );
}
