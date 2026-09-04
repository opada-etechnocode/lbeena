
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/cart/widget/item_order.dart';
import 'package:syrians_in_uae/ui/screens/cart/widget/shimmer_item_cart.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/theme_helper.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class OrderPage extends StatefulWidget {
  OrderPage({super.key,this.idOrderFromNotification,required this.isMyOrderRequests});
int? idOrderFromNotification;
bool isMyOrderRequests;
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // CartDate? data;

  bool isLoadingDate = true;
int page =1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: textNormal(text: 'رقم موبايل',fontSize: 10.fSize), value: 0,),

      DropdownMenuItem(child: textNormal(text: "رقم الطلبية",fontSize: 10.fSize), value:1),
    ];
    return menuItems;
  }

  int typeSearch =0;

  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _TowFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBarNormalWithIcon( context:context,text: widget.isMyOrderRequests?'الطلبات الواردة': 'طلباتي',isShowBack: true),
        body: BlocProvider(
          create: (context) => CartCubit()..getMyOrder(
            page: 1,
            isActiveLoader: false,
            myOrderRequests: widget.isMyOrderRequests
          ),
          child: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is LoadingMyOrderState) {
                isLoadingDate = true;
              }
              if (state is SuccessMyOrderState) {
                // data= state.data.data;
                isLoadingDate = false;
              }
              if (state is ErrorMyOrderState) {
                isLoadingDate = false;
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  sizeHeightNormal(height: 5.h),
              if(widget.isMyOrderRequests)...{
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      children: [

                        Expanded(
                          flex: 2,
                          child: CustomSearchView(
                          controller: CartCubit.get(context).searchTfController,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.search,
                            focusNode: _TowFocusNode,
                            onFieldSubmitted: (v){
                              CartCubit.get(context).getSearchMyOrder(page: 1, type: typeSearch, search: v,
                                  isActiveLoader: false);
                            },
                            onChanged: (v){
                            if(v.length >1){
                              CartCubit.get(context).getSearchMyOrder(page: 1, type: typeSearch, search: v,
                                  isActiveLoader: false);
                            }else  if(v ==''){
                              CartCubit.get(context).getSearchMyOrder(page: 1, type: typeSearch, search: v,
                                  isActiveLoader: false);
                            }

                            },

                          ),
                        ),
                        sizeWidthNormal(
                          width: 5.w
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(height: 35.h,
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 1),
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 1),
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                filled: true,
                                fillColor: appTheme.lightBlue100,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h, // تعديل الارتفاع
                                  horizontal: 12.w, // تعديل الحشوة الجانبية
                                ),
                              ),
                              dropdownColor: appTheme.lightBlue100,
                              hint: textNormal(text: 'النوع',fontSize: 10.fSize),
                              value: typeSearch ??0,
                              focusNode: _firstFocusNode,

                              // style: themeLite.textTheme.titleSmall!.copyWith(
                              //   fontSize: AppFontSize.fontSize_8,
                              // ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  typeSearch = newValue!;
                                });
                              },
                              items: dropdownItems,
                            ),
                          ),
                        )

                        ,
                      ],
                    ),
                  ),},
                  Expanded(
                    child: SmartRefreshWidget(
                      onRefresh: () async {
                        CartCubit.get(context).searchTfController.text ='';
                        page =1;
                        await CartCubit.get(context).getMyOrder(
                          page: 1,
                          isActiveLoader: false, myOrderRequests: widget.isMyOrderRequests
                        );

                        _refreshController
                            .refreshCompleted();
                      },
                      controller: _refreshController,
                      onLoading: ()async {
                        page ++;


                        if(CartCubit.get(context).searchTfController.text.isNotEmpty){
                          await CartCubit.get(context).getSearchMyOrder(page: page, type: typeSearch, search: CartCubit.get(context).searchTfController.text,
                              isActiveLoader: true);
                        }else {
                          await CartCubit.get(context).getMyOrder(
                              page: page,
                              isActiveLoader: true, myOrderRequests: widget.isMyOrderRequests
                          );
                        }
                        _refreshController.loadComplete();
                      },

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  children: [
                                    if (isLoadingDate) ...{
                                      ShimmerItemCart(
                                        isOrderPage: true,
                                      ),
                                    } else ...{
                                      Padding(
                                        padding: EdgeInsets.all(8.r),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  typeAds = 1;
                                                });
                                              },
                                              text:   'غير  مكتملة',
                                              width: 150.w,
                                              height: 30.h,
                                              buttonTextStyle: themeLite.textTheme.titleSmall!
                                                  .copyWith(
                                                  color:typeAds == 1
                                                      ? Colors.white
                                                      : appTheme.black900,
                                                  fontSize: 12.fSize),
                                              buttonStyle: CustomButtonStyles.baseBorderButton
                                                  .copyWith(
                                                backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                  typeAds != 1
                                                      ? appTheme.lightBlue100
                                                      : appTheme.blueGray,),
                                              ),
                                            ),
                                            sizeWidthNormal(),
                                            CustomElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  setState(() {
                                                    typeAds = 2;
                                                  });
                                                });
                                              },
                                              text:     'مكتملة',
                                              width: 150.w,
                                              height: 30.h,
                                              buttonStyle: CustomButtonStyles.baseBorderButton
                                                  .copyWith(
                                                backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                  typeAds != 2
                                                      ? appTheme.lightBlue100
                                                      : appTheme.blueGray,),
                                              ),
                                              buttonTextStyle: themeLite.textTheme.titleSmall!
                                                  .copyWith(
                                                  color:   typeAds == 2
                                                      ? Colors.white
                                                      : appTheme.black900,
                                                  fontSize: 12.fSize),
                                            ),


                                          ],
                                        ),
                                      ),
                                      if(typeAds ==2)...{
                                        if (CartCubit.get(context).orderList.isEmpty) ...{
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 300.h),
                                            child: textNormal(
                                              text:
                                              'لايوجد طلبات بعد ..',),
                                          ),
                                        },
                                        CartCubit.get(context).orderList.isEmpty
                                            ? Container()
                                            :  ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: CartCubit.get(context).orderList.length,
                                            itemBuilder: (context, index) {
                                              return OrderItem(
                                                index: index,
                                                idOrder: widget.idOrderFromNotification,
                                                isCompany: widget.isMyOrderRequests,   typeAds: typeAds,
                                              );
                                            }),
                                      }else ...{
                                        if (CartCubit.get(context).orderNotCompletedList.isEmpty) ...{
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 300.h),
                                            child: textNormal(
                                              text:
                                              'لايوجد طلبات بعد ..',),
                                          ),
                                        },
                                        CartCubit.get(context).orderNotCompletedList.isEmpty
                                            ? Container()
                                            :  ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: CartCubit.get(context).orderNotCompletedList.length,
                                            itemBuilder: (context, index) {
                                              return OrderItem(
                                                index: index,
                                                idOrder: widget.idOrderFromNotification,
                                                isCompany: widget.isMyOrderRequests,
                                                typeAds: typeAds,
                                              );
                                            }),
                                      }

                                    },
                                  ],
                                ),
                              ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  bool isPressingAdsArchived = false;
  int typeAds = 1;
}
