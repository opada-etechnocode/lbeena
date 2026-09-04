import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/ads_product_shimmer.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/main_parts_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'community_shimmer.dart';

class CustomPageShimmer extends StatefulWidget {
  const CustomPageShimmer({super.key});

  @override
  State<CustomPageShimmer> createState() => _CustomPageShimmerState();
}

class _CustomPageShimmerState extends State<CustomPageShimmer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         BannerItemShimmer(),
          CommunityShimmer()
      ],
    );
  }
}
