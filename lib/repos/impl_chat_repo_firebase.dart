
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';

import '../core/base_repository.dart';
import '../data/models/chats/ads_chats_model.dart';
import '../data/models/chats/data_massage_model.dart';
import '../data/models/chats/message_model.dart';
import '../data/sources/chats/chat_remote_data_source_firebase.dart';
import 'chat_repo_i_firebase.dart';

class ChatRepoFirebase extends BaseRepository implements ChatFacadeFirebase {
  final ChatRemoteDataSourceFirebase _aRD;
  final SharedPrefs _sp;

  ChatRepoFirebase(this._aRD,
      this._sp,);



  Future<void> sendMassageFirebaseToFireStore({
    required String user_id,
    required String user_id_2,
    required String ad_id,
    required String type,
    required DataMassageModel dataMassageModel,
    required AdsChatsModel adsChatsModel,
  }) async {
    await _aRD.sendMassageFirebaseToFireStore(user_id: user_id,
        user_id_2: user_id_2,
        ad_id: ad_id,
        type: type,
        dataMassageModel: dataMassageModel,
        adsChatsModel: adsChatsModel);
  }

}
