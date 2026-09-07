import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';

class AdDetailsForOwnerWidget extends StatelessWidget {
  AdDetailsForOwnerWidget({super.key,
  required this.dataDetailsProduct,
    required this.isHaveAds,
    required this.clicks,
    required this.showAds,

  });

  final String? isHaveAds;
  final int clicks;
  final int showAds;
  final dynamic dataDetailsProduct;

  Color _statusColor() {
    switch (dataDetailsProduct.status) {
      case '0':
        return LbeenaColors.star;
      case '1':
        return LbeenaColors.teal;
      case '2':
        return LbeenaColors.orangeDeep;
      default:
        return LbeenaColors.muted;
    }
  }

  String _statusLabel() {
    switch (dataDetailsProduct.status) {
      case '0':
        return 'قيد الانتظار';
      case '1':
        return 'الإعلان فعال';
      case '2':
        return 'مرفوض';
      default:
        return 'منتهي الصلاحية';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                label: 'حالة الإعلان',
                value: _statusLabel(),
                valueColor: dataDetailsProduct.status == '0'
                    ? LbeenaColors.black
                    : LbeenaColors.white,
                background: _statusColor(),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _statCard(
                label: dataDetailsProduct.status == '3'
                    ? ''
                    : dataDetailsProduct.status == '0'
                        ? ''
                        : 'ينتهي إعلانك بعد',
                value: dataDetailsProduct.status == '3'
                    ? 'منتهي الصلاحية'
                    : dataDetailsProduct.status == '0'
                        ? 'قيد الانتظار'
                        : dataDetailsProduct!.acceptDate != null
                            ? getComparedTimeTow(
                                    dataDetailsProduct!.finishedAt ??
                                        DateTime.now(),
                                    dataDetailsProduct!.acceptDate.toString())
                                .toString()
                            : '',
                valueColor: LbeenaColors.teal,
                background: LbeenaColors.white,
              ),
            ),
          ],
        ),
        sizeHeightNormal(),
        Row(
          children: [
            Expanded(
              child: _statCard(
                label: 'المشاهدات',
                value: clicks == 0
                    ? '${int.parse(dataDetailsProduct.clicks ?? '0') + showAds}'
                    : '$clicks',
                valueColor: LbeenaColors.orange,
                background: LbeenaColors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _statCard(
                label: 'حالة الإعلان',
                value: isHaveAds == '1' ? 'الإعلان مميز' : 'الإعلان غير مميز',
                valueColor: isHaveAds == '1'
                    ? LbeenaColors.white
                    : LbeenaColors.black,
                background: isHaveAds == '1'
                    ? LbeenaColors.teal
                    : LbeenaColors.white,
                leading: isHaveAds == '1'
                    ? iconSvg(iconSvg: ImageConstant.iconTrue)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required Color valueColor,
    required Color background,
    Widget? leading,
  }) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: LbeenaColors.card.copyWith(color: background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (label.isNotEmpty)
            textNormal(
              text: label,
              fontWeight: FontWeight.w600,
              fontSize: AppFontSize.fontSize_11,
              color: background == LbeenaColors.white ||
                      background == LbeenaColors.star
                  ? LbeenaColors.muted
                  : LbeenaColors.white,
            ),
          Row(
            children: [
              if (leading != null) leading,
              Flexible(
                child: textNormal(
                  text: value,
                  color: valueColor,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
