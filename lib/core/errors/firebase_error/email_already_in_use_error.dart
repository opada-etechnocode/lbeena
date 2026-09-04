import '../../../../core/errors/firebase_error/firebase_error.dart';

class EmailAlreadyInUseError extends FirebaseError {
  EmailAlreadyInUseError() : super('email_already_in_use');
}
