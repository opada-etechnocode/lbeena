import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/my_app.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

class NoticeToUsers extends StatelessWidget {
  const NoticeToUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.sp),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: double.infinity,
            height: 28.h,
            decoration: BoxDecoration(
              color: Color(0xFFffc000),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text('تنويه : سوشال مخصص فقط لنشر البوستات وليس للإعلانات.',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 11.fSize, color: Colors.black)),
            ),
          ),
          Stack(alignment: Alignment.center,
            children: [
              Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.5), // لون الظل
                      blurRadius: 2, // مدى التمويه
                      offset: Offset(0, 0), // اتجاه الظل (أفقي، عمودي)
                    ),
                  ],
                ),
              ),

              CustomImageView(
                imagePath: ImageConstant.pngwingIcon,
                width: 30.w,
                height: 30.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
