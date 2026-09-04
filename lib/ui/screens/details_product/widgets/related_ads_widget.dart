import 'package:flutter/cupertino.dart';

import '../../../../data/models/home_page/banner_product_model.dart';
import '../../../../widgets/ads_product_widget.dart';
import '../../../../widgets/components.dart';
import '../details_product.dart';

class RelatedAdsWidget extends StatelessWidget {
   RelatedAdsWidget({super.key,required this.relatedAds});
  List<DataProductBannerModel> relatedAds=[];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        relatedAds.isEmpty
            ? Container()
            : textNormal(text: 'إعلانات ذات صلة:'),
        relatedAds.isEmpty ? Container() : sizeHeightNormal(),
        relatedAds.isEmpty
            ? Container()
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: relatedAds.length ,
          itemBuilder: (context, index) {
            // print(homePageModel!.data!.adsProduct!.data.length);
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
