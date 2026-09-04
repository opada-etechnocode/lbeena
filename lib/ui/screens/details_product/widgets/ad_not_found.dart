import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/components.dart';

class AdNotFoundWidget extends StatelessWidget {
  const AdNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(vertical: 280.h),
      child: Column(
        children: [
          Center(
            child: textNormal(
                text: 'الإعلان غير متاح حالياً',
                color: Colors.red),
          ),
          Container(
            height: 110.h,
          ),
        ],
      ),
    );
  }
}
