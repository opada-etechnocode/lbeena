abstract class BaseError {
  final String? message;

  const BaseError(this.message);
}
class ModelEmptyError extends BaseError  {
  ModelEmptyError(String? message) : super(message);
}
