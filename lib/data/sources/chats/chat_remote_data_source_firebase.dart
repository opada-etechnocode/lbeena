import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/chats/ads_chats_model.dart';
import '../../models/chats/data_massage_model.dart';

class ChatRemoteDataSourceFirebaseImplFirebase implements ChatRemoteDataSourceFirebase {
   ChatRemoteDataSourceFirebaseImplFirebase();

  /*

                            await FirebaseFirestore.instance
                                .collection('${AppEndpoints.starBaseUrl}users')
                                .doc('1234')
                                .collection('ads')
                                .doc('1')
                                .collection('chats')
                                .doc('4321')
                                .collection('messages')
                                .add({
                              'text':'Hello',
                              'senderId':'1234',
                              'receiverId':'4321',
                              'dateTime':'2023/11/7'
                            })
                                .then((value) {})
                                .catchError((error) {
                              print(error);
                            });

                            // set receiver chats
                            await FirebaseFirestore.instance
                                .collection('${AppEndpoints.starBaseUrl}users')
                                .doc('4321')
                                .collection('ads')
                                .doc('1')
                                .collection('chats')
                                .doc('1234')
                                .collection('messages')
                                .add({
                              'text':'Hello',
                              'senderId':'1234',
                              'receiverId':'4321',
                              'dateTime':'2023/11/7'
                            })
                                .then((value) {

                            })
                                .catchError((error) {
                              print(error);
                            });
   */





  @override
  Future<void> sendMassageFirebaseToFireStore({
    required String user_id,
    required String user_id_2,
    required String ad_id,
    required String type,
    required DataMassageModel dataMassageModel,
    required AdsChatsModel adsChatsModel,
  }) async {


    await FirebaseFirestore.instance
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection(type)
    // .doc(ad_id)
        .doc(ad_id+user_id_2)
        .set(adsChatsModel.toMap())
        .then((value) {})
        .catchError((error) {
      print(error);
    });

    await FirebaseFirestore.instance
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id_2)
        .collection(type)
    // .doc(ad_id)
        .doc(ad_id+user_id)
        .set(adsChatsModel.toMap())
        .then((value) {})
        .catchError((error) {
      print(error);
    });
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseFirestore.instance
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection(type)
        .doc(ad_id+user_id_2)
        .collection('chats')
        .doc(user_id_2)
        .collection('messages').doc(time)
        .set(dataMassageModel.toMap())
        .then((value) {
      // print(value.toString());
    }).catchError((error) {
      print(error);
    });

    // set receiver chats
    await FirebaseFirestore.instance
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id_2)
        .collection(type)
        .doc(ad_id+user_id)
        .collection('chats')
        .doc(user_id)
        .collection('messages').doc(time)
        .set(dataMassageModel.toMap())
        .then((value) {
      // print(value.toString());
    }).catchError((error) {
      print(error);
    });
  }


}

abstract class ChatRemoteDataSourceFirebase {
  const ChatRemoteDataSourceFirebase();



  Future<void> sendMassageFirebaseToFireStore({
    required String user_id,
    required String user_id_2,
    required String ad_id,
    required String type,
    required DataMassageModel dataMassageModel,
    required AdsChatsModel adsChatsModel,
  });


}
