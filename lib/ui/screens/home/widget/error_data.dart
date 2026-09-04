import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_page_shimmer.dart';

import 'package:syrians_in_uae/core/link_app.dart';

class ErrorData extends StatefulWidget {
  const ErrorData({super.key});

  @override
  State<ErrorData> createState() => _ErrorDataState();
}

class _ErrorDataState extends State<ErrorData> {
  @override
  Widget build(BuildContext context) {
    return    Center(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment
            .center,
        mainAxisAlignment:
        MainAxisAlignment
            .center,
        children: [
          textNormal(
              text: AppLocalizations.of(
                  context)!
                  .error_data),
          sizeHeightNormal(
              height: 30.h),
          const CustomPageShimmer(),
        ],
      ),
    );
  }
}
