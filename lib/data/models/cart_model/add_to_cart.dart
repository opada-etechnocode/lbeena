class AddToCartModel {
  AddToCartModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final Data? data;

  factory AddToCartModel.fromJson(Map<String, dynamic> json){
    return AddToCartModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  final int? cartId;
  final String? productId;
  final String? quantity;
  final String? price;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      cartId: json["cart_id"],
      productId: json["product_id"],
      quantity: json["quantity"],
      price: json["price"],
    );
  }

}
