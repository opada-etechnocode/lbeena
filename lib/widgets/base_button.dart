import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  BaseButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.buttonStyle,
    this.buttonTextStyle,
    this.isDisabled,
    this.height,
    this.width,
    this.margin,
    this.alignment,
    this.borderRadius,
    this.isStar =false,
  }) : super(
          key: key,
        );

  final String text;
  bool isStar =false;
  final VoidCallback? onPressed;

  final ButtonStyle? buttonStyle;

  final TextStyle? buttonTextStyle;

  final bool? isDisabled;

  final double? height;

  final double? width;
  final double? borderRadius;

  final EdgeInsets? margin;

  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
