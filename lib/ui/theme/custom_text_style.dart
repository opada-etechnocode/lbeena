import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Title text style
  static get titleSmallff000000 => themeLite.textTheme.titleSmall!.copyWith(
        color: Color(0XFF000000),
      );
  static get titleSmallff00a1c4 => themeLite.textTheme.titleSmall!.copyWith(
        color: LbeenaColors.orange,
      );


  // Body text style
  static get bodyLargeWhiteA700 => themeLite.textTheme.bodyLarge!.copyWith(
    color: appTheme.whiteA700,
  );
  static get bodySmallBlack900 => themeLite.textTheme.bodySmall!.copyWith(
    color: appTheme.black900.withOpacity(0.7),
    fontSize: 12.sp,
  );
  // Label text style
  static get labelMediumWhiteA700 => themeLite.textTheme.labelMedium!.copyWith(
    color: appTheme.whiteA700,
  );
  // Title text style
  static get titleLargeWhiteA700 => themeLite.textTheme.titleLarge!.copyWith(
    color: appTheme.whiteA700,
  );
  static get titleMedium18 => themeLite.textTheme.titleMedium!.copyWith(
    fontSize: 18.sp,
  );
  static get titleMediumWhiteA700 => themeLite.textTheme.titleMedium!.copyWith(
    color: appTheme.whiteA700,
    fontSize: 18.sp,
  );
}

extension on TextStyle {
  TextStyle get cairo {
    return copyWith(
      fontFamily: 'Cairo',
    );
  }

  TextStyle get sf {
    return copyWith(
      fontFamily: 'Cairo',
    );
  }
}
