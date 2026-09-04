import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

class OTPInputWidget extends StatelessWidget {
  const OTPInputWidget({
    super.key,
    required this.length,
    required this.onChanged,
    required this.onSubmit,
  });

  final int length;
  final Function(String) onChanged;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    final fill = isDark ? LbeenaColors.cardDark : LbeenaColors.white;
    final textColor = isDark ? LbeenaColors.white : LbeenaColors.black;

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LbeenaColors.fieldBorder, width: 1.2),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: length,
        onChanged: onChanged,
        onCompleted: onSubmit,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: LbeenaColors.orange, width: 1.6),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: LbeenaColors.white,
          ),
          decoration: defaultPinTheme.decoration!.copyWith(
            color: LbeenaColors.teal,
            border: Border.all(color: LbeenaColors.teal, width: 1.6),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        closeKeyboardWhenCompleted: true,
        showCursor: true,
        cursor: Container(
          width: 2,
          height: 22,
          decoration: BoxDecoration(
            color: LbeenaColors.orange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
