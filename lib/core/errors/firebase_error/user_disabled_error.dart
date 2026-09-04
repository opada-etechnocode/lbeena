import '../../../../core/errors/firebase_error/firebase_error.dart';

class UserDisabledError extends FirebaseError {
  UserDisabledError() : super('user_disabled');
}
