
import 'package:html_unescape/html_unescape.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../widgets/ads_product_widget.dart';
import '../../../widget/url_webview.dart';
import '../../company/info_company.dart';
import '../news_details/news_details_screen.dart';


class NewsCard extends StatelessWidget {
  dynamic  news;
  bool isCardInHomePage = false;

   NewsCard({super.key, required this.news,this.isCardInHomePage = false});
  final unescape = HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    print(news.description);
    return GestureDetector(
      onTap: () {
        navigatorToPush(context: context, pageName: NewsDetailsScreen(
          news: news,
          idNews:int.parse(news.id.toString()),
        ));
      },
      child:  Neumorphic(
      style: getNeumorphicStyle().copyWith(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18.r)),
      shadowLightColor:isCardInHomePage? purpleShadowColor.withOpacity(0): purpleShadowColor.withOpacity(1),
      shadowDarkColor: purpleShadowColor.withOpacity(0.4),
      color: isCardInHomePage?appTheme.lightBlue100: appTheme.white,
      ),
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.image != null) ...{

                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: AspectRatio(
                    aspectRatio: 1080 / 1350,
                    child: CustomImageView(
                      imagePath: news.image!.toString().contains('http')
                          ? news.image!
                          : AppEndpoints.baseUrlWithoutApi + news.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                sizeHeightNormal(),
              },
              Row(
                children: [
                  Flexible(
                    child: Text(
                      news.title ?? "-",
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (news.isTape == 1)
                     Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 25.r,
                    )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                  news.description ==null? "-":       unescape.convert(news.description),
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (news.source != null)...[
                sizeHeightNormal(height: 4.h),
                textNormal(text: "المصدر:",fontWeight: FontWeight.w500,fontSize: AppFontSize.fontSize_12),
                GestureDetector(
                  onTap: () {
                    navigatorToPush(
                        context: context,
                        pageName: UrlWebViewPage(
                          titleAppBer: news.source.toString(),
                          urlPage:  news.link.toString(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      news.source.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blue),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],

              if (news.createdAt != null)
                Padding(
                  padding:  EdgeInsets.only(top: 5.h),
                  child: Text(
                    // news.createdAt!.toString().ago(),
                    formatDateTime(news!.createdAt!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: AppFontSize.fontSize_10,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
