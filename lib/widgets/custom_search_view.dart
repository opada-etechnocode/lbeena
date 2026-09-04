import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/image_constant.dart';
import '../ui/theme/custom_text_style.dart';
import '../ui/theme/theme_helper.dart';
import '../ui/theme/theme_text_form_field.dart';
import 'custom_image_view.dart';

class CustomSearchView extends StatelessWidget {
  CustomSearchView({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus =false,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.textInputAction,
    this.enabled,
    this.isDense = true,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsetsGeometry? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;
  final bool? enabled;
  final bool isDense;
  TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  void Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget(context),
          )
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,

        child: ThemeTextFormField(
          child: TextFormField(
            enabled: enabled,
            scrollPadding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            controller: controller,
            focusNode: focusNode ?? FocusNode(),
            autofocus: autofocus!,
            // style: textStyle ?? CustomTextStyles.bodySmallBlack900,
            keyboardType: textInputType,
            maxLines: maxLines ?? 1,

            textInputAction:textInputAction,
            onFieldSubmitted:onFieldSubmitted,
            decoration: decoration,
            validator: validator,
            onChanged: (String value) {
              onChanged!.call(value);
            },
          ),
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodySmallBlack900,
        prefixIcon: prefix ??
            SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: CustomImageView(
                  imagePath: ImageConstant.imgSearchDeepPurpleA10001,
                  height: 18,
                  width: 18,
                  color: appTheme.deepPurpleA10001,
                ),
              ),
            ),
        prefixIconConstraints: prefixConstraints ??
            const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
        // suffixIcon: suffix ??
        //     Padding(
        //       padding: EdgeInsets.only(
        //         right: 15.h,
        //       ),
        //       child: IconButton(
        //         onPressed: () => controller!.clear(),
        //         icon: Icon(
        //           Icons.clear,
        //           color: Colors.grey.shade600,
        //         ),
        //       ),
        //     ),
        // suffixIconConstraints: suffixConstraints ??
        //     BoxConstraints(
        //       maxHeight: 32.w,
        //     ),
        isDense: isDense,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              top: 12.w,
              right: 12.h,
              bottom: 12.w,
            ),
        fillColor: fillColor ?? appTheme.whiteA700,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: BorderSide.none,
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: BorderSide.none,
            ),
      );
}
