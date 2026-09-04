import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/data/models/chats/data_massage_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';

class APIs {
// for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //update read status of message
  static Future<void> updateMessageReadStatus({
    required String user_id,
    required String ad_id,
    required String user_id_2,
    required String read,
    required String type,
  }) async {
    firestore
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection(type)
        .doc(ad_id + user_id_2)
        .update({'read': read});
  }

  static Future<void> sendNotificationsToUser({
    required String user_id,
    required String ad_id,
    required String user_id_2,
    required String read,
     String type ='ads',
  }) async {
    try {
      firestore
          .collection('${AppEndpoints.starBaseUrl}users')
          .doc(user_id_2)
          .collection('notifications')
          .doc(type =='ads'?(ad_id + user_id):ad_id)
          .set({
        'ad_id': ad_id,
        'user_id': user_id,
        'user_id_2': user_id_2,
      });
    } catch (e, stack) {
      print('Error $e');
      print('stack $stack');
    }
  }

  static Future<void> deleteNotificationsToUser({
    required String user_id,
    required String ad_id,
    required String user_id_2,
     String type = 'ads',
  }) async {
    firestore
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection('notifications')
        .doc(type == 'ads' ?(ad_id + user_id_2):ad_id)
        .delete();
  }

  static Future<void> getMessageReadStatus({
    required String user_id,
    required String ad_id,
    required String user_id_2,
    required String type,
  }) async {
    firestore
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(user_id)
        .collection(type)
        .doc(ad_id + user_id_2)
        .snapshots()
        .listen((event) {
      var readStatus = event.data()?['read']
          as String?; // Assuming 'read' is stored as a String
      // Here you can handle the read status, for example, print it or update UI
      DIManager.findDep<SharedPrefs>().setReadMessageStatus(readStatus);
      print("Read status: $readStatus");
      print("Read status: $readStatus");
      print("Read status: $readStatus");
      print("Read status: $readStatus");
    });
  }

  static Future<void> updateStatusUser({
    required String userStatus,
  }) async {
    firestore
        .collection('${AppEndpoints.starBaseUrl}users')
        .doc(DIManager.findDep<SharedPrefs>().getUserID().toString())
        .set({
      'userStatus': userStatus,
    });
  }

  static Future<void> getStatusUser({
    required String userID,
  }) async {
    firestore.collection('${AppEndpoints.starBaseUrl}users').doc(userID)
      ..snapshots().listen((event) {
        var userStatus = event.data()?['userStatus'] as String?;
        DIManager.findDep<SharedPrefs>().setStatusUserChats(userStatus);
        print("User status: $userStatus");
      });
  }

  // static Future<void> updateStatusUser(
//       {
//         required String user_id,
//         required String ad_id,
//         required String user_id_2,
//         required String userStatus,
//       }) async {
//     firestore
//         .collection('${AppEndpoints.starBaseUrl}users')
//         .doc(DIManager.findDep<SharedPrefs>().getUserID().toString())
//         .set({'status': userStatus,});
//   }

  ///send chat image
// static Future<void> sendChatImage(ChatUser chatUser, File file) async {
//   //getting image file extension
//   final ext = file.path.split('.').last;
//
//   //storage file ref with path
//   final ref = storage.ref().child(
//       'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
//
//   //uploading image
//   await ref
//       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
//       .then((p0) {
//     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//   });
//
//   //updating image in firestore database
//   final imageUrl = await ref.getDownloadURL();
//   await sendMessage(chatUser, imageUrl, Type.image);
// }

  //
  // static Future<void> createGroup({
  //    required String groupName,
  //    required String groupId,
  //    required String adminId,
  //    required List<String> initialMembers, // قائمة الأعضاء المبدئيين
  //  }) async {
  //    try {
  //      // إنشاء مرجع للمجموعة الجديدة
  //      DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
  //
  //      // تحويل قائمة الأعضاء إلى صيغة Map
  //      Map<String, bool> membersMap = {for (var memberId in initialMembers) memberId: true};
  //
  //      // إضافة بيانات المجموعة إلى Firestore
  //      await groupRef.set({
  //        'groupName': groupName, // اسم المجموعة
  //        'groupId': groupId, // اسم المجموعة
  //        'adminId': adminId,     // هوية المسؤول
  //        'members': membersMap,  // الأعضاء
  //        'createdAt': FieldValue.serverTimestamp(), // وقت الإنشاء
  //      });
  //
  //      print("Group created successfully with ID: ${groupRef.id}");
  //    } catch (e) {
  //      print("Failed to create group: $e");
  //    }
  //  }

  static Stream<List<Map<String, dynamic>>> getGroupMembers(String groupId) {
    try {
      // مرجع للمجموعة التي تحتوي على الأعضاء
      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupId);

      // الاستماع للتغييرات في البيانات الخاصة بالمجموعة
      return groupRef.snapshots().map((documentSnapshot) {
        // التأكد من وجود بيانات المجموعة
        if (documentSnapshot.exists) {
          // جلب البيانات من المجموعة
          var data = documentSnapshot.data();

          // التأكد من أن البيانات هي من النوع Map<String, dynamic>
          if (data is Map<String, dynamic>) {
            // جلب الأعضاء من الحقل 'members' الموجود في بيانات المجموعة
            Map<String, dynamic> members =
                Map<String, dynamic>.from(data['members'] ?? {});

            // تحويل الأعضاء إلى قائمة من Map<String, dynamic>
            List<Map<String, dynamic>> memberList = members.values
                .map((e) => Map<String, dynamic>.from(
                    e)) // التأكد من تحويل كل عنصر إلى Map<String, dynamic>
                .toList();

            return memberList;
          }
        }
        return [];
      });
    } catch (e) {
      print("Error fetching group members: $e");
      return Stream.value([]); // إرجاع Stream فارغ في حالة وجود خطأ
    }
  }

  static Future<void> createGroup({
    required String groupName,
     String? groupImage,
    required String groupId,
    required String adminId,
    required List<Map<String, dynamic>>
        initialMembers, // قائمة الأعضاء المبدئيين مع التفاصيل
  }) async {
    try {
      // إنشاء مرجع للمجموعة الجديدة
      DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

      // تحويل قائمة الأعضاء إلى صيغة Map حيث المفتاح هو memberId والقيمة هي التفاصيل
      Map<String, Map<String, dynamic>> membersMap = {
        for (var member in initialMembers)
          if (member['userId'] != null) member['userId']: member
      };

      // إضافة بيانات المجموعة إلى Firestore
      await groupRef.set({
        'groupName': groupName,
        'groupImage': groupImage??'defaultImage',
        'groupId': groupId, // معرف المجموعة
        'adminId': adminId, // هوية المسؤول
        'members': membersMap,
        // 'lastMessage': {
        //   "content":'',
        //   "type":'',
        //   "dateTime":DateTime.now(),
        //   'readBy': {adminId: true},
        // },
        'createdAt': FieldValue.serverTimestamp(), // وقت الإنشاء
      });

      print("Group created successfully with ID: ${groupRef.id}");
    } catch (e, stack) {
      print("Failed to create group: $e");
      print("Failed to create group: $stack");
    }
  }

  static Future<void> lastMessage({
    required String groupId,
    required String type,
    required String lastMessage,
    required String senderId,
})async {
    try{
      DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
      await groupRef.update({
        'lastMessage': {
          "content":lastMessage,
          "type":type,
          "dateTime":DateTime.now(),
          'readBy': {senderId: true},
        },
      });
    }catch (e, stack) {
      print("Failed to create group: $e");
      print("Failed to create group: $stack");
    }


  }




  static Stream<Map<String, dynamic>> getLastMessage(String groupId) {
    try {
      DocumentReference groupRef =
      FirebaseFirestore.instance.collection('groups').doc(groupId);

      return groupRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data(); // الحصول على البيانات الخام

          if (data is Map<String, dynamic>) {
            // التأكد أن البيانات من النوع الصحيح وتحويل حقل lastMessage
            return Map<String, dynamic>.from(data['lastMessage'] ?? {});
          }
        }
        return {};
      });
    } catch (e) {
      print("Error fetching last message: $e");
      return const Stream.empty();
    }
  }


  static Future<void> markMessageAsRead({
    required String groupId,
    required String userId,
  }) async {
    try {
      DocumentReference groupRef =
      FirebaseFirestore.instance.collection('groups').doc(groupId);

      await groupRef.update({
        'lastMessage.readBy.$userId': true,
      });
    } catch (e, stack) {
      print("Failed to mark message as read: $e");
      print("Stack trace: $stack");
    }
  }


//
  static Future<List<Map<String, dynamic>>> fetchUserGroups() async {
    try {
      // الحصول على هوية المستخدم الحالي
      String currentUserId =
          DIManager.findDep<SharedPrefs>().getUserID().toString();

      // استعلام لجلب المجموعات التي تحتوي على المستخدم كعضو
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('members.$currentUserId',
              isGreaterThan: {}) // التحقق من أن المستخدم موجود في الأعضاء
          .get();

      // تحويل النتائج إلى قائمة من البيانات
      List<Map<String, dynamic>> userGroups = querySnapshot.docs
          .map((doc) => {
                'groupId': doc.id, // تحديد معرف المجموعة بشكل صحيح
                ...doc.data() as Map<String, dynamic>, // إضافة باقي البيانات
              })
          .toList();

      return userGroups;
    } catch (e) {
      print("Error fetching user groups: $e");
      return [];
    }
  }

  static Future<void> updateGroupInfo(context,{
   required String groupId,
    required   String newGroupName,
  }) async {
    try {

      DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);


      await groupRef.update({
        'groupName': newGroupName,
        // 'groupImage': newGroupImage,
      });

      print('Group updated successfully!');
      SnackBarHelper.mySnackBarSuccess('تم تعديل اسم المجموعة بنجاح ..', context);
    } catch (e) {
      print('Error updating group: $e');
      SnackBarHelper.mySnackBarError(e.toString(), context);
    }
  }


  //
  //
  // static Future<List<Map<String, dynamic>>> fetchUserGroups() async {
  //   try {
  //     // الحصول على هوية المستخدم الحالي
  //     String currentUserId = DIManager.findDep<SharedPrefs>().getUserID().toString();
  //
  //     // استعلام لجلب المجموعات التي تحتوي على المستخدم كعضو
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('groups')
  //         .where('members.$currentUserId', isNotEqualTo: null) // التأكد من أن المستخدم موجود كعضو
  //         .get();
  //
  //     // تحويل النتائج إلى قائمة من البيانات
  //     List<Map<String, dynamic>> userGroups = querySnapshot.docs
  //         .map((doc) => {
  //       'userId': doc.id,
  //       ...doc.data() as Map<String, dynamic>,
  //     })
  //         .toList();
  //
  //     return userGroups;
  //   } catch (e) {
  //     print("Error fetching user groups: $e");
  //     return [];
  //   }
  // }

  static Future<void> addMember(String groupId, String memberId,
      Map<String, dynamic> memberDetails, context) async {
    try {
      // الحصول على بيانات المجموعة
      final groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (!groupDoc.exists) {
        print("Group $groupId does not exist.");
        return;
      }

      // التحقق مما إذا كان العضو موجودًا مسبقًا
      final members =
          Map<String, dynamic>.from(groupDoc.data()?['members'] ?? {});
      if (members.containsKey(memberId)) {
        SnackBarHelper.mySnackBarError(
            'الشخص موجود بالفعل بالمجموعة ...', context);
        return;
      }

      // إضافة العضو مع التفاصيل أو تعديلها
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        'members.$memberId': {
          // إضافة أو تعديل تفاصيل العضو
          ...memberDetails,
          // إضافة العناصر الحالية
          'joinDate': DateTime.now().toIso8601String(),
          // مثال على إضافة تاريخ الانضمام
          // يمكنك إضافة المزيد من التفاصيل هنا إذا لزم الأمر
        },
      });

      SnackBarHelper.mySnackBarSuccess(
          'تم إضافة الشخص إلى المجموعة بنجاح', context);
    } catch (e) {
      print("Failed to add member: $e");
      SnackBarHelper.mySnackBarError('حدث خطأ أثناء إضافة العضو ...', context);
    }
  }

  static Future<void> removeMember(
      String groupId, String memberId, context) async {
    try {
      // الحصول على بيانات المجموعة
      final groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (!groupDoc.exists) {
        print("Group $groupId does not exist.");
        return;
      }

      // التحقق مما إذا كان العضو موجودًا في المجموعة
      final members =
          Map<String, dynamic>.from(groupDoc.data()?['members'] ?? {});
      if (!members.containsKey(memberId)) {
        SnackBarHelper.mySnackBarError(
            'الشخص غير موجود في المجموعة ...', context);
        return;
      }

      // حذف العضو من الحقل 'members'
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        'members.$memberId': FieldValue.delete(),
      });
      if (memberId == DIManager.findDep<SharedPrefs>().getUserID().toString()) {
        SnackBarHelper.mySnackBarSuccess('تم الخروج من المجموعة بنجاح', context);
      } else {
        SnackBarHelper.mySnackBarSuccess(
            'تم حذف الشخص من المجموعة بنجاح', context);
      }
    } catch (e) {
      print("Failed to remove member: $e");
      SnackBarHelper.mySnackBarError('حدث خطأ أثناء حذف العضو ...', context);
    }
  }

  static Future<void> removeGroup(String groupId, context) async {
    try {
      // الحصول على مرجع للمجموعة
      final groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (!groupDoc.exists) {
        SnackBarHelper.mySnackBarError('المجموعة غير موجودة.', context);
        return;
      }

      // حذف المجموعة من Firestore
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete();

      SnackBarHelper.mySnackBarSuccess('تم حذف المجموعة بنجاح.', context);
    } catch (e) {
      print("Failed to remove group: $e");
      SnackBarHelper.mySnackBarError('حدث خطأ أثناء حذف المجموعة.', context);
    }
  }

  // static Future<void> addMember(String groupId, String memberId,context) async {
  //   try {
  //     // الحصول على بيانات المجموعة
  //     final groupDoc = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
  //
  //     if (!groupDoc.exists) {
  //       print("Group $groupId does not exist.");
  //       return;
  //     }
  //
  //     // التحقق مما إذا كان العضو موجودًا مسبقًا
  //     final members = Map<String, dynamic>.from(groupDoc.data()?['members'] ?? {});
  //     if (members.containsKey(memberId)) {
  //       SnackBarHelper.mySnackBarError('الشخص موجود بالفعل بالغروب ...', context);
  //       return;
  //     }
  //
  //     // إضافة العضو
  //     await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
  //       'members.$memberId': true,
  //     });
  //
  //     SnackBarHelper.mySnackBarSuccess('تم إضافة الشخص إلى للغروب بنجاح', context);
  //   } catch (e) {
  //     print("Failed to add member: $e");
  //   }
  // }

  // static Future<void> removeMember(String groupId, String memberId) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
  //       'members.$memberId': FieldValue.delete(),
  //     });
  //     print("Member $memberId removed from group $groupId");
  //   } catch (e) {
  //     print("Failed to remove member: $e");
  //   }
  // }

  static Future<bool> isAdmin(String userId, String groupId) async {
    try {
      final groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();
      return groupDoc.data()?['adminId'] == userId;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  static Stream<List<DataMassageModel>> getGroupMessages(String groupId) {
    try {
      // مرجع الرسائل داخل المجموعة
      CollectionReference messagesRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('messages');

      // الاستماع للتغييرات في الرسائل وتحويلها إلى قائمة من DataMassageModel
      return messagesRef
          .orderBy('dateTime',
              descending: false) // ترتيب الرسائل حسب وقت الإرسال (الأقدم أولاً)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return DataMassageModel.forJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print("Error fetching messages: $e");
      return const Stream.empty(); // إعادة Stream فارغ في حالة الخطأ
    }
  }

  static Future<void> sendMessageToGroup({
    required String groupId,
    required DataMassageModel dataMassageModel,
  }) async {
    try {
      // مرجع مجموعة الرسائل داخل المجموعة
      CollectionReference messagesRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('messages');

      // إضافة الرسالة إلى Firestore
      await messagesRef.add({
        'senderId': dataMassageModel.senderId,
        'text': dataMassageModel.text,
        'type': dataMassageModel.type,
        'senderName': dataMassageModel.senderName,
        'senderImage': dataMassageModel.senderImage,
        'totalDurationRecord': dataMassageModel.totalDurationRecord,
        'dateTime': DateTime.now(),
      });

      print("Message sent successfully to group $groupId");
    } catch (e) {
      print("Failed to send message: $e");
    }
  }
}
