import '../../../../core/errors/firebase_error/firebase_error.dart';

class UserNotFoundError extends FirebaseError {
  UserNotFoundError() : super('user_not_found');
}
