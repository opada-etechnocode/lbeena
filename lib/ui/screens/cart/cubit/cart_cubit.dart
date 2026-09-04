
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/snack_bar_helper.dart';
import '../../../../data/models/cart_model/get_cart_model.dart';
import '../../../../data/models/cart_model/order_model.dart';
import '../../../../data/sources/cart/cart_data_source.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static CartCubit get(context) => BlocProvider.of(context);

  CartDate? dataCart;
  int lengthListCart = 0;

  /// get My Cart
  Future<void> getMyCart() async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      emit(LoadingMyCartState());

      var data = await cartDataSourceImp.getMyCart();
      if (data.data != null) {
        dataCart = data.data?.data;
        if (dataCart != null) {
          lengthListCart = dataCart!.items.length;
        } else {
          lengthListCart == 0;
        }
        emit(SuccessMyCartState(data.data!));
      } else {
        emit(ErrorMyCartState(data.data?.message! ??'Error'));
      }
    } catch (e, stack) {
      print("Error In ErrorMyCartState is : $e in $stack");
      emit(ErrorMyCartState("Error is $e"));
    }
  }

  // OrderUserModel? dataOrder;

  List<OrdersList> orderList = [];
  List<OrdersList> orderNotCompletedList = [];

  Future<void> getMyOrder({
    required int page,
    required bool isActiveLoader,
    required bool myOrderRequests,
  }) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      if (!isActiveLoader) {
        orderList.clear();
        orderNotCompletedList.clear();
        emit(LoadingMyOrderState());
      }

      var data = await cartDataSourceImp.getMyOrders(
          page: page, myOrderRequests: myOrderRequests);

      if (data.data != null && data.data!.data != null) {
        emit(SuccessMyOrderState(data.data!));

        for (var order in data.data!.data!.data!) { // ✅ هنا تم تصحيح الخطأ

          if (order.statusOrder  == 2) { // 2 يعني مكتمل
            orderList.add(order);
          } else {
            orderNotCompletedList.add(order);
          }
          // List<Item> completedItems = [];
          // List<Item> notCompletedItems = [];
          //
          // // for (var item in order.items) {
          // //   if (item.statusOrder == 2) {
          // //     completedItems.add(item);
          // //   } else {
          // //     notCompletedItems.add(item);
          // //   }
          // // }
          // //
          // // // إذا كان هناك عناصر مكتملة، أضف نسخة من الطلب إلى orderList
          // // if (completedItems.isNotEmpty) {
          // //   var completedOrder = order.copyWith(items: completedItems);
          // //   orderList.add(completedOrder);
          // // }
          // //
          // // // إذا كان هناك عناصر غير مكتملة، أضف نسخة من الطلب إلى orderNotCompletedList
          // // if (notCompletedItems.isNotEmpty) {
          // //   var notCompletedOrder = order.copyWith(items: notCompletedItems);
          // //   orderNotCompletedList.add(notCompletedOrder);
          // // }
        }
      } else {
        emit(ErrorMyOrderState(data.data?.message ?? "خطأ غير معروف"));
      }
    } catch (e, stack) {
      print("Error In ErrorMyOrderState is : $e in $stack");
      emit(ErrorMyOrderState("Error is $e"));
    }
  }



  final TextEditingController searchTfController = TextEditingController();

  /// get My Cart
  Future<void> getSearchMyOrder({
    required int page,
    required int type,
    required String search,
    required bool isActiveLoader,
  }) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      if (!isActiveLoader) {
        orderList.clear();
        orderNotCompletedList.clear();
        emit(LoadingMyOrderState());
      }
      var data = await cartDataSourceImp.getSearchMyOrders(
          page: page, type: type, search: search);
      if (data.data != null) {
        emit(SuccessMyOrderState(data.data!));
        for (var order in data.data!.data!.data!) { // ✅ هنا تم تصحيح الخطأ
          List<Item> completedItems = [];
          List<Item> notCompletedItems = [];

          // تصنيف العناصر داخل الطلب
          for (var item in order.items) {
            if (item.statusOrder == 2) {
              completedItems.add(item);
            } else {
              notCompletedItems.add(item);
            }
          }

          // إذا كان هناك عناصر مكتملة، أضف نسخة من الطلب إلى orderList
          if (completedItems.isNotEmpty) {
            var completedOrder = order.copyWith(items: completedItems);
            orderList.add(completedOrder);
          }

          // إذا كان هناك عناصر غير مكتملة، أضف نسخة من الطلب إلى orderNotCompletedList
          if (notCompletedItems.isNotEmpty) {
            var notCompletedOrder = order.copyWith(items: notCompletedItems);
            orderNotCompletedList.add(notCompletedOrder);
          }
        }

      } else {
        emit(ErrorMyOrderState(data.data!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorMyOrderState is : $e in $stack");
      emit(ErrorMyOrderState("Error is $e"));
    }
  }

  /// get My Cart
  Future<void> createOrder({required OrderParameterModel order}) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      emit(LoadingCreateOrderState());

      var data = await cartDataSourceImp.createOrder(order: order);
      if (data.data != null) {
        emit(SuccessCreateOrderState(data.data!));
      } else {
        emit(ErrorCreateOrderState(data.data!.message!));
      }
    } catch (e, stack) {
      print("Error In Create order is : $e in $stack");
      emit(ErrorCreateOrderState("Error is $e"));
    }
  }

  void incrementQyt(context, {required int index}) {
    if (dataCart != null) {
      dataCart!.items[index].quantity = dataCart!.items[index].quantity! + 1;

      dataCart!.totalPrice = ((double.tryParse(dataCart!.totalPrice!) ?? 0) +
              (double.tryParse(dataCart!.items[index].price!) ?? 0))
          .toString();

      print(dataCart!.totalPrice);
      print(dataCart!.items[index].quantity);
      emit(IncrementQytState());
      addToCart(context,
          price: dataCart!.items[index].price!,
          productId: dataCart!.items[index].productId!.toString(),
          isNeedGetMyCart: false);
    }
  }

  void decrementQyt({required int index}) {
    if (dataCart != null && dataCart!.items[index].quantity != 1) {
      dataCart!.items[index].quantity = dataCart!.items[index].quantity! - 1;
      dataCart!.totalPrice = ((double.tryParse(dataCart!.totalPrice!) ?? 0) -
              (double.tryParse(dataCart!.items[index].price!) ?? 0))
          .toString();
      emit(DecrementQytState());
      removeItemFromCart(idItem: dataCart!.items[index].productId!);
    } else if (dataCart != null && dataCart!.items[index].quantity == 1) {
      deleteItem(
        idItem: dataCart!.items[index].cartItemId!,
        index: index,
        qyt: 1,
      );
    }
  }

  /// deleteItem
  Future<void> removeItemFromCart({
    required int idItem,
  }) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      emit(LoadingDeleteItemState());

      var data = await cartDataSourceImp.removeItemFromCart(productId: idItem);
      if (data.data != null) {
        emit(SuccessDeleteItemState(data.data!));
      } else {
        emit(ErrorDeleteItemState(data.data!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorDeleteItemState is : $e in $stack");
      emit(ErrorDeleteItemState("Error is $e"));
    }
  }

  /// change status
  Future<void> changeStatusOrder({
    required int orderId,
    required int statusOrder,
  }) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      emit(LoadingChangeStatusOrderState());

      var data = await cartDataSourceImp.changeStatusOrder(
          orderId: orderId, status_order: statusOrder);
      if (data.data != null) {
        emit(SuccessChangeStatusOrderState(data.data!));
      } else {
        emit(ErrorChangeStatusOrderState(data.data!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorChangeStatusOrderState is : $e in $stack");
      emit(ErrorChangeStatusOrderState("Error is $e"));
    }
  }

  /// deleteItem
  Future<void> deleteItem(
      {required int idItem, required int index, required int qyt}) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      dataCart!.totalPrice = ((double.tryParse(dataCart!.totalPrice!) ?? 0) -
              (double.tryParse(dataCart!.items[index].price!) ?? 0) * qyt)
          .toString();
      dataCart!.items.removeAt(index);

      emit(LoadingDeleteItemState());

      var data = await cartDataSourceImp.deleteItem(idItem: idItem);
      if (data.data != null) {
        emit(SuccessDeleteItemState(data.data!));
        print(lengthListCart);
        lengthListCart = dataCart!.items.length;
        print(lengthListCart);
      } else {
        emit(ErrorDeleteItemState(data.data!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorDeleteItemState is : $e in $stack");
      emit(ErrorDeleteItemState("Error is $e"));
    }
  }

  /// add to cart
  Future<void> addToCart(context,
      {required String productId,
      required String price,
      required bool isNeedGetMyCart}) async {
    CartDataSourceImp cartDataSourceImp = const CartDataSourceImp();
    try {
      if (!isClosed) {
        emit(LoadingAddToCartState());
      }
      var getStatusUserData = await cartDataSourceImp.addToCart(
          productId: productId, price: price);

      if (getStatusUserData.data != null) {
        if (!isClosed) {
          emit(SuccessAddToCartState(getStatusUserData.data!,productId));

          if (isNeedGetMyCart) {
            SnackBarHelper.mySnackBarSuccess(
                getStatusUserData.data!.message.toString(), context);
            getMyCart();
          }
        }
      } else {
        if (!isClosed) {
          emit(ErrorAddToCartState(getStatusUserData.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In AddToCart is : $e in $stack");
      if (!isClosed) {
        emit(ErrorAddToCartState("Error is $e"));
      }
    }
  }
}
