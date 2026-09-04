import '../../../../core/errors/firebase_error/firebase_error.dart';

class NotValidEmailError extends FirebaseError {
  NotValidEmailError() : super('not_valid_email');
}
