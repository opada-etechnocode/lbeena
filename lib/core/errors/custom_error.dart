import 'base_error.dart';

class CustomError extends BaseError {
  final String? message;
  final int? statusCode;

  CustomError({
    this.message,
    this.statusCode,
  }) : super(message);
}
