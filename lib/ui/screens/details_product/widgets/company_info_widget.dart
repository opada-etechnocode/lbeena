import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../company/company_details_page.dart';


class CompanyInfoWidget extends StatelessWidget {
  CompanyInfoWidget({super.key,
  required this.company
  });

  final List<dynamic> company;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigatorToPush(
            context: context,
            pageName: CompanyDetailsPage(
              idCompany: company[0].id,
            ));
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: LbeenaColors.card,
        child: Row(
          children: [
            Container(
              height: 56.h,
              width: 56.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LbeenaColors.orange, width: 2),
              ),
              child: company[0].profilePic.toString() == 'null'
                  ? CustomImageView(
                imagePath:ImageConstant.imgPerson,
                height: 40.h,
                width: 40.h,
                radius: BorderRadiusStyle.roundedBorder60,
                alignment: Alignment.center,
                color: LbeenaColors.teal,
                fit: BoxFit.fill,
              )
                  : CustomImageView(
                imagePath:
                company[0].profilePic.toString().contains('http')
                    ? company[0].profilePic.toString()
                    : AppEndpoints.baseUrlWithoutApi +
                    company[0].profilePic.toString(),
                height: 52.h,
                width: 52.h,
                radius: BorderRadiusStyle.roundedBorder60,
                alignment: Alignment.center,
                fit: BoxFit.fill,
                placeHolder: ImageConstant.imgPerson,
              ),
            ),
            sizeWidthNormal(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textNormal(
                    text: 'البائع',
                    fontSize: 11,
                    color: LbeenaColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                  textNormal(
                    text: company[0].companyName.toString(),
                    color: LbeenaColors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  RatingBarIndicator(
                    rating: double.parse(company?[0].evaluations ?? '0').toDouble(),
                    itemCount: 5,
                    itemSize: 16.h,
                    unratedColor: LbeenaColors.fieldBorder,
                    direction: Axis.horizontal,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 13.h,
                      color: LbeenaColors.star,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: LbeenaColors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
