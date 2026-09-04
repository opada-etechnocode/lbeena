
import '../base_error.dart';

class FirebaseError extends BaseError {
  final String? message;

  FirebaseError(this.message) : super(message ?? '');
}
