import '../../../../core/errors/firebase_error/firebase_error.dart';

class DocumentNotFoundError extends FirebaseError {
  DocumentNotFoundError() : super('doc_not_found');
}
