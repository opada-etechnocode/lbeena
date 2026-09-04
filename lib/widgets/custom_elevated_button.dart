import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ui/theme/lbeena_colors.dart';
import '../ui/theme/theme_helper.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.child,
    this.backgroundButtonColor,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    double? borderRadius,
    bool isStar =false,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          borderRadius: borderRadius,
          margin: margin,
          isStar: isStar,
        );

  final BoxDecoration? decoration;
  final Color? backgroundButtonColor;
  final Widget? leftIcon;
  final Widget? child;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: this.height ?? 39.w,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle ?? ElevatedButton.styleFrom(backgroundColor:backgroundButtonColor?? appTheme.buttonColor,
            foregroundColor: LbeenaColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( borderRadius ??16.r),
            ),),
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child:child?? Row(
            mainAxisAlignment:isStar? MainAxisAlignment.start: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Padding(
                padding: isStar?  EdgeInsets.only(right: 10.w):EdgeInsets.zero,
                child: Text(
                  text,
                  style: buttonTextStyle ??
                      themeLite.textTheme.titleMedium!.copyWith(
                        color: LbeenaColors.white,
                      ),
                ),
              ),
              rightIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
}
