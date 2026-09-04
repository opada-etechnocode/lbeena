
import '../../../../data/models/GeneralResult.dart';
import '../../../../data/models/auth/otp/otp_model.dart';
import '../../../../data/models/cart_model/add_to_cart.dart';
import '../../../../data/models/cart_model/get_cart_model.dart';
import '../../../../data/models/cart_model/order_model.dart';

abstract class CartState {}

 class CartInitial extends CartState {}



/// get my cart
 class LoadingMyCartState extends CartState {}
 class SuccessMyCartState extends CartState {
  GetMyCartModel data;
  SuccessMyCartState(this.data);
}
 class ErrorMyCartState extends CartState {
 final String message;

 ErrorMyCartState(this.message);
}


/// get my order
class LoadingMyOrderState extends CartState {}
class SuccessMyOrderState extends CartState {
 OrderUserModel data;
 SuccessMyOrderState(this.data);
}
class ErrorMyOrderState extends CartState {
 final String message;

 ErrorMyOrderState(this.message);
}


/// Create Order Data
class LoadingCreateOrderState extends CartState {}
class SuccessCreateOrderState extends CartState {
 GeneralModel data;
 SuccessCreateOrderState(this.data);
}
class ErrorCreateOrderState extends CartState {
 final String message;
 ErrorCreateOrderState(this.message);
}

class IncrementQytState extends CartState {}
class DecrementQytState extends CartState {}

/// Delete Item
class LoadingDeleteItemState extends CartState {}
class SuccessDeleteItemState extends CartState {
 GeneralModel data;
 SuccessDeleteItemState(this.data);
}
class ErrorDeleteItemState extends CartState {
 final String message;

 ErrorDeleteItemState(this.message);
}


/// LoadingChangeStatusOrderState
class LoadingChangeStatusOrderState extends CartState {}
class SuccessChangeStatusOrderState extends CartState {
 GeneralModel data;
 SuccessChangeStatusOrderState(this.data);
}
class ErrorChangeStatusOrderState extends CartState {
 final String message;

 ErrorChangeStatusOrderState(this.message);
}

/// Add To Cart

class LoadingAddToCartState extends CartState {

}

class SuccessAddToCartState extends CartState {
 final AddToCartModel generalResult;
 final String productId;

 SuccessAddToCartState(this.generalResult,this.productId);

 @override
 List<Object> get props => [productId];
}

class ErrorAddToCartState extends CartState {
 final String error;
 ErrorAddToCartState(this.error);
}


/// remove From Cart

class LoadingRemoveFromCartState extends CartState {

}

class SuccessRemoveFromCartState extends CartState {
 final GeneralResult generalResult;
 SuccessRemoveFromCartState(this.generalResult);
}

class ErrorRemoveFromCartState extends CartState {
 final String error;
 ErrorRemoveFromCartState(this.error);
}