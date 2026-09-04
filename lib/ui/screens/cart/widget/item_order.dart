
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import '../../../../core/constants/app_font.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../data/models/cart_model/order_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../cubit/cart_cubit.dart';

class OrderItem extends StatefulWidget {
  OrderItem(
      {super.key, required this.index, this.idOrder, required this.isCompany,required this.typeAds});

  // ItemCartList data;
  int index;
  int? idOrder;
  bool isCompany;
  int typeAds;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  String? status;

  int? statusId;

  String id = '38';

  double calculateTotalCost(List<Item> items) {
    double total = 0.0;

    for (var item in items) {
      double price = double.tryParse(item.price ?? "0") ?? 0.0;
      int quantity = item.quantity ?? 0;

      total += price * quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    // print('id order1 : ${CartCubit.get(context).orderList[widget.index].id.toString()}');
    // print('id order : ${widget.idOrder.toString()}');

    List<OrdersList> dataList = widget.typeAds !=2? CartCubit.get(context).orderNotCompletedList: CartCubit.get(context).orderList;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        decoration: AppDecoration.itemCart.copyWith(
          color: widget.idOrder == null
              ? null
              : dataList[widget.index].id.toString() ==
                      widget.idOrder.toString()
                  ? appTheme.containerCart.withOpacity(.2)
                  : null,
          border: Border.all(
            color: appTheme.greenColor,
            width: 0.4, // يمكنك تعديل عرض الحدود حسب الرغبة
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!widget.isCompany) ...{
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textNormal(
                              text: 'رقم الطلبية: ',
                            ),
                            textNormal(
                              text: '#${dataList[widget.index].id.toString()}',
                            ),
                          ],
                        )),
                  },
                  if (widget.isCompany) ...{
                    itemTextOrder(
                        title: 'رقم الطلبية: ',
                        titleApi: '#${dataList[widget.index].id.toString()}',
                        width: 140.w),
                    // Spacer(),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 14.w, right: 62.w),
                        child: Container(
                          decoration: AppDecoration.itemCartNew.copyWith(
                              // color: appTheme.colorAppBar
                              ),
                          child: Padding(
                            padding: EdgeInsets.all(6.sp),
                            child: Center(
                              child: dataList[widget.index]
                                      .phone
                                      .toString()
                                      .contains('971')
                                  ? textNormal(
                                      text:
                                          '${dataList[widget.index].phone.toString()}+',
                                      fontSize: AppFontSize.fontSize_12,
                                      color: appTheme.black900.withOpacity(.6))
                                  : textNormal(
                                      text:
                                          '971${dataList[widget.index].phone.toString()}+',
                                      fontSize: AppFontSize.fontSize_12,
                                      color: appTheme.black900.withOpacity(.6)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  }
                ],
              ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataList[widget.index].items.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return  itemOrderWidget(i);
                  }),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.sp, vertical: 3.sp),
                    child: Container(
                      width: 202.w,
                      decoration: AppDecoration.itemCartNew.copyWith(
                          // color: appTheme.colorAppBar.withOpacity(.2),
                          ),
                      child: Padding(
                        padding: EdgeInsets.all(6.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textNormal(
                                text: 'التكلفة الإجمالية: ',
                                fontWeight: FontWeight.w700,
                                color: appTheme.black900.withOpacity(.8),
                                fontSize: AppFontSize.fontSize_12),
                            Container(
                              width: 80.w,
                              child: textNormal(
                                  text:
                                      '${calculateTotalCost(dataList[widget.index].items).toString()} د.إ',
                                  fontWeight: FontWeight.w700,
                                  maxLines: 3,
                                  color: appTheme.black900.withOpacity(.6),
                                  fontSize: AppFontSize.fontSize_12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // itemTextOrder(
                  //   title:'التكلفة الإجمالية: ',
                  //   titleApi: '${CartCubit.get(context)
                  //       .dataOrder!
                  //       .data[widget.index].totalPrice.toString()} د.إ',
                  //    width: (CartCubit.get(context)
                  //        .dataOrder!
                  //        .data[widget.index].totalPrice.toString().length * 9.w) +150.w
                  // ),
                  // Spacer(),
                  Container(
                    width: 120.w,
                    decoration: AppDecoration.itemCartNew.copyWith(
                        // color:  appTheme.colorAppBar.withOpacity(.2),
                        ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
                      child: Center(
                        child: textNormal(
                          text: convertDateTime(
                       dataTimeValue:       dataList[widget.index].createdAt!.toString(),
                          ),fontSize: 12.fSize,
                          color: appTheme.black900.withOpacity(.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              itemTextOrder(
                  title: 'العنوان: ',
                  titleApi: dataList[widget.index].location.toString(),
                  width: 400.w),

              dataList[widget.index].note==null?Container():  itemTextOrder(
                  title: 'ملاحظة: ',
                  titleApi: dataList[widget.index].note.toString(),
                  width: 400.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemOrderWidget(i) {
    List<OrdersList> dataList = widget.typeAds !=2? CartCubit.get(context).orderNotCompletedList:  CartCubit.get(context).orderList;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dataList[widget.index].items[i].imageNames!.isNotEmpty
                  ? CustomImageView(
                      imagePath: dataList[widget.index]
                              .items[i]
                              .imageNames![0]
                              .contains('https')
                          ? dataList[widget.index].items[i].imageNames![0]
                          : '${AppEndpoints.baseUrlWithoutApi}/${dataList[widget.index].items[i].imageNames![0]}',
                      width: 80.w,
                      height: 90.h,
                      fit: BoxFit.fill,
                      radius: BorderRadius.circular(4.sp),
                    )
                  : dataList[widget.index].items[i].bannerImage == null
                      ? Container()
                      : CustomImageView(
                          imagePath: dataList[widget.index]
                                  .items[i]
                                  .bannerImage!
                                  .contains('https')
                              ? dataList[widget.index].items[i].bannerImage!
                              : '${AppEndpoints.baseUrlWithoutApi}/${dataList[widget.index].items[i].bannerImage!}',
                          width: 80.w,
                          height: 90.h,
                          fit: BoxFit.fill,
                          radius: BorderRadius.circular(4.sp),
                        ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        child: textNormal(
                            text: dataList[widget.index].items[i].productName ??
                                '',
                            fontSize: AppFontSize.fontSize_14),
                      ),
                      sizeHeightNormal(height: 2.h),
                      Row(
                        children: [
                          if (!widget.isCompany) ...{
                            textNormal(
                                text: 'البائع: ',
                                fontWeight: FontWeight.w400,
                                fontSize: AppFontSize.fontSize_12),
                            Container(
                                width: 80.w,
                                child: textNormal(
                                    text: dataList[widget.index]
                                            .items[i]
                                            .companyName ??
                                        '',
                                    fontWeight: FontWeight.w400,
                                    fontSize: AppFontSize.fontSize_12)),
                          } else ...{
                            textNormal(
                                text: 'الزبون: ',
                                fontWeight: FontWeight.w400,
                                fontSize: AppFontSize.fontSize_12),
                            Container(
                                width: 80.w,
                                child: textNormal(
                                    text: dataList[widget.index]
                                        .customerFirstName
                                        .toString(),
                                    fontWeight: FontWeight.w400,
                                    fontSize: AppFontSize.fontSize_12)),
                          }
                        ],
                      ),
                      Row(
                        children: [
                          textNormal(
                              text: 'السعر: ',
                              fontWeight: FontWeight.w400,
                              fontSize: AppFontSize.fontSize_12,
                              color: appTheme.containerCart),
                          Container(
                            width: 70.w,
                            child: textNormal(
                                text:
                                    '${dataList[widget.index].items[i].price ?? ''} د.إ',
                                fontSize: AppFontSize.fontSize_12,
                                fontWeight: FontWeight.w400,
                                color: appTheme.containerCart),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      if (!widget.isCompany) ...{
                        Container(
                          decoration: AppDecoration.itemCartNew,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textNormal(
                                    text: 'الحالة: ',
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppFontSize.fontSize_12,
                                    color: appTheme.black900.withOpacity(.8)),
                                textNormal(
                                    text: dataList[widget.index]

                                                .statusOrder ==
                                            0
                                        ? 'في الانتظار'
                                        : dataList[widget.index]

                                                    .statusOrder ==
                                                1
                                            ? 'تحت المعالجة'
                                            : dataList[widget.index]

                                                        .statusOrder ==
                                                    2
                                                ? 'مكتملة'
                                                : 'مرفوضة',
                                    fontWeight: FontWeight.w900,
                                    fontSize: AppFontSize.fontSize_12,
                                    color: dataList[widget.index]

                                                .statusOrder ==
                                            3
                                        ? appTheme.red300
                                        : dataList[widget.index]

                                                    .statusOrder ==
                                                0
                                            ? Colors.amber
                                            : dataList[widget.index]

                                                        .statusOrder ==
                                                    2
                                                ? Colors.green
                                                : appTheme.black900),
                              ],
                            ),
                          ),
                        ),
                      } else ...{
                        dataList[widget.index]
                            .items[i]
                            .statusOrder ==
                            2    ?  Container(
                          decoration: AppDecoration.itemCartNew,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textNormal(
                                    text: 'الحالة: ',
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppFontSize.fontSize_12,
                                    color: appTheme.black900.withOpacity(.8)),
                                sizeWidthNormal(width: 5.w),
                                textNormal(
                                    text: 'مكتملة',
                                    fontWeight: FontWeight.w900,
                                    fontSize: AppFontSize.fontSize_12,
                                    color: Colors.green),
                              ],
                            ),
                          ),
                        ):     Container(
                          decoration: AppDecoration.itemCartNew,
                          width: 120.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: DropdownButtonFormField<String>(
                              value: dataList[widget.index]
                                  .items[i]
                                  .statusOrderName ??
                                  (dataList[widget.index]

                                              .statusOrder ==
                                          0
                                      ? 'في الانتظار'
                                      : dataList[widget.index]

                                                  .statusOrder ==
                                              1
                                          ? 'تحت المعالجة'
                                          : dataList[widget.index]

                                                      .statusOrder ==
                                                  2
                                              ? 'مكتملة'
                                              : 'مرفوضة'),
                              dropdownColor:
                                  appTheme.scaffoldBackgroundColor100,
                              onChanged: (newValue) {
                                setState(() {
                                  dataList[widget.index]
                                      .items[i]
                                      .statusOrderName = newValue!;
                                });
                              },
                              padding: EdgeInsets.zero,
                              items: [
                                DropdownMenuItem(
                                  value: 'في الانتظار',
                                  onTap: () {
                                    setState(() {
                                      statusId = 0;
                                    });
                                    CartCubit.get(context).changeStatusOrder(
                                        orderId:
                                            dataList[widget.index].items[i].id!,
                                        statusOrder: 0);
                                  },
                                  child: textNormal(
                                      text: 'في الانتظار',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.amber,
                                      fontSize: AppFontSize.fontSize_11),
                                ),
                                DropdownMenuItem(
                                  value: 'تحت المعالجة',
                                  onTap: () {
                                    setState(() {
                                      statusId = 1;
                                    });
                                    CartCubit.get(context).changeStatusOrder(
                                        orderId:
                                            dataList[widget.index].items[i].id!,
                                        statusOrder: 1);
                                  },
                                  child: textNormal(
                                      text: 'تحت المعالجة',
                                      fontWeight: FontWeight.w900,
                                      color: appTheme.black900,
                                      fontSize: AppFontSize.fontSize_11),
                                ),
                                DropdownMenuItem(
                                  value: 'مكتملة',
                                  onTap: () {
                                    setState(() {
                                      statusId = 2;
                                    });
                                    CartCubit.get(context).changeStatusOrder(
                                        orderId:
                                            dataList[widget.index].items[i].id!,
                                        statusOrder: 2);
                                  },
                                  child: textNormal(
                                      text: 'مكتملة',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green,
                                      fontSize: AppFontSize.fontSize_11),
                                ),
                                DropdownMenuItem(
                                  value: 'مرفوضة',
                                  onTap: () {
                                    setState(() {
                                      statusId = 3;
                                    });
                                    CartCubit.get(context).changeStatusOrder(
                                        orderId:
                                            dataList[widget.index].items[i].id!,
                                        statusOrder: 3);
                                  },
                                  child: textNormal(
                                      text: 'مرفوضة',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red,
                                      fontSize: AppFontSize.fontSize_11),
                                ),
                              ],
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appTheme.containerCart,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appTheme.containerCart,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      },
                      sizeHeightNormal(height: 5.h),
                      itemTextOrder(
                          title: 'الكمية: ',
                          titleApi: dataList[widget.index]
                              .items[i]
                              .quantity
                              .toString(),
                          width: 120.w),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        dataList[widget.index].items.length == 1
            ? sizeHeightNormal(height: 5.h)
            : Divider(
                color: appTheme.containerCart,
                height: 10,
                thickness: .4,
              ),
      ],
    );
  }

  Widget itemTextOrder({
    required String title,
    required String titleApi,
    double? width,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 3.sp),
      child: Container(
        width: width ?? 180.w,
        decoration: AppDecoration.itemCartNew.copyWith(
            // color: appTheme.colorAppBar.withOpacity(.2),
            ),
        child: Padding(
          padding: EdgeInsets.all(6.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textNormal(
                  text: title,
                  fontWeight: FontWeight.w700,
                  color: appTheme.black900.withOpacity(.8),
                  fontSize: AppFontSize.fontSize_12),
              titleApi.length > 40
                  ? Expanded(
                      child: textNormal(
                          text: titleApi,
                          fontWeight: FontWeight.w700,
                          maxLines: 4,
                          color: appTheme.black900.withOpacity(.6),
                          fontSize: AppFontSize.fontSize_12))
                  : textNormal(
                      text: titleApi,
                      fontWeight: FontWeight.w700,
                      maxLines: 4,
                      color: appTheme.black900.withOpacity(.6),
                      fontSize: AppFontSize.fontSize_12),
            ],
          ),
        ),
      ),
    );
  }
}
