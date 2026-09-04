import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/cart/widget/item_cart.dart';
import 'package:syrians_in_uae/ui/screens/cart/widget/shimmer_item_cart.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/sources/cart/cart_data_source.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../theme/theme_helper.dart';
import '../auth/login/model_home_page.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key,this.isShowBack});

  bool? isShowBack;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // CartDate? data;

  bool isLoadingDate = false;
  bool isLoadingCreateOrder = false;

  int activeStep = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController(
    text: DIManager.findDep<SharedPrefs>().getAccountType() == 'company'?  DIManager.findDep<SharedPrefs>().getUserNameCompany():DIManager.findDep<SharedPrefs>().getUserName(),
  );
  TextEditingController locationController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController numberCardController = TextEditingController();
  TextEditingController expiredCardController = TextEditingController();
  TextEditingController cvvCardController = TextEditingController();

  TextEditingController mobileNumberController = TextEditingController(
    text: DIManager.findDep<SharedPrefs>().getMobileNumber() ?? '',
  );

  @override
  void initState() {
    loadData();
    if(CartCubit.get(context).dataCart ==null && DIManager.findDep<SharedPrefs>().getToken() != null ){
      isLoadingDate = true;
      CartCubit.get(context).getMyCart();

    }
    super.initState();
  }
  HomePageLoginModel? homePageData;
  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
      print("homePageData : ${homePageData!.homePageModel!.data!.adsBanner.length}");
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode expiredCardFocusNode = FocusNode();
  final FocusNode numberFocusNode = FocusNode();
  final FocusNode cvvFocusNode = FocusNode();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  String? token = DIManager.findDep<SharedPrefs>().getToken();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      FocusScope.of(context).unfocus();
    },
      child: Scaffold(
        appBar: appBarNormalWithIcon( context:context,text: 'سلة المشتريات',isShowBack: widget.isShowBack??false),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is LoadingMyCartState) {
              isLoadingDate = true;
            }
            if (state is SuccessMyCartState) {
              // data= state.data.data;
              isLoadingDate = false;
            }
            if (state is ErrorMyCartState) {
              isLoadingDate = false;
            }
            if(state is LoadingCreateOrderState){
              isLoadingCreateOrder =true;
            }
            if(state is SuccessCreateOrderState){
              isLoadingCreateOrder =false;
              SnackBarHelper.mySnackBarSuccess(state.data.message, context);
              navigatorToPushReplacementUntil(
                  context: context, location: '/homePage',
                  extra:homePageData
              );
            }
            if(state is ErrorCreateOrderState){
              isLoadingCreateOrder =false;
              SnackBarHelper.mySnackBarError(state.message, context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: token == null
                  ? buildGoToLogin(
                  context)
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(CartCubit.get(context).dataCart == null)...{
                    Center(
                      child:  Padding(
                        padding: EdgeInsets.symmetric(vertical: 300.h),
                        child: textNormal(
                            text:
                            'لايوجد منتجات في سلة المشتريات بعد ..'),
                      ),
                    ),

                  }else...{
                  sizeHeightNormal(),
                    if(CartCubit.get(context).dataCart?.items.length !=0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 55.w,
                              height: 1.h,
                              color: appTheme.greenColor,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  activeStep = 0;
                                });
                              },
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: appTheme.greenColor,
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: activeStep == 0
                                      ? appTheme.colorPoint
                                      : appTheme.scaffoldBackgroundColor100,
                                ),
                              ),
                            ),
                            Container(
                                width: 80.w,
                                height: 1.h,
                                color: appTheme.greenColor),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  activeStep = 1;
                                });
                              },
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: appTheme.greenColor,
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: activeStep == 1
                                      ? appTheme.colorPoint
                                      : appTheme.scaffoldBackgroundColor100,
                                ),
                              ),
                            ),
                            Container(
                              width: 80.w,
                              height: 1.h,
                              color: appTheme.greenColor,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  // activeStep =2;
                                });
                              },
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: appTheme.greenColor,
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: activeStep == 2
                                      ? appTheme.colorPoint
                                      : appTheme.scaffoldBackgroundColor100,
                                ),
                              ),
                            ),
                            Container(
                              width: 55.w,
                              height: 1.h,
                              color: appTheme.greenColor,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (activeStep == 0) ...{
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            if (isLoadingDate) ...{
                              ShimmerItemCart(),
                            } else ...{
                              if (CartCubit.get(context).dataCart?.items.length ==
                                  0) ...{
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 300.h),
                                  child: textNormal(
                                      text:
                                      'لايوجد منتجات في سلة المشتريات بعد ..'),
                                ),
                              },
                              CartCubit.get(context).dataCart?.items.length == 0
                                  ? Container()
                                  : Container(
                                height: 520.h,
                                child: SmartRefreshWidget(
                                  onRefresh: () async {
                                    await CartCubit.get(context).getMyCart();
              
                                    _refreshController
                                        .refreshCompleted();
                                  },
                                  enablePullUp: false,
                                  controller: _refreshController,
              
                                  onLoading: () {  },
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: CartCubit.get(context)
                                          .dataCart
                                          ?.items
                                          .length,
                                      itemBuilder: (context, index) {
                                        return ItemCart(
                                          index: index,
                                        );
                                      }),
                                ),
                              ),
                            },
                            isLoadingDate
                                ? Container()
                                : CartCubit.get(context).dataCart!.items.length == 0
                                ? Container()
                                : CustomElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    activeStep += 1;
                                  });
                                },
                                text:
                                'التالي ${CartCubit.get(context).dataCart!.totalPrice} د.إ')
                          ],
                        ),
                      ),
                    },
                    if (activeStep == 1 ) ...{
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                textNormal(text: "تـأكيد معلوماتك الشخصية:"),

                                sizeHeightNormal(),
                                CustomTextFormField(
                                  controller: firstNameController,
                                  focusNode: _secondFocusNode,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .field_is_empty;
                                    }
                                    return null;
                                  },
                                  hintText: 'أضف الاسم هنا ..',
                                ),

                                sizeHeightNormal(),
                                CustomTextFormField(
                                  controller: mobileNumberController,
                                  readOnly: true,
                                ),

                                sizeHeightNormal(),
                                CustomTextFormField(
                                  controller: locationController,
                                  focusNode: _firstFocusNode,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .field_is_empty;
                                    }
                                    return null;
                                  },
                                  hintText: 'تفاصيل العنوان ..',
                                  maxLines: null,
                                ),
                                sizeHeightNormal(),
                                CustomTextFormField(
                                  focusNode: _noteFocusNode,
                                  controller: noteController,
                                  hintText: 'ملاحظة ..',
                                  maxLines: null,
                                ),
                                SizedBox(
                                  height: 80.h,
                                ),
                                CustomElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          activeStep += 1;
                                        });
                                      }
                                    },
                                    text: 'تأكيد')
                              ],
                            ),
                          ),
                        ),
                      )
                    },
                    if (activeStep == 2) ...{
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textNormal(text: 'إختيار طريقة الدفع:'),
                   Row(children: [
                      Checkbox(value: true, onChanged: (value){},
                        activeColor: appTheme.greenColor,
                        checkColor: Colors.white,
                      ),
                     textNormal(text: "الدفع عند الإستلام",
                         fontSize: 16.fSize,
                         fontWeight: FontWeight.w600),
                   ],
                   ),
                              // textNormal(text: "معلومات الدفع"),
                              // sizeHeightNormal(height: 20.h),
                              // textNormal(
                              //     text: 'رقم البطاقة: ',
                              //     fontWeight: FontWeight.w400),
                              // sizeHeightNormal(),
                              // CustomTextFormField(
                              //   controller: numberCardController,
                              //   focusNode: numberFocusNode,
                              //   validator: (text) {
                              //     if (text == null || text.isEmpty) {
                              //       return AppLocalizations.of(context)!
                              //           .field_is_empty;
                              //     }
                              //     return null;
                              //   },
                              //   hintText: 'أضف الرقم هنا ..',
                              // ),
                              // sizeHeightNormal(height: 20.h),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Padding(
                              //           padding:
                              //           EdgeInsets.symmetric(horizontal: 10.w),
                              //           child: textNormal(
                              //               text: 'تاريخ الصلاحية: ',
                              //               fontWeight: FontWeight.w400),
                              //         ),
                              //         sizeHeightNormal(),
                              //         CustomTextFormField(
                              //           width: 220.w,
                              //           controller: expiredCardController,
                              //           focusNode: expiredCardFocusNode,
                              //           validator: (text) {
                              //             if (text == null || text.isEmpty) {
                              //               return AppLocalizations.of(context)!
                              //                   .field_is_empty;
                              //             }
                              //             return null;
                              //           },
                              //           hintText: '                      MM\\YY',
                              //         ),
                              //       ],
                              //     ),
                              //     sizeWidthNormal(width: 20.w) ,
                              //     Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Padding(
                              //           padding:
                              //           EdgeInsets.symmetric(horizontal: 10.w),
                              //           child: textNormal(
                              //               text: 'رمز الأمان: ',
                              //               fontWeight: FontWeight.w400),
                              //         ),
                              //         sizeHeightNormal(),
                              //         CustomTextFormField(
                              //           width: 100,
                              //           controller: cvvCardController,
                              //           focusNode: cvvFocusNode,
                              //           validator: (text) {
                              //             if (text == null || text.isEmpty) {
                              //               return AppLocalizations.of(context)!
                              //                   .field_is_empty;
                              //             }
                              //             return null;
                              //           },
                              //           hintText: '       CVV',
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 80.h,
                              ),
                             CustomElevatedButton(
                                isDisabled: isLoadingCreateOrder?true:false,
                                  child: isLoadingCreateOrder? loadingButton():null,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      CartCubit.get(context).createOrder(order:
                                      OrderParameterModel(cart_id: CartCubit.get(context).dataCart!.cartId!, name: firstNameController.text, phone: mobileNumberController.text, location: locationController.text,note: noteController.text ));
                                    }
                                  },
                                  text:
                                  'إدفع ${CartCubit.get(context).dataCart!.totalPrice} د.إ')
                            ],
                          ),
                        ),
                      )
                    },
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
