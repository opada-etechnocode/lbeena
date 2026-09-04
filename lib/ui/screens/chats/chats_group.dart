import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/screens/chats/chats_details_group.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/apis_chat_firebase.dart';
import 'package:syrians_in_uae/widgets/components.dart';

import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/chats/message_model.dart';
import '../../../widgets/custom_image_view.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import 'chats_messages_group.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class UserGroupsScreen extends StatefulWidget {
  @override
  _UserGroupsScreenState createState() => _UserGroupsScreenState();
}

class _UserGroupsScreenState extends State<UserGroupsScreen> {
  List<Map<String, dynamic>> userGroups = [];
  bool isLoading = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    fetchGroups();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  Future<void> fetchGroups() async {
    setState(() => isLoading = true);

    userGroups = await APIs.fetchUserGroups();

    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:FirebaseFirestore.instance
          .collection('groups')
          .where('members.${DIManager.findDep<SharedPrefs>().getUserID()}',isGreaterThan: {})
          // .orderBy('createdAt', descending: true)
          // .orderBy('lastMessage.dateTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.5),
            child: Center(child: CircularProgressIndicator(color: appTheme.greenColor,),),
          );
        }
        if (snapshot.error != null) {
          print(snapshot.error);
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.5),
            child: Center(child:CircularProgressIndicator(color: appTheme.greenColor,),),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.5),
            child: Center(child: Text("لا توجد مجموعات لعرضها")),
          );
        }

        // final userGroups = snapshot.data!.docs.map((doc) => doc.data()).toList();
        final userGroups = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = userGroups.length - 1; i >= 0; i--) ...{
                  InkWell(
                    onTap: () {
                      navigatorToPush(
                        context: context,
                        pageName: ChatMessagesGroup(
                          dataMessage: ArgumentMessageGroup(
                            groupId: userGroups[i]['groupId'],
                            adminId: userGroups[i]['adminId'] ?? '',
                            createdAt: userGroups[i]['createdAt'].toString() ?? '',
                            groupName: userGroups[i]['groupName'] ?? '',
                            userGroups:  userGroups[i],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      child: Container(
                        height: 70.h,
                        decoration: AppDecoration.card3d,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              userGroups[i]['groupImage'] == 'defaultImage' || userGroups[i]['groupImage'] == null
                                  ? CustomImageView(
                                imagePath: ImageConstant.groupImage,
                                width: 35.w,
                                height: 35.w,
                              )
                                  : CustomImageView(
                                imagePath: userGroups[i]['groupImage'],
                                width: 35.w,
                                height: 35.w,
                                fit: BoxFit.fill,
                                radius: BorderRadius.circular(333),
                              ),
                              sizeWidthNormal(width: 15.w),
                              Container(
                                width: 200.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 220.w,
                                      child: textNormal(
                                        text: userGroups[i]['groupName'] ?? "بدون اسم",
                                        fontSize: 15.5.sp,
                                      ),
                                    ),
                                    buildLastMessage(userGroups[i]['groupId']),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 80.w,
                                child: Column(
                                  children: [
                                    textNormal(
                                      text: formatDate(userGroups[i]['createdAt']),
                                      fontWeight: FontWeight.w200,
                                      fontSize: 11.sp,
                                    ),
                                    sizeHeightNormal(height: 4.h),
                                    if (userGroups[i]['adminId'] == DIManager.findDep<SharedPrefs>().getUserID().toString()) ...{
                                      Container(
                                        width: 25.w,
                                        height: 25.w,
                                        child: IconButton(
                                          iconSize: 25.sp,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            deleteGroup(context, userGroups[i]['groupId'], isFromDetailsGroup: false);
                                          },
                                          icon: Icon(Icons.delete_outline),
                                        ),
                                      ),
                                    } else ...{
                                      Container(
                                        width: 25.w,
                                        height: 25.w,
                                        child: IconButton(
                                          iconSize: 20.sp,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            logoutGroup(context, userGroups[i]['groupId'], isFromDetailsGroup: false);
                                          },
                                          icon: Icon(Icons.logout),
                                        ),
                                      ),
                                    }
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                },
                sizeHeightNormal(
                  height: 70.h
                ),
              ],
            ),
          ),
        );

        // return Expanded(
        //   flex: 3,
        //   child: ListView.builder(
        //     itemCount: userGroups.length,
        //     controller: _scrollController,
        //     padding: EdgeInsets.only(bottom: 100.h),
        //   shrinkWrap: true,
        //   reverse: true,
        //     itemBuilder: (context, index) {
        //       Map<String, dynamic> group = userGroups[index] as Map<String, dynamic>;
        //
        //       return InkWell(
        //         onTap: () {
        //           navigatorToPush(
        //             context: context,
        //             pageName: ChatMessagesGroup(
        //               dataMessage: ArgumentMessageGroup(
        //                 groupId: group['groupId'] ?? '',
        //                 adminId: group['adminId'] ?? '',
        //                 createdAt: group['createdAt'].toString() ?? '',
        //                 groupName: group['groupName'] ?? '',
        //               ),
        //             ),
        //           );
        //
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        //           child: Container(
        //             height: 55.h,
        //             decoration: AppDecoration.outlineCircular4.copyWith(
        //               borderRadius: BorderRadius.all(Radius.circular(10.r)),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: appTheme.lightBlueBottomNavigatorBar,
        //                   spreadRadius:.2,
        //                   blurRadius:.2,
        //                   offset: const Offset(0, 0),
        //                 ),
        //               ],
        //             ),
        //             child: Padding(
        //               padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 3.h ),
        //               child: Row(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 children: [
        //                   group['groupImage'] =='defaultImage'||    group['groupImage'] ==null?  CustomImageView(
        //                    imagePath: ImageConstant.groupImage,
        //                    width: 35.w,
        //                    height: 35.w,
        //
        //                  ): CustomImageView(
        //                     imagePath:  group['groupImage'] ,
        //                     width: 35.w,
        //                     height: 35.w,
        //                     fit: BoxFit.fill,
        //                     radius:BorderRadius.circular(333),
        //                   ),
        //                   sizeWidthNormal(
        //                     width: 15.w
        //                   ),
        //                   Container(
        //                     width: 200.w,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.start,
        //                       children: [
        //                         Container(
        //                             width: 220.w,
        //                             child: textNormal(text:group['groupName'] ?? "بدون اسم",
        //                             fontSize: 15.5.sp)),
        //
        //                         buildLastMessage(group['groupId']),
        //
        //
        //                       ],
        //                     ),
        //                   ),
        //                   Spacer(),
        //                   Container(
        //                     width: 80.w,
        //               child: Column(
        //
        //                 children: [
        //                   textNormal(text: formatDate(group['createdAt'] ),
        //                   fontWeight: FontWeight.w200,fontSize: 11.sp ),
        //                   sizeHeightNormal(height: 4.h),
        //                   if(group['adminId'] ==DIManager.findDep<SharedPrefs>().getUserID().toString() )...{
        //                     Container(
        //                       width: 25.w,
        //                       height: 25.w,
        //                       child:     IconButton(
        //                           iconSize: 25.sp,
        //                           padding: EdgeInsets.zero,
        //
        //                           onPressed: (){
        //                             deleteGroup(context,group['groupId'],
        //                                 isFromDetailsGroup: false);
        //                           }, icon: Icon(Icons.delete_outline)),
        //                     ),
        //
        //                   }else ...{
        //                     Container(
        //                       width: 25.w,
        //                       height: 25.w,
        //                       child:     IconButton(
        //                           iconSize: 20.sp,
        //                           padding: EdgeInsets.zero,
        //
        //                           onPressed:  (){
        //                             logoutGroup(context,group['groupId'],
        //                                 isFromDetailsGroup: false);
        //                           }, icon: Icon(Icons.logout)),
        //                     ),
        //
        //                   }
        //                 ],
        //               ),
        //             ),
        //
        //
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // );
      },
    );

  }
  Widget buildLastMessage(String groupId) {
    return Container(
      height: 20.h,width: 250.w,
      child: StreamBuilder<Map<String, dynamic>>(
        stream: APIs.getLastMessage(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: appTheme.greenColor,); // عرض تحميل أثناء انتظار البيانات
          }
          if (snapshot.hasError) {
            return textNormal(text: "خطأ في جلب البيانات",
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.red);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return textNormal(text: "لا توجد رسائل بعد",
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey);
          }

          final lastMessage = snapshot.data!;
          final content = lastMessage['content'] ?? "لا توجد رسائل بعد";
          final type = lastMessage['type'] ?? "نوع غير معروف";
          final dateTime = lastMessage['dateTime'];
          final Map<String, dynamic>? readBy = lastMessage['readBy'] as Map<String, dynamic>?;


          return Row(
            children: [
              readBy?[DIManager.findDep<SharedPrefs>().getUserID().toString()] != true?Row(
                children: [
                  sizeWidthNormal(
                      width: 5.w
                  ),
                  Container(
                    width: 5.w,height: 5.h,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,

                    ),
                  ),
                  sizeWidthNormal(
                    width: 5.w
                  )
                ],
              ):Container(),

              if(type =='text')...{
                Container(
                    width: 150.w,
                    child: textNormal(text: content.toString(),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              }else if(type =='image')...{
                CustomImageView(
                  imagePath:  content.toString(),
                  width: 45.w,
                  height: 45.w,

                ),
              }else  ...{
                Container(
                    width: 150.w,
                    child: textNormal(text: content.toString(),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              },

              // Spacer(),

            ],
          );
        },
      ),
    );
  }

  void deleteUser(BuildContext context, String userId,String groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return StatefulBuilder(
            builder: (BuildContext context1, StateSetter setState) {
              return AlertDialog(
                backgroundColor: appTheme.buttonColor,
                title: Text(
                  'هل أنت متأكد من حذف هذا الشخص ؟',
                  style: themeLite.textTheme.titleSmall,
                ),
                content: Container(
                  height: 80.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:  Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'إلغاء'),
                              ),
                            )),
                      ),
                      sizeWidthNormal(),
                      InkWell(
                        onTap: () {
                          APIs.removeMember(groupId, userId,context).then((value) =>{
                            Navigator.of(context).pop()
                          });
                        },
                        child:  Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'حذف'),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  void deleteGroup(BuildContext context,String groupId,{
    bool isFromDetailsGroup = true
  } ) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return StatefulBuilder(
            builder: (BuildContext context1, StateSetter setState) {
              return AlertDialog(
                backgroundColor: appTheme.buttonColor,
                title: Text(
                  'هل أنت متأكد من حذف المجموعة ؟',
                  style: themeLite.textTheme.titleSmall,
                ),
                content: Container(
                  height: 80.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:  Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'إلغاء'),
                              ),
                            )),
                      ),
                      sizeWidthNormal(),
                      InkWell(
                        onTap: () {
                          APIs.removeGroup(groupId,context).then((value) => {
                            if(isFromDetailsGroup){
                              navigatorToPushReplacementUntil(
                                  context: context, location: '/homePage',
                                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
                              )
                            }else {
                              Navigator.of(context).pop()
                            }

                          });
                        },
                        child:  Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'حذف'),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
  void logoutGroup(BuildContext context,String groupId ,{

    bool isFromDetailsGroup= true
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return StatefulBuilder(
            builder: (BuildContext context1, StateSetter setState) {
              return AlertDialog(
                backgroundColor: appTheme.buttonColor,
                title: Text(
                  'هل أنت متأكد من الخروج من المجموعة ؟',
                  style: themeLite.textTheme.titleSmall,
                ),
                content: Container(
                  height: 80.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:  Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'إلغاء'),
                              ),
                            )),
                      ),
                      sizeWidthNormal(),
                      InkWell(
                        onTap: () {
                          APIs.removeMember(groupId, DIManager.findDep<SharedPrefs>().getUserID().toString(),context).then((value) =>{
                            if(isFromDetailsGroup){
                              navigatorToPushReplacementUntil(
                                  context: context, location: '/homePage',
                                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
                              )
                            }else {
                              Navigator.of(context).pop()
                            }
                          });
                        },
                        child:  Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(
                                  borderRadius:
                                  BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'خروج'),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

}
