import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../core/helper/snack_bar_helper.dart';
// import '../../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../../widgets/components.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/loader_for_page.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../../theme/theme_text_form_field.dart';
import '../../home/cubit/cubit.dart';

class EditAdWidget extends StatefulWidget {
   EditAdWidget({super.key,
   required this.isBannerInOut,
   required this.dataDetailsProduct,
   required this.idBannerOrProduct,
   required this.type,
   });
  final int? idBannerOrProduct;
  final String type;
  final bool isBannerInOut;
  final dynamic dataDetailsProduct;
  @override
  State<EditAdWidget> createState() => _EditAdWidgetState();
}

class _EditAdWidgetState extends State<EditAdWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? controllerDescriptionAds = TextEditingController();
  TextEditingController? controllerUrlAds = TextEditingController();
  TextEditingController? priceController = TextEditingController();
  TextEditingController? couponController = TextEditingController();
  TextEditingController? couponDateController = TextEditingController();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _fordFocusNode = FocusNode();
  final FocusNode _fifeFocusNode = FocusNode();


  @override
  void initState() {
    initialization();
    super.initState();
  }
  initialization() {
    controllerDescriptionAds!.text = widget.dataDetailsProduct.description.toString();
    controllerUrlAds!.text = widget.dataDetailsProduct.url.toString();
    priceController!.text = widget.dataDetailsProduct.price == null
        ? ''
        : widget.dataDetailsProduct.price.toString();
    couponController!.text = widget.dataDetailsProduct.couponPercent == null
        ? ''
        : widget.dataDetailsProduct.couponPercent.toString();
    couponDateController!.text = widget.
    dataDetailsProduct.days_add_coupon == null
        ? ''
        : widget.dataDetailsProduct.days_add_coupon.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Container(
        width: MediaQuery.of(context).size.width,
        // decoration: AppDecoration.outlineContainer,
        child: Neumorphic(
          style: getNeumorphicStyle().copyWith(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18.r)),
            shadowLightColor:purpleShadowColor.withOpacity(1),
            shadowDarkColor: purpleShadowColor.withOpacity(0.4),
            color: appTheme.greenColor.withOpacity(.3),
          ),
          child: AnimatedCrossFade(
            firstChild: SizedBox(height: 0,),
            secondChild: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isBannerInOut) ...[
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10.h),
                    //   child: textNormal(text: 'تعديل الاسم :'),
                    // ),
                    // sizeHeightNormal(height: 8.h),
                    // CustomTextFormField(
                    //   controller: controllerNameAds,
                    //   focusNode: _firstFocusNode,
                    //   hintText: controllerNameAds!.text,
                    //   validator: (text) {
                    //     if (text == null || text.isEmpty) {
                    //       return AppLocalizations.of(context)!
                    //           .field_is_empty;
                    //     }
                    //     return null;
                    //   },
                    // ),
                    sizeHeightNormal(height: 5.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      child: textNormal(text: 'تعديل الوصف :'),
                    ),
                    sizeHeightNormal(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.h,
                        // vertical: 9.v,
                      ),
                      decoration: AppDecoration.outlineCyan.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder24,
                         
                          boxShadow: []),
                      child:  ThemeTextFormField(
                        child: TextFormField(
                          controller: controllerDescriptionAds,
                          focusNode: _secondFocusNode,
                          // textDirection: DIManager.findDep<ApplicationCubit>().appLanguage.languageCode == AppConsts.LANG_AR? TextDirection.rtl:TextDirection.ltr,
                          maxLines: null,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .field_is_empty;
                            }
                            return null;
                          },
                          maxLength: 700,
                          // onChanged: (text) {
                          //   setState(() {
                          //     companyDescriptionController.text = text;
                          //   });
                          // },
                          // cursorColor: AppColorsController().scaffoldBGColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(color: appTheme.black900),
                            hintText: controllerDescriptionAds!.text,
                            hintStyle: themeLite.textTheme
                                .bodyMedium, // زيادة التباعد الرأسي لزيادة ارتفاع الحقل
                          ),
                          // onChanged: (value) {
                          //   setState(() {
                          //     // aboutMeValue = value;
                          //   });
                          // },
                        ),
                      ),
                    ),
                    // CustomTextFormField(
                    //   controller: controllerDescriptionAds,
                    //   focusNode: _secondFocusNode,
                    //   hintText: controllerDescriptionAds!.text,
                    //   maxLines: null,
                    //   maxLength: 700,
                    //   textInputAction: TextInputAction.newline,
                    //   validator: (text) {
                    //     if (text == null || text.isEmpty) {
                    //       return AppLocalizations.of(context)!.field_is_empty;
                    //     }
                    //     return null;
                    //   },
                    // ),

                    if (widget.dataDetailsProduct.have_price != null &&
                        widget.dataDetailsProduct.have_price == '1') ...{
                      sizeHeightNormal(height: 8.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            child: textNormal(
                              text: " تعديل السعر : ",
                            ),
                          ),
                          CustomTextFormField(
                            autofocus: false,
                            width: 160.h,
                            controller: priceController,
                            textDirection: ui.TextDirection.rtl,
                            focusNode: _thirdFocusNode,
                            textInputType: TextInputType.number,
                            hintText: 'أضف سعر هنا',
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .field_is_empty;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      sizeHeightNormal(),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.h, right: 10.h, bottom: 25.h),
                            child: textNormal(
                              text: " نسبة الخصم  %",
                            ),
                          ),
                          CustomTextFormField(
                            autofocus: false,
                            width: 147.h,
                            controller: couponController,
                            textDirection: ui.TextDirection.rtl,
                            maxLength: 2,
                            focusNode: _fordFocusNode,
                            textInputType: TextInputType.number,
                            hintText: 'أضف نسبة الخصم',
                            validator: (text) {
                              // if (text == null || text.isEmpty) {
                              //   return AppLocalizations.of(context)!
                              //       .field_is_empty;
                              // }
                              return null;
                            },
                          ),
                        ],
                      ),
                      sizeHeightNormal(),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.h, right: 10.h, bottom: 25.h),
                            child: textNormal(
                              text: "عدد أيام الخصم",
                            ),
                          ),
                          CustomTextFormField(
                            autofocus: false,
                            width: 147.h,
                            controller: couponDateController,
                            textDirection: ui.TextDirection.rtl,
                            focusNode: _fifeFocusNode,
                            textInputType: TextInputType.number,
                            maxLength: 3,
                            hintText: 'أضف مدة أيام الخصم',
                            // validator: (text) {
                            //   // if (text == null || text.isEmpty) {
                            //   //   return AppLocalizations.of(context)!
                            //   //       .field_is_empty;
                            //   // }
                            //   try {
                            //     int days = int.parse(text!);
                            //     if (days > 365) {
                            //       return 'عدد الأيام يجب أن يكون أقل من سنة';
                            //     }
                            //   } catch (e) {
                            //
                            //     return 'الرجاء إدخال رقم صحيح';
                            //   }
                            //
                            //   return null;
                            // },
                          ),
                        ],
                      ),
                    },
                    sizeHeightNormal(),
                  ] else ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.add_link,
                          style: themeLite.textTheme.titleSmall!.copyWith(
                            fontSize: AppFontSize.fontSize_15,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CustomTextFormField(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          focusNode: _secondFocusNode,
                          hintText: AppLocalizations.of(context)!.link_hint,
                          controller: controllerUrlAds,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .field_is_empty;
                            }

                            if (isURLValid(text) != true) {
                              return AppLocalizations.of(context)!
                                  .should_link_active;
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ],
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            if (couponDateController!.text.isNotEmpty &&
                                couponController!.text.isEmpty) {
                              SnackBarHelper.mySnackBarError(
                                  'الرجاء اختيار نسبة الخصم', context);
                              return;
                            }
                            if (couponDateController!.text.isNotEmpty &&
                                int.parse(couponDateController!.text) >
                                    365) {
                              SnackBarHelper.mySnackBarError(
                                  'الرجاء اختيار مدة أيام أقل من سنة',
                                  context);
                              return;
                            }

                            BlocProvider.of<HomeCubit>(context).
                            editAdsInformation(
                                adsId: widget.idBannerOrProduct!,
                                // adsName: controllerNameAds!.text,
                                adsDescription:
                                controllerDescriptionAds!.text,
                                price: priceController!.text,
                                isBannerInOut: widget.isBannerInOut,
                                urlBannerInOut: controllerUrlAds!.text,
                                coupon: couponController!.text,
                                couponDateController:
                                couponDateController!.text,
                                type: widget.type);
                          }
                        },
                        child:     BlocProvider.of<HomeCubit>(context).isLoadingEditAdsInformation
                            ? Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 30.w),
                          child: loaderNormal(size: 25.sp),
                        )
                            : Center(
                            child: Container(
                              width: 120.h,
                              height: 40.h,
                              decoration: AppDecoration
                                  .outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(
                                  text:'حفظ',
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            duration: Duration(milliseconds: 400),
            crossFadeState:  BlocProvider.of<HomeCubit>(context).isShowEditAds
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ),
      ),
    );
  }
}
