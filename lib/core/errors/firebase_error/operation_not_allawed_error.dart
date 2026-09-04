import '../../../../core/errors/firebase_error/firebase_error.dart';

class OperationNotAllowedError extends FirebaseError {
  OperationNotAllowedError() : super('op_not_allowed');
}
