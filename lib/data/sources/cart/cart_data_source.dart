
import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/GeneralResult.dart';
import '../../models/auth/otp/otp_model.dart';
import '../../models/cart_model/add_to_cart.dart';
import '../../models/cart_model/get_cart_model.dart';
import '../../models/cart_model/order_model.dart';

abstract class CartDataSource {
  const CartDataSource();
  Future<Result<GetMyCartModel>> getMyCart ();
  Future<Result<GeneralModel>> deleteItem({
    required int idItem
  });
  Future<Result<OrderUserModel>> getSearchMyOrders({
    required int page,
    required int type,
    required String search
  });
  Future<Result<OrderUserModel>> getMyOrders({
    required int page, required bool myOrderRequests,
  });
  Future<Result<GeneralModel>> createOrder({
    required OrderParameterModel order
  });
  Future<Result<GeneralModel>> removeItemFromCart(
      {required int productId,});
  Future<Result<GeneralModel>> changeStatusOrder({
    required int orderId,
    required int status_order
  });
  Future<Result<AddToCartModel>> addToCart(
      {required String productId, required String price});
}

class CartDataSourceImp implements CartDataSource {
  const CartDataSourceImp();

  @override
  Future<Result<GetMyCartModel>> getMyCart() async {
    return await RemoteDataSource.request<GetMyCartModel>(
      converter: (model) => GetMyCartModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.getMyCartUrl}",
    );
  }
  @override
  Future<Result<AddToCartModel>> addToCart(
      {required String productId, required String price}) async {
    return await RemoteDataSource.request<AddToCartModel>(
      converter: (model) => AddToCartModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "product_id": productId,
        "quantity": '1',
        "price": price,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.addToCartUrl}",
    );
  }
  @override
  Future<Result<OrderUserModel>> getMyOrders({
    required int page,
    required bool myOrderRequests,
}) async {
    return await RemoteDataSource.request<OrderUserModel>(
      converter: (model) => OrderUserModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url:!myOrderRequests?"${AppEndpoints.baseUrl}${AppEndpoints.getMyOrderUrl}"'?page=$page': "${AppEndpoints.baseUrl}${AppEndpoints.getMyOrderCompanyUrl}"'?page=$page',
      // url: "${AppEndpoints.baseUrl}${AppEndpoints.getMyOrderUrl}"'?page=$page',
    );
  }


  @override
  Future<Result<OrderUserModel>> getSearchMyOrders({
    required int page,
    required int type,
    required String search
}) async {
    return await RemoteDataSource.request<OrderUserModel>(
      converter: (model) => OrderUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "type":type,
        "search":search,
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.getSearchMyOrderUrl}"'?page=$page',
    );
  }
  @override
  Future<Result<GeneralModel>> deleteItem({
    required int idItem
}) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.DELETE,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.deleteItemCartUrl}${idItem}",
    );
  }

  @override
  Future<Result<GeneralModel>> changeStatusOrder({
    required int orderId,
    required int status_order
  }) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        'status_order':status_order,
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.changeStatusOrderUrl}$orderId/status",
    );
  }



  @override
  Future<Result<GeneralModel>> createOrder({
    required OrderParameterModel order
  }) async {
    print(DIManager.findDep<SharedPrefs>().getToken());
    print('-------');
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "payment_method":"cod",
        "cart_id":order.cart_id,
        "customer_first_name":order.name,
        "country_code":"+971",
        "phone":order.phone,
        "location":order.location,
        "status":'completed',
        "note":order.note,
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.createOrderUrl}",
    );
  }

  @override
  Future<Result<GeneralModel>> removeItemFromCart(
      {required int productId, }) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "product_id": productId,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.removeItemFromCartUrl}",
    );
  }

}

class OrderParameterModel{
int cart_id;
String name;
String phone;
String location;
String note;
OrderParameterModel({
  required this.cart_id,
  required this.name,
  required this.phone,
  required this.location,
  required this.note,
});
}