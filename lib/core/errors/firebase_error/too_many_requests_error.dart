
import '../../../core/errors/firebase_error/firebase_error.dart';

class TooManyRequestError extends FirebaseError {
  TooManyRequestError() : super('too_many_request');
}
