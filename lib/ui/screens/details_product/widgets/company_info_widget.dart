import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 55.h,
          width: 55.h,
          decoration: AppDecoration.outlineWhiteA,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 55.h, width: 55.h,
                decoration: AppDecoration.outlineCircular3
                    .copyWith(color: Colors.white),
                // color: AppColorsController().defaultPrimaryColor,
              ),
              InkWell(
                onTap: () {
                  navigatorToPush(
                      context: context,
                      pageName: CompanyDetailsPage(
                        idCompany: company[0].id,
                      ));
                },
                child: company[0].profilePic.toString() == 'null'
                    ? CustomImageView(
                  imagePath:ImageConstant.imgPerson,
                  height: 50.h,
                  width: 50.h,
                  radius: BorderRadiusStyle.roundedBorder60,
                  alignment: Alignment.center,
                  color: appTheme.greenColor,
                  fit: BoxFit.fill,
                )
                    : CustomImageView(
                  imagePath:
                  company[0].profilePic.toString().contains('http')
                      ? company[0].profilePic.toString()
                      : AppEndpoints.baseUrlWithoutApi +
                      company[0].profilePic.toString(),
                  height: 55.h,
                  width: 55.h,
                  radius: BorderRadiusStyle.roundedBorder60,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  placeHolder: ImageConstant.imgPerson,
                ),
              ),
            ],
          ),
        ),
        sizeWidthNormal(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textNormal(text: company[0].companyName.toString()),
            Container(
              child: RatingBarIndicator(
                rating: double.parse(company?[0].evaluations ?? '0').toDouble(),
                itemCount: 5,
                itemSize: 25.h,
                unratedColor: Colors.grey,
                direction: Axis.horizontal,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  size: 13.h,
                  color: Colors.yellow,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
