import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

class ThemeTextFormField extends StatelessWidget {
  ThemeTextFormField({super.key, required this.child});
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: LbeenaColors.orange,
          selectionColor: Color(0x33F58220),
          selectionHandleColor: LbeenaColors.orange,
        ),
      ),
      child: child,
    );
  }
}
