
import './base_error.dart';

class CancelError extends BaseError {
  CancelError({String? message})
      : super(message ?? 'user_cancel_error');
}
