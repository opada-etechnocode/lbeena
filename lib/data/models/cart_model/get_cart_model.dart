
import 'package:syrians_in_uae/widgets/components.dart';

class GetMyCartModel {
  GetMyCartModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final CartDate? data;

  factory GetMyCartModel.fromJson(Map<String, dynamic> json){
    return GetMyCartModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : CartDate.fromJson(json["data"]),
    );
  }

}

class CartDate {
  CartDate({
    required this.cartId,
    required this.totalPrice,
    required this.items,
  });

  final int? cartId;
   String? totalPrice;
   List<ItemCartList> items =<ItemCartList>[];

  factory CartDate.fromJson(Map<String, dynamic> json){
    return CartDate(
      cartId: json["cart_id"],
      totalPrice: json["total_price"].toString().convertResponse(),
      items: json["items"] == null ? [] : List<ItemCartList>.from(json["items"]!.map((x) => ItemCartList.fromJson(x))),
    );
  }

}

class ItemCartList {
  ItemCartList({
    required this.cartItemId,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.productName,
    required this.companyName,
    required this.banner_image,
    required this.imageNames,
  });

  final int? cartItemId;
   int? quantity;
   String? price;
   int? productId;
  final String? productName;
  final String? companyName;
  final String? banner_image;
  final List<String>? imageNames;

  factory ItemCartList.fromJson(Map<String, dynamic> json){
    return ItemCartList(
      cartItemId: json["cart_item_id"],
      quantity: json["quantity"],
      price: json["price"],
      productId: json["product_id"],
      productName: json["product_name"] ==null||json["product_name"] =="null"? json["banner_name"]: json["product_name"],
      companyName: json["company_name"],
      banner_image: json["banner_image"],
      imageNames: json["image_names"] == null ? [] : List<String>.from(json["image_names"]!.map((x) => x)),
    );
  }

}
