
import './base_error.dart';

class NotFoundError extends BaseError {
  NotFoundError({String? message}) : super(message ??'not_found');
}
