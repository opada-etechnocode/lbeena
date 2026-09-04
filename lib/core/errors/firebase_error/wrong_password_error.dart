import '../../../../core/errors/firebase_error/firebase_error.dart';

class WrongPasswordError extends FirebaseError {
  WrongPasswordError() : super('wrong_password');
}
