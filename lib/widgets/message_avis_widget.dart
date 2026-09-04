import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';

import '../core/constants/app_font.dart';
import 'components.dart';

class MessageAvisWidget extends StatelessWidget {
  const MessageAvisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
           Row(
            children: [
              sizeWidthNormal(
                width: 2.w
              ),
              Icon(Icons.error,
                  size: 22.sp, color: appTheme.black900),
              sizeWidthNormal(width: 5.w),
              textNormal(
                  text: 'تنبيه !',
                  fontSize: 14.sp,
                  color: Colors.red,
                  overflow: TextOverflow.visible),
            ],
          ),
         Container(
              width: MediaQuery.of(context).size.width,
              child:  Padding(
                padding:  EdgeInsets.all(8.0),
                child: textNormal(
                    text:
                    'لا نطلب أبدا بطاقات الخصم/الائتمان أو تفاصيل الحساب المصرفي عبر الدردشة أو الرسائل القصيرة أو البريد الإلكتروني.! يرجى تجاهل جميع الرسائل التي تطالبك بمشاركة بطاقتك أو تفاصيلك المصرفية',
                    fontSize: AppFontSize.fontSize_10,
                    color: Colors.red,
                    overflow: TextOverflow.visible),
              )),
        ],
      ),
    );
  }
}
