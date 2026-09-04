import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../ui/theme/theme_helper.dart';
import '../components.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.beat(
      color: appTheme.greenColor,
      size: 100,
    );
  }
}
