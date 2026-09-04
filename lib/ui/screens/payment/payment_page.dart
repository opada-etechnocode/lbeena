import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/home/home_screen.dart';
import 'package:syrians_in_uae/ui/screens/payment/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/payment/cubit/status.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/add_ads/add_ads_model.dart';
import '../../../data/models/profile_company/package_company_model.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../company/all_package_company.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({
    super.key,
    this.isFromPackage = false,
    this.isFromAds = false,
    this.isSpecial = false,
    this.isAddAds = false,
    this.idPackage,
    this.adsModel,
    this.priceAdsAndBanner,
    this.priceAdsSpecialFeatures,
    this.idSelectedAdsSpecialFeatures,
    this.isAdsExpired =false,
  });

  bool isFromPackage = false;
  bool isAdsExpired = false;
  bool isAddAds = false;
  bool isFromAds = false;
  bool isSpecial = false;
  AddAdsModel? adsModel;
  int? idPackage;
  int? idSelectedAdsSpecialFeatures;
  String? priceAdsAndBanner;
  String? priceAdsSpecialFeatures;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isPaymentPackage = false;
  PackageCompanyModel? packageCompanyModel;

  @override
  Widget build(BuildContext context) {
    print(widget.isSpecial);
    return SafeArea(
        child: Scaffold(
      body: BlocProvider(
        create: (context) {
          if (widget.isFromAds == true) {
            return PaymentCubit()..getPackageCompany();
          } else {
            return PaymentCubit();
          }
        },
        child: BlocConsumer<PaymentCubit, PaymentStates>(
          listener: (context, state) {
            if (state is LoadingPaymentPackageState) {
              isPaymentPackage = true;
            }

            if (state is LoadingPaymentAdsState) {
              isPaymentPackage = true;
            }

            if (state is SuccessPaymentPackageState) {
              isPaymentPackage = false;
              if (widget.isAddAds) {
                navigatorToPushReplacementUntilAddAds(
                    context: context,
                    pageName: PaymentPage(
                      isFromAds: true,
                      isSpecial: widget.isSpecial,
                      adsModel: widget.adsModel,
                      idSelectedAdsSpecialFeatures:
                          widget.idSelectedAdsSpecialFeatures,
                      priceAdsSpecialFeatures: widget.priceAdsSpecialFeatures,
                      priceAdsAndBanner: widget.priceAdsAndBanner,
                    ));
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }

              SnackBarHelper.mySnackBarSuccess(
                  state.packageModel!.message, context);
            }
            if (state is ErrorPaymentPackageState) {
              isPaymentPackage = false;
              SnackBarHelper.mySnackBarError('يوجد خطأ ما ..', context);
            }

            if (state is SuccessPackageCompanyState) {
              packageCompanyModel = state.packageCompanyModel;
            }

            if (state is SuccessPaymentAdsState) {
              isPaymentPackage = false;
              SnackBarHelper.mySnackBarSuccess(
                  state.adsModel!.message, context);
// عشان دفع الاعلانات المميزة
              // navigatorToPushReplacementUntilAddAds(
              //     context: context, pageName: HomePage());
              navigatorToPushReplacementUntil(
                  context: context, location: '/homePage',
                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
              );
              // navigatorToPushReplacementUntil(
              //     context: context,
              //     location: '/homePage');
              if (widget.isSpecial) {
                showChats(context);
              }
              if(widget.isAdsExpired){
                PaymentCubit.get(context).changeStatusAdsFromUnPaid(idAds: widget.adsModel!.data!.adsId!);
              }
            }

            if (state is ErrorPaymentAdsState) {
              isPaymentPackage = false;
              SnackBarHelper.mySnackBarSuccess(state.error.toString(), context);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarNormal(
                  context,
                  text: "الدفع",
                ),
                Expanded(
                  flex: 3,
                  child: RefreshIndicator(
                    color: appTheme.greenColor,
                    backgroundColor: appTheme.lightBlue100,
                    onRefresh: () {
                      if (widget.isFromAds == true) {
                        return PaymentCubit.get(context).getPackageCompany();
                      } else {
                        return PaymentCubit.get(context).getPackageCompany();
                      }
                    },
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildAddDetailsPayment(context, state),
                    )),
                  ),
                )
              ],
            );
          },
        ),
      ),
    ));
  }

  Widget _buildAddDetailsPayment(context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          "اختيار طريقة الدفع",
          style: themeLite.textTheme.titleSmall!
              .copyWith(fontSize: AppFontSize.fontSize_15),
        ),
        SizedBox(
          height: 10.h,
        ),


        packageCompanyModel == null
            ? Container()
            : packageCompanyModel!.data!.packagecompany.isNotEmpty
            ? textNormal(text: 'لديك باقات متاحة بالفعل', color: Colors.green,fontSize: 13.sp):textNormal(text: 'اذا كنت تحتاج عدة إعلانات ننصحك بشراء باقة', color: Colors.green,fontSize: 13.sp),
        packageCompanyModel == null
            ? Container()
            :  SizedBox(
          height: 10.h,
        ),
        Column(
          children: [
            widget.isFromPackage
                ? Container()
                : Row(
              children: [
                // iconSvg(iconSvg: ImageConstant.iconChoose),
                InkWell(
                  onTap: () {
                    setState(() {
                      methodPayment = 3;
                    });
                  },
                  child: methodPayment == 3
                      ? CustomImageView(
                    imagePath: ImageConstant.imgTrue,
                    height: 20.h,
                    width: 25.h,
                  )
                      : point(),
                ),
                sizeWidthNormal(),
                Text(
                  "دفع عن طريق الباقة:",
                  style: themeLite.textTheme.titleSmall!
                      .copyWith(fontSize: 15.sp),
                ),
                // Spacer(),
                packageCompanyModel == null
                    ? Container()
                    : packageCompanyModel!.data!.packagecompany.isNotEmpty? sizeWidthNormal(width: 25.w):sizeWidthNormal(width: 60.w),
                packageCompanyModel == null
                    ? Container()
                    : packageCompanyModel!.data!.packagecompany.isNotEmpty
                    ? Container()
                    : CustomElevatedButton(
                  width: 140,
                  text: 'شراء باقة',
                  onPressed: () {
                    // navigatorToPush(
                    // context: context,
                    // pageName: PackageCompanyPage(
                    //   packageCompanyModel: packageCompanyModel,
                    // ));

                    navigatorToPush(
                        context: context,
                        pageName: AllPackageCompanyPage(
                          isFromAddAds: true,
                          isSpecial: widget.isSpecial,
                          adsModel: widget.adsModel,
                          idSelectedAdsSpecialFeatures:
                          widget.idSelectedAdsSpecialFeatures,
                          priceAdsSpecialFeatures:
                          widget.priceAdsSpecialFeatures,
                          priceAdsAndBanner:
                          widget.priceAdsAndBanner,
                        ));
                  },
                ),
              ],
            ),
            packageCompanyModel == null
                ? Container()
                : SizedBox(
              height: 10.h,
            ),
            packageCompanyModel == null
                ? Container()
                : AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: methodPayment != 3
                    ? 0
                    : (44.h) *
                    (packageCompanyModel!.data!.packagecompany.length),
                child: packageCompanyModel!.data!.packagecompany.isEmpty
                    ? textNormal(text: 'لايوجد لديك باقات الرجاء شراءباقة ..')
                    : ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                    packageCompanyModel!.data!.packagecompany.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (packageCompanyModel != null) {
                        packageId = packageCompanyModel!
                            .data!.packagecompany[0].id!;
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 8.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAdsSpecialFeatures = index;
                              packageId = packageCompanyModel!
                                  .data!.packagecompany[index].id!;
                            });
                          },
                          child: Container(
                            height: 40.h,
                            width: 100.w,
                            decoration: AppDecoration.outlineButtonLite
                                .copyWith(
                                borderRadius:
                                BorderRadius.circular(60.sp),
                                boxShadow: [],
                                border: Border.all(
                                    color:
                                    Colors.black.withOpacity(.4))),
                            child: Row(
                              children: [
                                sizeWidthNormal(),
                                selectedAdsSpecialFeatures == index
                                    ?  CustomImageView(
                                  imagePath: ImageConstant.imgTrue,
                                  height: 20.h,
                                  width: 25.h,
                                )
                                    : point(),
                                sizeWidthNormal(),
                                textNormal(
                                    text:
                                    '${packageCompanyModel!.data!.packagecompany[index].title}',
                                    fontWeight: FontWeight.w500),
                                sizeWidthNormal(),
                                textNormal(
                                    text:
                                    'متبقي ${packageCompanyModel!.data!.packagecompany[index].remainingAdsQty} اعلان',
                                    fontWeight: FontWeight.w500,fontSize: AppFontSize.fontSize_12,color: Colors.green),

                                sizeWidthNormal(),
                                textNormal(
                                    text:
                                    'مدة الاعلان ${packageCompanyModel!.data!.packagecompany[index].adsPeriod} يوم',
                                    fontWeight: FontWeight.w500,fontSize: AppFontSize.fontSize_12,color: Colors.amber),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
            if(state is LoadingPackageCompanyState) ...[
              Container(
                height: 50.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:1,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {

                      return  Shimmer.fromColors(
                        baseColor: appTheme.baseColorShimmer,
                        highlightColor: appTheme.highlightColorShimmer,

                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          child: Container(
                            height: 40.h,
                            width: 100.w,
                            decoration: AppDecoration.outlineButtonLite
                                .copyWith(
                                borderRadius:
                                BorderRadius.circular(60.sp),
                                boxShadow: [],
                                border: Border.all(
                                    color:
                                    Colors.black.withOpacity(.4))),

                          ),
                        ),
                      );
                    }),
              ),
            ],
            widget.isFromPackage
                ? Container()
                : Column(children: [
              sizeHeightNormal(),
              Center(
                child: textNormal(
                    text: 'OR',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              sizeHeightNormal(),
            ],)
          ],
        ),

        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  methodPayment = 1;
                });
              },
              // child: CustomImageView(
              //   imagePath: methodPayment ==1 ?ImageConstant.imgTrue:ImageConstant.iconChoose,
              //   height: 20.h,
              //   width: 25.h,
              // ),
              child: methodPayment == 1
                  ? CustomImageView(
                      imagePath: ImageConstant.imgTrue,
                      height: 20.h,
                      width: 25.h,
                    )
                  : point(),
            ),
            sizeWidthNormal(),
            Text(
              "تحويل بنكي ",
              style: themeLite.textTheme.titleSmall!
                  .copyWith(fontSize: AppFontSize.fontSize_15),
            ),
            Text(
              "(أرفق ملف):",
              style: themeLite.textTheme.titleSmall!.copyWith(
                  fontSize: AppFontSize.fontSize_15,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        sizeHeightNormal(),
        methodPayment != 1
            ? Container()
            : GestureDetector(
                onTap: () {
                  // AddAdsCubit.get(context).loadImages();
                },
                child: Container(
                  width: 350.h,
                  height: 150.h,
                  decoration: AppDecoration.outlinePurple,
                  child:

                      //         CustomImageView(
                      //
                      // ),
                      ClipRRect(
                    borderRadius: BorderRadius.circular(25.h),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 350.w,
                          height: 150.h,
                          // child: Image.file(
                          //   File(AddAdsCubit.get(context).fileLicense!.path),
                          //   fit: BoxFit.fill,
                          // ),
                        ),
                        Icon(
                          Icons.add,
                          color: appTheme.defaultPrimaryColor,
                          size: 25.h,
                        )
                      ],
                    ),
                  ),
                ),
              ),
        methodPayment != 1
            ? Container()
            : SizedBox(
                height: 20.h,
              ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  methodPayment = 2;
                });
              },
              child:
                 methodPayment == 2
    ? CustomImageView(
    imagePath: ImageConstant.imgTrue,
    height: 20.h,
    width: 25.h,
    )
        : point(),
            ),
            sizeWidthNormal(),
            Text(
              "دفع فيزا:",
              style: themeLite.textTheme.titleSmall!.copyWith(fontSize: 15.sp),
            ),
          ],
        ),
        methodPayment != 2
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "رقم البطاقة",
                    style: themeLite.textTheme.titleSmall!
                        .copyWith(fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextFormField(
                    hintText: '0000 0000 0000 0000',
                    fillColor: appTheme.buttonColor,
                    prefix: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: iconPng(iconPng: ImageConstant.iconVisa),
                    ),
                    hintStyle: themeLite.textTheme.titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "الاسم:",
                    style: themeLite.textTheme.titleSmall!.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextFormField(
                    fillColor: appTheme.buttonColor,
                    // prefix: iconPng(iconPng: ImageConstant.iconVisa),
                    hintStyle: themeLite.textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "تاريخ الانتهاء:",
                            style: themeLite.textTheme.titleSmall!
                                .copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          CustomTextFormField(
                            width: 150.h,
                            fillColor: appTheme.buttonColor,
                            hintStyle: themeLite.textTheme.titleSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الرمز السري (CVV):",
                            style: themeLite.textTheme.titleSmall!
                                .copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          CustomTextFormField(
                            width: 150.h,
                            fillColor: appTheme.buttonColor,
                            hintStyle: themeLite.textTheme.titleSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
        SizedBox(
          height: 10.h,
        ),

        isShowErrorForPay
            ? SizedBox(
                height: 10.h,
              )
            : Container(),
        isShowErrorForPay
            ? textNormal(text: 'يرجى اختيار باقة معينة ..', color: Colors.red)
            : Container(),
        SizedBox(
          height: 40.h,
        ),
        isPaymentPackage
            ? Padding(
                padding: EdgeInsets.only(left: 155.w, right: 155.w),
                child: loaderNormal(),
              )
            : InkWell(
                onTap: () {
                  if (widget.isFromPackage) {
                    PaymentCubit.get(context)
                        .paymentForPackage(idPackage: widget.idPackage!);
                  } else if (widget.isFromAds) {
                    if (packageId == -1) {
                      setState(() {
                        isShowErrorForPay = true;
                      });
                    } else {
                      PaymentCubit.get(context).paymentAdsByPackage(
                          packageId: packageId,
                          priceAds: widget.priceAdsAndBanner!,
                          idAds: widget.adsModel!.data!.adsId!,
                          paymentMethod: 'C');
                    }
                  }

                  // showChats(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  height: 40.h,
                  decoration: AppDecoration.outlineButton,
                  child: Center(
                      child: widget.priceAdsAndBanner == null
                          ? Text(
                              'دفع الآن',
                              style: themeLite.textTheme.titleSmall!
                                  .copyWith(color: Colors.white),
                            )
                          : methodPayment==3 ? Text(
                        // 'خصم من الباقة ${widget.priceAdsAndBanner!}',
                        'خصم من الباقة ',
                        style: themeLite.textTheme.titleSmall!
                            .copyWith(color: Colors.white),
                      ):Text(
                              'دفع الآن ${widget.priceAdsAndBanner!}',
                              style: themeLite.textTheme.titleSmall!
                                  .copyWith(color: Colors.white),
                            )),
                ),
              ),
        SizedBox(
          height: 400.h,
        ),
      ],
    );
  }

  void showChats(BuildContext context) {
    // PaymentCubit cubit = BlocProvider.of<PaymentCubit>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => HomeCubit(),
          child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {
              if (state is LoadingPayForAdsSpecialFeaturesState) {}
              if (state is SuccessPayForAdsSpecialFeaturesState) {
                SnackBarHelper.mySnackBarSuccess(
                    state.packageModel!.message.toString(), context);
                Navigator.pop(context);
                // Navigator.pop(context);
              }
              if (state is ErrorPayForAdsSpecialFeaturesState) {
                SnackBarHelper.mySnackBarError(state.error.toString(), context);
              }
            },
            builder: (context, state) {
              HomeCubit cubit = HomeCubit.get(context);
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Form(
                  key: _formKey2,
                  child: AlertDialog(
                    backgroundColor: appTheme.buttonColor,
                    title: Text(
                      'دفع من أجل تمييز الإعلان',
                      style: themeLite.textTheme.titleSmall,
                    ),
                    content: Container(
                      height: methodPayment == 1
                          ? 300.h
                          : methodPayment == 2
                              ? 345.h
                              : 120.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    methodPayment = 1;
                                  });
                                },
                                child: methodPayment == 1 ? CustomImageView(
                      imagePath: ImageConstant.imgTrue,
                      height: 20.h,
                      width: 25.h,    color:Colors.black ,
                    )
                          : point(),
                              ),
                              sizeWidthNormal(),
                              Text(
                                "تحويل بنكي ",
                                style: themeLite.textTheme.titleSmall!.copyWith(
                                    fontSize: AppFontSize.fontSize_15),
                              ),
                              Text(
                                "(أرفق ملف):",
                                style: themeLite.textTheme.titleSmall!.copyWith(
                                    fontSize: AppFontSize.fontSize_15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          sizeHeightNormal(),
                          methodPayment != 1
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    // AddAdsCubit.get(context).loadImages();
                                  },
                                  child: Container(
                                    width: 350.h,
                                    height: 150.h,
                                    decoration: AppDecoration.outlinePurple,
                                    child:

                                        //         CustomImageView(
                                        //
                                        // ),
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(25.h),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 350.w,
                                            height: 150.h,
                                            // child: Image.file(
                                            //   File(AddAdsCubit.get(context).fileLicense!.path),
                                            //   fit: BoxFit.fill,
                                            // ),
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: appTheme.defaultPrimaryColor,
                                            size: 25.h,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          // methodPayment !=1 ?Container(): SizedBox(
                          //   height: 20.h,
                          // ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    methodPayment = 2;
                                  });
                                },
                                child:  methodPayment == 2 ? CustomImageView(
                                  imagePath: ImageConstant.imgTrue,
                                  height: 20.h,
                                  width: 25.h,    color:Colors.black ,
                                )
                                    : point(),
                              ),
                              sizeWidthNormal(),
                              Text(
                                "دفع فيزا:",
                                style: themeLite.textTheme.titleSmall!
                                    .copyWith(fontSize: 15.sp),
                              ),
                            ],
                          ),
                          methodPayment != 2
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "رقم البطاقة",
                                      style: themeLite.textTheme.titleSmall!
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextFormField(
                                      hintText: '0000 0000 0000 0000',
                                      fillColor: appTheme.buttonColorBorder,
                                      prefix: Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: iconPng(
                                            iconPng: ImageConstant.iconVisa),
                                      ),
                                      hintStyle: themeLite.textTheme.titleSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "الاسم:",
                                      style: themeLite.textTheme.titleSmall!
                                          .copyWith(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextFormField(
                                      fillColor: appTheme.buttonColorBorder,
                                      // prefix: iconPng(iconPng: ImageConstant.iconVisa),
                                      hintStyle: themeLite.textTheme.titleSmall!
                                          .copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "تاريخ الانتهاء:",
                                              style: themeLite
                                                  .textTheme.titleSmall!
                                                  .copyWith(fontSize: 12.sp),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            CustomTextFormField(
                                              width: 120.h,
                                              fillColor:
                                                  appTheme.buttonColorBorder,
                                              hintStyle: themeLite
                                                  .textTheme.titleSmall!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "الرمز السري (CVV):",
                                              style: themeLite
                                                  .textTheme.titleSmall!
                                                  .copyWith(fontSize: 12.sp),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            CustomTextFormField(
                                              width: 120.h,
                                              fillColor:
                                                  appTheme.buttonColorBorder,
                                              hintStyle: themeLite
                                                  .textTheme.titleSmall!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          sizeHeightNormal(),
                          state is LoadingPayForAdsSpecialFeaturesState
                              ? loaderNormal()
                              : Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        cubit.payForAdsSpecialFeatures(
                                          idAdSpecialFeature: widget
                                              .idSelectedAdsSpecialFeatures!,
                                          priceSpecialFeature:
                                              widget.priceAdsSpecialFeatures!,
                                          idAds: widget.adsModel!.data!.adsId!,
                                          paymentMethod: methodPayment == 2
                                              ? 'B'
                                              : methodPayment == 1
                                                  ? 'A'
                                                  : 'A',
                                        );
                                        // Navigator.pop(context);
                                      },
                                      child: Center(
                                          child: Container(
                                        width: 110.h,
                                        height: 40.h,
                                        decoration: AppDecoration
                                            .outlineSelectedLite
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.h)),
                                        child: Center(
                                          child: textNormal(text: 'الدفع الآن'),
                                        ),
                                      )),
                                    ),
                                    sizeWidthNormal(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Center(
                                          child: Container(
                                        width: 110.h,
                                        height: 40.h,
                                        decoration: AppDecoration
                                            .outlineSelectedLite
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.h)),
                                        child: Center(
                                          child:
                                              textNormal(text: 'الدفع لاحقاً'),
                                        ),
                                      )),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        );
      },
    );
  }

  int? selectedAdsSpecialFeatures = 0;
  int methodPayment = 3;
  int packageId = -1;
  bool isShowErrorForPay = false;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

}
