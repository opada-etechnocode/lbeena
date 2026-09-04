import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import '../../../../core/constants/app_colors.dart';


class NewButton extends StatelessWidget {

  NewButton({required this.text,this.textStyle,this.textPadding,required this.onPressed,this.isLoading = false});

  final String text;
  final EdgeInsets? textPadding;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 147.w,height: 50.h,
        decoration: const BoxDecoration(
          // color: Colors.red, // 50% opacity white color
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color:  Color(0xffFFFFFF),
          boxShadow: [
            BoxShadow(
              color:   Color(0xffffffff),// Shadow color with opacity
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0), // Shadow position, you can customize it as needed
            ),

          ],
        ),
        child: Center(child: Text(text,
        style: themeLite.textTheme.labelSmall!.copyWith(fontSize: AppFontSize.fontSize_22,color: Colors.black.withOpacity(.8)),),),
      ),
    );
  }
}
