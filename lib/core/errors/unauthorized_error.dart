
import './base_error.dart';

class UnauthorizedError extends BaseError {
  UnauthorizedError({String? message})
      : super(message ??'unauthorized_err');
}
