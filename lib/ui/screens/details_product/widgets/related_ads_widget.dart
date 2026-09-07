import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

import '../../../../data/models/home_page/banner_product_model.dart';
import '../../../../widgets/ads_product_widget.dart';
import '../../../../widgets/components.dart';
import '../details_product.dart';

class RelatedAdsWidget extends StatelessWidget {
   RelatedAdsWidget({super.key,required this.relatedAds});
  List<DataProductBannerModel> relatedAds=[];
  @override
  Widget build(BuildContext context) {
    if (relatedAds.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: LbeenaColors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 8.w),
            textNormal(
              text: 'إعلانات ذات صلة',
              color: LbeenaColors.teal,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
        sizeHeightNormal(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: relatedAds.length ,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  navigatorToPush(
                      context: context,
                      pageName: DetailsProduct(
                        detailsProduct: relatedAds[index],
                        categoryId:
                        relatedAds[index].categoryId.toString(),
                        adsName: relatedAds[index].name,
                        idAds: relatedAds[index].adsId.toString(),
                        idBannerOrProduct:
                        int.parse(relatedAds[index].adsId!),
                        idAdOnwerCompany: int.parse(
                            relatedAds[index].userId!.toString()),
                      ));
                },
                child: AdsProductWidget(
                  dataProductItem: relatedAds[index],
                ));
          },
        ),
      ],
    );
  }
}
