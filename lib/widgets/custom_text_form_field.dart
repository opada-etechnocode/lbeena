import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ui/theme/lbeena_colors.dart';
import '../ui/theme/theme_helper.dart';
import '../ui/theme/theme_text_form_field.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.errorText,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.counterText,
    this.contentPadding,
    this.borderDecoration,
    this.onEditingComplete,
    this.onChanged,
    this.onSubmitted,
    this.cursorHeight,
    this.height,
    this.isMobile = false,
    this.fillColor,
    this.filled = true,
    this.maxLength,
    this.validator,
    this.readOnly,
    this.textDirection,
  }) : super(key: key);

  final Alignment? alignment;
  final double? width;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final String? errorText;
  final String? counterText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final int? maxLength;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool? filled;
  final bool? isMobile;
  final bool? readOnly;
  final TextDirection? textDirection;
  final double? cursorHeight;
  final double? height;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: textFormFieldWidget(context),
    )
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => SizedBox(
    width: width ?? double.maxFinite,
    height: height,
    child: ThemeTextFormField(
      child: TextFormField(
        textDirection: textDirection,
        cursorHeight: cursorHeight,
        inputFormatters: isMobile!
            ? [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ]
            : [],
        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        controller: controller,
        maxLength: maxLength,
        readOnly: readOnly ?? false,
        focusNode: focusNode ?? FocusNode(),
        autofocus: autofocus!,
        style: textStyle ?? themeLite.textTheme.bodyMedium,
        obscureText: obscureText!,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        decoration: decoration,
        validator: validator,
      ),
    ),
  );

  InputDecoration get decoration => InputDecoration(
    hintText: hintText ?? "",
    hintStyle: hintStyle ??
        themeLite.textTheme.bodyMedium!.copyWith(color: LbeenaColors.fieldHint),
    prefixIcon: prefix,
    prefixIconConstraints: prefixConstraints,
    suffixIcon: suffix,
    counterStyle: TextStyle(color: appTheme.black900),
    suffixIconConstraints: suffixConstraints,
    counterText: counterText,
    errorText: errorText,
    isDense: true,
    contentPadding: contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    fillColor: fillColor ?? appTheme.whiteA700,
    filled: filled,
    border: borderDecoration ?? _fieldBorder(LbeenaColors.fieldBorder),
    enabledBorder: borderDecoration ?? _fieldBorder(LbeenaColors.fieldBorder),
    focusedBorder: borderDecoration ??
        _fieldBorder(LbeenaColors.orange, width: 1.5),
    errorBorder: _fieldBorder(appTheme.red300),
    focusedErrorBorder: _fieldBorder(appTheme.red300, width: 1.5),
  );

  OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

Widget buildText(BuildContext context, String text) {
  return Text(
    text,
    style: themeLite.textTheme.titleMedium,
  );
}
