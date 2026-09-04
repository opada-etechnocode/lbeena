import 'package:syrians_in_uae/ui/screens/chats/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/endpoints.dart';
import '../../../../data/models/chats/ads_chats_model.dart';
import '../../../../data/models/chats/data_massage_model.dart';
import '../../../../data/models/chats/message_model.dart';
import '../../../../data/sources/chats/chat_remote_data_source_firebase.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import '../../../../data/sources/notifications/notifications_data_source.dart';
import '../../../../repos/chat_repo_i_firebase.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../widgets/file_compress.dart';
class ChatCubitFirebase extends Cubit<ChatStateFirebase> {
  // static ChatCubitFirebase get(context) => BlocProvider.of(context);

   ChatFacadeFirebase? adsRepo;

  ChatCubitFirebase({
    this.adsRepo,
  }) : super(ChatFirebaseInitialState());
  List<AdsChatsModel> adsChatsModel = [];

  Future<void> getAllAdsChats({
    required String? user_id,
    required String type,
  }) async {
    emit(GetAllAdsChatsLoadingState());
    adsChatsModel = [];
    print(
        "user_id:====================================user_id===============user_id===============${user_id}");
    try {
      // await adsRepo.getAllAdsChats(user_id: user_id);
      //

      await FirebaseFirestore.instance
          .collection('${AppEndpoints.starBaseUrl}users')
          .doc(user_id)
          .collection(type)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          AdsChatsModel adsChats = AdsChatsModel.forJson(element.data());
          adsChatsModel.add(adsChats);
        });
        // print(adsChatsModel[0].nameAds);
        // print(adsChatsModel[1].nameAds);
      });
      print(
          'adsChatsModel[2].nameAds-----------------------------------------------------------------------');
      print(adsChatsModel[0].nameAds);
      emit(GetAllAdsChatsSuccessState(adsChatsModel));
    } catch (error) {
      print(error.toString());
      emit(GetAllAdsErrorState());
    }
  }

  List<DataMassageModel> messages = [];

  void getMessages({
    required String? ad_id,
    required String? user_id_2,
    required String? user_id,
    required String? receiverId,
    required String type,
  }) {
    emit(GetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection(type)
        .doc(ad_id! + user_id_2!)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime',descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(DataMassageModel.forJson(element.data()));
      });
      // print(messages);
      if (!isClosed) { // التأكد من عدم إغلاق الـ Cubit
        emit(GetMessagesSuccessState());
      }
      // getAllAdsChats(
      //   user_id: user_id
      // );
    });
  }
   List<DataMassageModel> messagesGroup = [];

   void getGroupMessages(String groupId) {
     try {
       emit(GetMessagesLoadingState());
       CollectionReference messagesRef = FirebaseFirestore.instance
           .collection('groups')
           .doc(groupId)
           .collection('messages');

       // استخدم listen بدلاً من snapshots مباشرة
       messagesRef
           .orderBy('dateTime', descending: true)
           .snapshots()
           .listen((querySnapshot) {
         // إنشاء قائمة جديدة لتخزين الرسائل المسترجعة
         List<DataMassageModel> newMessages = querySnapshot.docs.map((doc) {
           return DataMassageModel.forJson(doc.data() as Map<String, dynamic>);
         }).toList();
         messagesGroup.clear();
         // قم بإضافة العناصر إلى القائمة المؤقتة أولاً
         List<DataMassageModel> updatedMessages = List.from(messagesGroup);
         updatedMessages.addAll(newMessages);

         // بعد التكرار على الرسائل، يمكننا تحديث messagesGroup
         messagesGroup = updatedMessages;

         // التأكد من عدم إغلاق الـStream قبل إرسال الحالة
         if (!isClosed) {
           emit(GetMessagesSuccessState());
         }
       });
     } catch (e) {
       print("Error fetching messages: $e");
       emit(GetMessagesErrorState());
     }
   }




   List<DataNotificationsModel> notification = [];
   void getNotifications({
     required String? user_id,
   }) {
     // emit(GetNotificationsLoadingState());
     FirebaseFirestore.instance
         .collection('${AppEndpoints.starBaseUrl}users')
         .doc(user_id)
         .collection('notifications')
         .snapshots()
         .listen((event) {
       notification = [];
       event.docs.forEach((element) {
         notification.add(DataNotificationsModel.forJson(element.data()));
       });
     });
   }


   List<DataNotificationsHomePageModel> notificationHomePage = [];
   void getNotificationsHomePage({
     required String? user_id,
   }) {
     // emit(GetNotificationsLoadingState());
     FirebaseFirestore.instance
         .collection('Users')
         .doc(user_id)
         .collection('notifications')
         .orderBy('created_at', descending: true)
         .snapshots()
         .listen((event) {
       notificationHomePage = [];

       event.docs.forEach((element) {
         notificationHomePage.add(
           DataNotificationsHomePageModel.forJson(
             element.data(),
           ),
         );
       });

       emit(GetNotificationsHomePageSuccessState());
     });
   }

// حذف جميع الإشعارات
  Future<void> deleteAllNotifications({required String? user_id}) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user_id)
          .collection('notifications')
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      emit(DeleteAllNotificationsSuccessState());
    } catch (e) {
      emit(DeleteAllNotificationsErrorState(error:e.toString()));
    }
  }

// حذف إشعار واحد
  Future<void> deleteOneNotification({
    required String? user_id,
    required String notificationId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user_id)
          .collection('notifications')
          .doc(notificationId)
          .delete();

      emit(DeleteOneNotificationSuccessState());
    } catch (e) {
      emit(DeleteOneNotificationErrorState(error: e.toString()));
    }
  }

// قراءة إشعار (تغيير قيمة read = "1")
  Future<void> readNotification({
    required String? user_id,
    required String notificationId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user_id)
          .collection('notifications')
          .doc(notificationId)
          .update({"read": "1"});

      emit(ReadNotificationSuccessState());
    } catch (e) {
      emit(ReadNotificationErrorState(error:e.toString()));
    }
  }

  List<DataMassageModel> messagesLast = [];

  String lastMessages = '';
  List<AdsChatsModel> adsLastInfo = [];
   void getAdsLastInfo({
     required String? user_id,
     required String type,
   }) async {
     if (user_id == null || user_id.isEmpty) {
       print('Error: user_id is null or empty');
       emit(GetAdsInfoErrorState());
       return;
     }

     try {

       FirebaseFirestore.instance
           .collection('${AppEndpoints.starBaseUrl}users')
           .doc(user_id)
           .collection(type)
           .orderBy('dateTime', descending: true)
           .snapshots()
           .listen((event) {
         adsLastInfo = [];
         event.docs.forEach((element) {
           try {
             // print('Document data: ${element.data()}');
             AdsChatsModel adsChats = AdsChatsModel.forJson(element.data());
             adsLastInfo.add(adsChats);
           } catch (e) {
             print('Error parsing document: ${element.id}, error: $e');
           }
         });

         // Print the first ad's name if the list is not empty
         if (adsLastInfo.isNotEmpty) {
           print(adsLastInfo[0].nameAds);
         }

         emit(GetAdsInfoSuccessState());
       });
     } catch (error) {
       print('Error: $error');
       emit(GetAdsInfoErrorState());
     }
   }

   var statusUserReceiver;
   var isReadLastMessage;
var imageUser;

   void getAdsLastInfoForUserReceiver({
     required String user_id,
     required String ad_id,
     required String user_id_2,
     required String type,
   }) {
     FirebaseFirestore.instance
         .collection('${AppEndpoints.starBaseUrl}users')
         .doc(user_id_2)
         .collection(type)
         .doc(ad_id + user_id)
         .snapshots()
         .listen((event) {
       event.data()?.forEach((key, value) {
         final data = event.data();
         if (data != null) {
           // Check if the 'read' key exists in the data
           if (data.containsKey('read')) {
             // Access the value associated with the 'read' key
             isReadLastMessage = data['read'];

             // Handle the value according to its type
             if (isReadLastMessage is String) {
               // Handle as string
               print('isReadLastMessage: $isReadLastMessage');
             } else if (isReadLastMessage is bool) {
               // Handle as boolean
               print('Read value as boolean: $isReadLastMessage');
             }

             // You can handle other types if necessary

           } else {
             print('Key "read" does not exist in the data');
           }
           if (data.containsKey('imageUser')) {
             // Access the value associated with the 'read' key
             imageUser = data['imageUser'];

             // Handle the value according to its type
             if (imageUser is String) {
               // Handle as string
               print('Read value as string: $imageUser');
             } else if (imageUser is bool) {
               // Handle as boolean
               print('Read value as boolean: $imageUser');
             }

             // You can handle other types if necessary

           } else {
             print('Key "read" does not exist in the data');
           }
           if (data.containsKey('isOnLine')) {
             // Access the value associated with the 'read' key
             statusUserReceiver = data['isOnLine'];

             // Handle the value according to its type
             if (statusUserReceiver is String) {
               // Handle as string
               print('statusUserReceiver: $statusUserReceiver');
             } else if (statusUserReceiver is bool) {
               // Handle as boolean
               print('statusUserReceiver: $statusUserReceiver');
             }

             // You can handle other types if necessary

           } else {
             print('Key "read" does not exist in the data');
           }
         } else {
           print('No data available');
         }

       });

     });
     emit(GetAdsInfoReceiverSuccessState());
   }
   static FirebaseStorage storage = FirebaseStorage.instance;

    Future<void> sendChatImage(String userId, File file) async {

     emit(ChatFirebaseLoadingUploadImageState());
    try{
      final ext = file.path.split('.').last;

      final ref = storage.ref().child(
          'images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final compressedFile = await FileManager.compressFile(file,true);
      if (compressedFile != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await compressedFile.copy(tempPath);
        await ref
            .putFile(compressedFile!, SettableMetadata(contentType: 'image/$ext'))
            .then((p0) {
          log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
        });
      }


      final imageUrl = await ref.getDownloadURL();
      emit(SendMessageSuccessUploadImageState(imageUrl: imageUrl));
    }catch(e){
      print('=======================');
      print('=======================');
      print('==========${e.toString()}============');
      print('=======================');
      print('=======================');
      emit(SendMessageErrorUploadImageState(error: e.toString()));
    }
     // await sendMessage(chatUser, imageUrl, Type.image);
   }

   Future<void> sendChatVoice(String userId, File file) async {
     emit(ChatFirebaseLoadingUploadRecordState());
     try {
       final ext = file.path.split('.').last;

       final ref = storage.ref().child(
           'Recordings/$userId/${DateTime.now().millisecondsSinceEpoch}.m4a');

       await ref.putFile(file, SettableMetadata(contentType: 'audio/$ext')).then((p0) {
         log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
         log('Data Transferred: $ref kb');
       });

       final recorderUrl = await ref.getDownloadURL();
       emit(SendMessageSuccessUploadRecordState(recorderUrl: recorderUrl));
     } catch (e) {
       print('=======================');
       print('=======================');
       print('==========${e.toString()}============');
       print('=======================');
       print('=======================');
       emit(SendMessageErrorUploadRecordState(error: e.toString()));
     }
   }

   Future<void> sendMassageFirebaseToFireStore({
    required String user_id,
    required String user_id_2,
    required String ad_id,
    required String type,
    required DataMassageModel dataMassageModel,
    required AdsChatsModel adsChatsModel,
  }) async {
    ChatRemoteDataSourceFirebaseImplFirebase chatsDataSourceImpl = ChatRemoteDataSourceFirebaseImplFirebase();
    emit(ChatFirebaseLoadingState());

    try {
      await chatsDataSourceImpl.sendMassageFirebaseToFireStore(
          user_id: user_id,
          user_id_2: user_id_2,
          ad_id: ad_id,
          type: type,
          dataMassageModel: dataMassageModel,
          adsChatsModel: adsChatsModel);
      // print('SendMessageSuccessFirebase');

      //
      // getLastMessages(
      //   user_id: user_id,
      // receiverId: user_id_2,
      //  user_id_2: user_id_2,
      // ad_id: ad_id,
      // );
      emit(SendMessageSuccessState());
    } catch (error) {
      print(error.toString());
      emit(SendMessageErrorState());
    }
  }
   final Map<String, bool> loadingStates = {};
  void deleteChat({
    required String ad_id,
    required String user_id_2,
    required String user_id,
    required String receiverId,
    required String type,
  }) async{
    loadingStates[ad_id] = true;

    emit(DeleteMessagesLoadingState());
    await Future.delayed(Duration(milliseconds: 500));
    FirebaseFirestore.instance
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection(type)
        .doc(ad_id! + user_id_2!)
        .delete()
        .then((value) {
      getAllAdsChats(user_id: user_id,type: type);
      FirebaseFirestore.instance
          .collection('${AppEndpoints.starBaseUrl}users')
          .doc(user_id)
          .collection(type)
          .doc(ad_id + user_id_2)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .get()
          .then((value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
        loadingStates[ad_id] = false;
        emit(DeleteMessagesSuccessState());
      }).catchError((error) {
        loadingStates[ad_id] = false;
        DeleteMessagesErrorState(error.toString());
      });
    }).catchError((error) {
      loadingStates[ad_id] = false;
      DeleteMessagesErrorState(error.toString());
    });
  }
   bool isLoading(String ad_id) {
     return loadingStates[ad_id] ?? false;
   }
   /// Policy Terms App Links
   Future<void> getDeviceTokenUser({
     required String userId
}) async {
     HomePageDataSourceImpl homePageDataSourceImpl =
     const HomePageDataSourceImpl();
     try {
       emit(LoadingDeviceTokenUserState());

       var getDeviceTokenUserData = await homePageDataSourceImpl.getDeviceTokenUser(userId: userId);

       if (getDeviceTokenUserData.data != null) {
         emit(SuccessDeviceTokenUserState(getDeviceTokenUserData.data!));
       } else {
         emit(ErrorDeviceTokenUserState(getDeviceTokenUserData.error!.message!));
       }
     } catch (e, stack) {
       print("Error In DeviceTokenUser is : $e in $stack");
       emit(ErrorDeviceTokenUserState("Error is $e"));
     }
   }

   bool isPlaying = true;
   int? currentPlayingIndex;
   void updatePlayingIndex(int? index) {
     currentPlayingIndex = index;
     emit(PlayingStateUpdated()); // إذا كنت تستخدم Bloc أو State Management
   }
    bool isPlayingResult(bool is_playing){
      isPlaying = is_playing;
      emit(ResultPlayingState());
      return  isPlaying;
    }
   /// get All Notifications User
   Future<void> sendNotificationsToUser(
       {    required String deviceToken,
         required String userNamSender,
         required String message,
         required ArgumentMessage dataMessage,
       }
       ) async {
     NotificationsDataSourceImpl sendNotificationsSourceImpl =
     const NotificationsDataSourceImpl();
     try {
       emit(LoadingSendNotificationsState());

       var sendNotifications =
       await sendNotificationsSourceImpl.sendNotificationsForUser(deviceToken: deviceToken, userNamSender: userNamSender, message: message,dataMessage: dataMessage,isMessage: true);
       if (sendNotifications.data != null) {
         emit(SuccessSendNotificationsState(sendNotifications.data!));
       } else {
         emit(ErrorSendNotificationsState());
       }
     } catch (e, stack) {
       print("Error In SendNotificationsState is : $e in $stack");
       emit(ErrorSendNotificationsState());
     }
   }



}
