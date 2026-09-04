class OrderUserModel {
  OrderUserModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final Data? data;

  factory OrderUserModel.fromJson(Map<String, dynamic> json){
    return OrderUserModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<OrdersList>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<OrdersList>.from(json["data"]!.map((x) => OrdersList.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

}

class OrdersList {
  OrdersList({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.cartId,
    required this.userId,
    required this.paymentMethod,
    required this.status,
    required this.totalPrice,
    required this.customerFirstName,
    required this.customerLastName,
    required this.phone,
    required this.countryCode,
    required this.location,
    required this.userIdBuy,
    required this.statusOrder,
    required this.items,
    required this.note,
  });

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? cartId;
  final int? userId;
  final String? paymentMethod;
  final String? status;
  final String? totalPrice;
  final String? customerFirstName;
  final dynamic customerLastName;
  final String? phone;
  final String? countryCode;
  final String? location;
  final String? note;
  final int? userIdBuy;
  final int? statusOrder;
  final List<Item> items;

  factory OrdersList.fromJson(Map<String, dynamic> json){
    return OrdersList(
      id: json["id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      cartId: json["cart_id"],
      userId: json["user_id"],
      paymentMethod: json["payment_method"],
      status: json["status"],
      totalPrice: json["total_price"],
      customerFirstName: json["customer_first_name"],
      customerLastName: json["customer_last_name"],
      phone: json["phone"],
      countryCode: json["country_code"],
      location: json["location"],
      userIdBuy: json["user_id_buy"],
      note: json["note"],
      statusOrder: json["status_order"],
      items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );
  }

  OrdersList copyWith({
    List<Item>? items,
  }) {
    return OrdersList(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      cartId: cartId,
      userId: userId,
      paymentMethod: paymentMethod,
      status: status,
      totalPrice: totalPrice,
      customerFirstName: customerFirstName,
      customerLastName: customerLastName,
      phone: phone,
      countryCode: countryCode,
      location: location,
      userIdBuy: userIdBuy,
      note: note,
      statusOrder: statusOrder,
      items: items ?? this.items, // تحديث القائمة فقط
    );
  }
}

class Item {
  Item({
    required this.id,
    required this.statusOrder,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.imageNames,
    required this.bannerName,
    required this.bannerImage,
    required this.companyName,
    this.statusOrderName,
  });

  final int? id;
  final int? statusOrder;
   String? statusOrderName;
  final int? productId;
  final int? quantity;
  final String? price;
  final String? productName;
  final List<String> imageNames;
  final String? bannerName;
  final String? companyName;
  final String? bannerImage;

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id: json["id"],
      statusOrder: json["status_order"],
      productId: json["product_id"],
      companyName: json["company_name"],
      quantity: json["quantity"],
      price: json["price"],
      productName: json["product_name"],
      imageNames: json["image_names"] == null ? [] : List<String>.from(json["image_names"]!.map((x) => x)),
      bannerName: json["banner_name"],
      bannerImage: json["banner_image"],
    );
  }

}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }

}
