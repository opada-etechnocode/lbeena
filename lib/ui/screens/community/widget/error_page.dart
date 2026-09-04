import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../widgets/community_shimmer.dart';
import '../../../../widgets/components.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textNormal(
          text: 'حدث خطأ ما',
          fontSize: AppFontSize.fontSize_20,
        ),
        CommunityShimmer()
      ],
    );
  }
}
