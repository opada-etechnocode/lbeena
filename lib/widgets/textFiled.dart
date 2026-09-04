import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../core/constants/app_colors.dart';
import '../ui/theme/theme_text_form_field.dart';

class AppTextField extends StatelessWidget {
  final AppTextFieldParameters appTextFieldParameters;

  const AppTextField({
    super.key,
    required this.appTextFieldParameters,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: getNeumorphicStyle().copyWith(
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(appTextFieldParameters.radius)),
        color: appTextFieldParameters.enabled ||
            appTextFieldParameters.ignoreEnableColor
            ? Theme.of(context).inputDecorationTheme.fillColor
            : Theme.of(context).canvasColor.withOpacity(0.4),
      ),
      child: ThemeTextFormField(
        child: TextFormField(
          initialValue: appTextFieldParameters.initialValue,
          focusNode: appTextFieldParameters.focusNode,
          expands: appTextFieldParameters.expands,
          inputFormatters: appTextFieldParameters.inputFormatters,
          enabled:
          appTextFieldParameters.enabled && appTextFieldParameters.editable,
          controller: appTextFieldParameters.controller,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              decoration: TextDecoration.none,
              fontSize: appTextFieldParameters.textFontSize),
          onChanged: (value) {
            if (appTextFieldParameters.onChanged != null) {
              appTextFieldParameters.onChanged!(value);
            }
          },
          obscureText: appTextFieldParameters.obscureText,
          keyboardType: appTextFieldParameters.textInputType,
          textInputAction: appTextFieldParameters.textInputAction,
          maxLines: appTextFieldParameters.maxLines,
          minLines: appTextFieldParameters.minLines,
          validator: (value) {
            if (!appTextFieldParameters.isRequired!) return null;

            if (value == null || value.isEmpty) {
              return 'This field is required';
            }

            if (appTextFieldParameters.regex != null &&
                !appTextFieldParameters.regex!.hasMatch(value)) {
              return "This isn't a valid input";
            }

            return null;
          },
          textAlignVertical: appTextFieldParameters.suffix != null ||
              appTextFieldParameters.prefix != null
              ? TextAlignVertical.center
              : null,
          textDirection: appTextFieldParameters.textDirection,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(
                appTextFieldParameters.prefix != null ? 20.0 : 15,
                10.0,
                appTextFieldParameters.suffix != null ? 20.0 : 15,
                10.0),
            hintText: appTextFieldParameters.hintText,
            suffixIcon: appTextFieldParameters.suffix,
            prefixIcon: appTextFieldParameters.prefix != null
                ? Padding(
              padding: appTextFieldParameters.prefixPadding,
              child: appTextFieldParameters.prefix,
            )
                : null,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
            labelStyle: const TextStyle(
              fontSize: 14,
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              height: 1.5,
            ),
            focusedErrorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class AppTextFieldParameters {
  final TextEditingController? controller;
  final bool obscureText;
  final String hintText;
  final String? initialValue;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? prefix;
  final bool? isRequired;
  final bool enabled;
  final bool editable;
  final bool expands;
  final double radius;
  final RegExp? regex;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final Function? onChanged;
  final bool ignoreEnableColor;
  final FocusNode? focusNode;
  final double textFontSize;
  final EdgeInsets prefixPadding;
  final TextDirection? textDirection;

  AppTextFieldParameters({
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.hintText = "",
    this.textInputType = TextInputType.text,
    this.inputFormatters,
    this.suffix,
    this.prefix,
    this.isRequired = false,
    this.expands = false,
    this.enabled = true,
    this.editable = true,
    this.ignoreEnableColor = false,
    this.regex,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.focusNode,
    this.radius = 25,
    this.textFontSize = 14,
    this.textDirection,
    this.prefixPadding = const EdgeInsets.all(10),
  });
}
