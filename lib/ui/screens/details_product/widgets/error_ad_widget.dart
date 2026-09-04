import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/components.dart';
import '../../../../widgets/details_product_shimmer.dart';

class ErrorAdWidget extends StatelessWidget {
  const ErrorAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          textNormal(
              text:
              'خطأ بالتحميل, الرجاء المحاولة مرة أخرى'),
          sizeHeightNormal(height: 30.h),
          const DetailsProductShimmer(),
        ],
      ),
    );
  }
}
