import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/lbeena_colors.dart';
import '../cubit/cart_cubit.dart';

class ItemCart extends StatefulWidget {
  ItemCart({super.key, required this.index});

  int index;

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  bool get _isDark => DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  @override
  Widget build(BuildContext context) {
    final item = CartCubit.get(context).dataCart!.items[widget.index];
    final titleColor = _isDark ? LbeenaColors.white : const Color(0xFF1F2937);
    final muted = _isDark ? LbeenaColors.fieldHint : LbeenaColors.muted;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        decoration: LbeenaColors.cardWith(
          color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
        ),
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageView(
                imagePath: _imagePath(item),
                width: 78.w,
                height: 78.w,
                fit: BoxFit.cover,
                placeHolder: ImageConstant.imgPerson,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.companyName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: muted,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.price ?? ''} د.إ',
                    style: TextStyle(
                      color: LbeenaColors.orange,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _qtyButton(
                        icon: FontAwesomeIcons.minus,
                        onTap: () {
                          CartCubit.get(context)
                              .decrementQyt(index: widget.index);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          '${item.quantity}',
                          style: TextStyle(
                            color: titleColor,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      _qtyButton(
                        icon: FontAwesomeIcons.plus,
                        onTap: () {
                          CartCubit.get(context)
                              .incrementQyt(context, index: widget.index);
                        },
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          CartCubit.get(context).deleteItem(
                            idItem: item.cartItemId!,
                            index: widget.index,
                            qyt: item.quantity!,
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.trashCan,
                              size: 13,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _imagePath(dynamic item) {
    if (item.imageNames != null && item.imageNames!.isNotEmpty) {
      final raw = item.imageNames![0].toString();
      if (raw.contains('https') || raw.contains('http')) return raw;
      return '${AppEndpoints.baseUrlWithoutApi}/$raw';
    }
    final banner = item.banner_image;
    if (banner == null || banner.toString().isEmpty) {
      return ImageConstant.imgPerson;
    }
    final raw = banner.toString();
    if (raw.contains('https') || raw.contains('http')) return raw;
    return '${AppEndpoints.baseUrlWithoutApi}/$raw';
  }

  Widget _qtyButton({
    required FaIconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: LbeenaColors.orange.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: 11,
            color: LbeenaColors.orange,
          ),
        ),
      ),
    );
  }
}
