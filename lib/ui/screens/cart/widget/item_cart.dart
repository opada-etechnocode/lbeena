
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/endpoints.dart';
import '../../../../data/models/cart_model/get_cart_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../cubit/cart_cubit.dart';

class ItemCart extends StatefulWidget {
   ItemCart({super.key,required this.index});

   // ItemCartList data;
   int index;

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        decoration: AppDecoration.card3d,
        child: Padding(
          padding:  EdgeInsets.all(8.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CartCubit.get(context).dataCart!.items![widget.index].imageNames!.isNotEmpty?   CustomImageView(
                imagePath: CartCubit.get(context).dataCart!.items![widget.index].imageNames![0].contains('https')? CartCubit.get(context).dataCart!.items![widget.index].imageNames![0]:'${AppEndpoints.baseUrlWithoutApi}/${CartCubit.get(context).dataCart!.items![widget.index].imageNames![0]}',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.fill,
                radius: BorderRadius.circular(4.sp),
              ): CartCubit.get(context).dataCart!.items![widget.index].banner_image==null?Container(
                width: 80.w,
                height: 80.w,
              ):CustomImageView(
                imagePath: CartCubit.get(context).dataCart!.items![widget.index].banner_image!.contains('https')? CartCubit.get(context).dataCart!.items![widget.index].banner_image!:'${AppEndpoints.baseUrlWithoutApi}/${CartCubit.get(context).dataCart!.items![widget.index].banner_image!}',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.fill,
                radius: BorderRadius.circular(4.sp),
              ),

              SizedBox(
                width: 10.w,
              ),

              Padding(
                padding:  EdgeInsets.symmetric(vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 100.w,child: textNormal(text: CartCubit.get(context).dataCart!.items![widget.index].productName ??'')),
                    Row(
                      children: [
                        textNormal(text:'البائع: ',fontWeight: FontWeight.w400),
                        Container(
                            width: 100.w,child: textNormal(text: CartCubit.get(context).dataCart!.items![widget.index].companyName ??'',fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Row(
                      children: [
                        textNormal(text: 'السعر: ',fontWeight: FontWeight.w700,
                            color: appTheme.textNew),
                        Container(
                          width: 100.w,
                          child: textNormal(text: '${CartCubit.get(context).dataCart!.items![widget.index].price ??''} د.إ' ,fontWeight: FontWeight.w700,
                              color: appTheme.textNew),
                        ),


                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          CartCubit.get(context).incrementQyt(context,index: widget.index);
                        }, icon: Icon(Icons.add,color: appTheme.black900,)),
                        textNormal(text: CartCubit.get(context).dataCart!.items![widget.index].quantity.toString()),
                        IconButton(onPressed: (){
                          CartCubit.get(context).decrementQyt(index: widget.index);
                        }, icon: Icon(Icons.remove,color: appTheme.black900)),
                      ],
                    ),
                    IconButton(onPressed: (){
                      CartCubit.get(context).deleteItem(idItem: CartCubit.get(context).dataCart!.items[widget.index].cartItemId!,
                      index: widget.index,
                      qyt: CartCubit.get(context).dataCart!.items[widget.index].quantity!,
                      );
                    }, icon: Icon(Icons.delete_outline,color: appTheme.black900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
