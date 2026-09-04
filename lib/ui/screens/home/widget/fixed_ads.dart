import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/fixed_ads_items.dart';

import '../../../../widgets/ads_product_widget.dart';
import '../../../../widgets/components.dart';
import '../../../theme/theme_helper.dart';
import '../../details_product/details_product.dart';

class FixedAdsWidget extends StatelessWidget {
   FixedAdsWidget({super.key, this.adsProduct});
  Ads? adsProduct;
  @override
  Widget build(BuildContext context) {
    return adsProduct?.data ==null?Container(): Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        adsProduct!.data.isNotEmpty
            ? Align(
          alignment: Alignment.centerRight,
              child: Padding(
                        padding: EdgeInsets.only(
                left: 20, bottom: 5, top: 15, right: 20),
                        child: Text('أبرز الإعلانات',
              style: themeLite.textTheme.titleMedium,
                        ),
                      ),
            )
            : Container(),
        Container(
          height: 280,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10, right: 10),
            scrollDirection: Axis.horizontal,
            itemCount: adsProduct!.data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    navigatorToPush(
                        context: context,
                        pageName: DetailsProduct(
                          detailsProduct: adsProduct!.data[index],
                          categoryId:
                          adsProduct!.data[index].categoryId.toString(),
                          adsName: adsProduct!.data[index].name,
                          idAds: adsProduct!.data[index].adsId.toString(),
                          idBannerOrProduct:
                          int.parse(adsProduct!.data[index].adsId!),
                          idAdOnwerCompany:
                          int.parse(adsProduct!.data[index].userId!),
                        ));
                  },
                  child: FixedAdsItems(
                    dataProductItem: adsProduct!.data[index],
                  ));
            },
          ),
        ),
        adsProduct!.data.isNotEmpty
            ? sizeHeightNormal(height: 10)
            : Container(),
      ],
    );
  }
}
