
import '../data/models/chats/ads_chats_model.dart';
import '../data/models/chats/data_massage_model.dart';
import '../data/models/chats/message_model.dart';

abstract class ChatFacadeFirebase {

  Future<void> sendMassageFirebaseToFireStore({
    required String user_id,
    required String user_id_2,
    required String ad_id,
    required String type,
    required DataMassageModel dataMassageModel,
    required AdsChatsModel adsChatsModel,
  });
}


