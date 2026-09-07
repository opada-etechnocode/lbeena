import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:syrians_in_uae/core/utils/lbeena_phone_country.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

class LbeenaCountryCodePicker extends StatelessWidget {
  const LbeenaCountryCodePicker({
    super.key,
    this.initialSelection = LbeenaPhoneCountry.defaultSelection,
    required this.onChanged,
    this.height = 48,
  });

  final String initialSelection;
  final ValueChanged<String> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: const BoxConstraints(minWidth: 112),
      decoration: BoxDecoration(
        color: LbeenaColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LbeenaColors.fieldBorder),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CountryCodePicker(
          key: ValueKey(initialSelection),
          padding: EdgeInsets.zero,
          backgroundColor: LbeenaColors.white,
          dialogBackgroundColor: LbeenaColors.white,
          barrierColor: LbeenaColors.black.withValues(alpha: 0.45),
          initialSelection: initialSelection,
          favorite: LbeenaPhoneCountry.favorites,
          showDropDownButton: true,
          showFlag: true,
          flagWidth: 22,
          alignLeft: false,
          enabled: true,
          headerText: 'اختر الدولة',
          headerTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: LbeenaColors.teal,
          ),
          searchDecoration: InputDecoration(
            hintText: 'ابحث عن دولة...',
            hintStyle: const TextStyle(
              color: LbeenaColors.fieldHint,
              fontWeight: FontWeight.w500,
            ),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LbeenaColors.orange, width: 1.2),
            ),
          ),
          searchStyle: const TextStyle(
            color: LbeenaColors.black,
            fontWeight: FontWeight.w600,
          ),
          dialogTextStyle: const TextStyle(
            color: LbeenaColors.black,
            fontWeight: FontWeight.w600,
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: LbeenaColors.black,
          ),
          closeIcon: Icon(Icons.close, color: LbeenaColors.teal),
          onInit: (value) {
            final code = LbeenaPhoneCountry.digits(value?.dialCode);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onChanged(code);
            });
          },
          onChanged: (value) {
            onChanged(LbeenaPhoneCountry.digits(value.dialCode));
          },
        ),
      ),
    );
  }
}
