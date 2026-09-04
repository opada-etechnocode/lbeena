import 'dart:async';
import 'dart:developer';
import 'dart:io';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/chats/message_model.dart';
import '../../../widgets/components.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import 'cubit/apis_chat_firebase.dart';

class ChatDetailsGroup extends StatefulWidget {
  final ArgumentMessageGroup? dataMessage;

  const ChatDetailsGroup({Key? key, this.dataMessage}) : super(key: key);

  @override
  State<ChatDetailsGroup> createState() => _ChatDetailsGroupState();
}

class _ChatDetailsGroupState extends State<ChatDetailsGroup>
    with WidgetsBindingObserver, LifecycleMixin {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: HandelAndroidApp(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: appTheme.scaffoldBackgroundColor100,
            leading: SizedBox(),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                    APIs.updateStatusUser(userStatus: 'resumed');
                  },
                ),

                SizedBox(width: 7.w), // Space between image and text
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 240.w,
                        child: textNormal(text:
                        widget.dataMessage!.groupName.toString(),
                          // style: themeLite.textTheme.titleSmall,
                        ),)
                    ],
                  ),
                ),
              ],
            ),
            leadingWidth: 0.w,
          ),
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Edit Name Group
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Column(
              //
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding:   EdgeInsets.symmetric(horizontal: 10.w),
              //         child: textNormal(text: 'تعديل اسم المجموعة: ',fontSize: 10.sp),
              //       ),
              //       sizeHeightNormal(height: 5.sp),
              //       Row(
              //         children: [
              //
              //           CustomTextFormField(
              //             width: 200.w,
              //             hintText: widget.dataMessage!.groupName.toString(),
              //           ),
              //           sizeWidthNormal(
              //             width: 15.w
              //           ),
              //           CustomElevatedButton(
              //               width: 65.w,
              //               text: 'تأكيد',
              //           buttonTextStyle: themeLite.textTheme.bodySmall,),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: 450.h,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: APIs.getGroupMembers(widget.dataMessage!.groupId.toString()), // استدعاء الدالة التي تجلب الأعضاء
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: appTheme.greenColor,),);
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ أثناء تحميل الأعضاء'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('لا يوجد أعضاء في هذه المجموعة.'));
                    }

                    final members = snapshot.data!;

                    return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        print(member['profileImage']);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: AppDecoration.pointChoose,
                            child:  ListTile(
                              title: widget.dataMessage!.adminId ==member['userId']?
                              Row(
                                children: [
                                  Container(
                                      width: 160.w,
                                      child: textNormal(text: member['userName'],fontSize:12)),
                                  sizeWidthNormal(
                                    width: 4.w
                                  ),
                                  textNormal(text: '(الآدمن)',fontSize:12,color: Colors.green),
                                ],
                              )
                                  : textNormal(text: member['userName'],fontSize:12),
                              trailing:  widget.dataMessage!.adminId ==member['userId']?null:widget.dataMessage!.adminId !=DIManager.findDep<SharedPrefs>().getUserID()?null:PopupMenuButton(
                                color: appTheme.lightBlueBottomNavigatorBar,
                                child: CustomImageView(
                                  imagePath: ImageConstant.iconList,
                                  height: 15.h,
                                  width: 15.h,
                                  color: appTheme.deepPurpleA10002,
                                ),
                                // Use a specific widget
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: textNormal(text: 'حذف'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == "delete") {
                                    deleteUser(
                                      context,
                                        member['userId']
                                    ,
                                    widget.dataMessage!.groupId.toString());

                                  }

                                  // Handle menu item selection here
                                },
                              ),
                              // subtitle: Text(member['profileImage'] ?? 'لا صورة'),
                              leading:member['profileImage'] ==''||member['profileImage'] =='null' ||member['profileImage'] =='default_image_url'? CustomImageView(
                                radius:BorderRadius.circular(333),
                                width: 30.w,
                                height: 30.w,
                                imagePath: ImageConstant.imgPerson,
                              ): CustomImageView(
                                imagePath: member['profileImage'] ,
                                radius:BorderRadius.circular(333),
                                width: 30.w,
                                height: 30.w,
                                fit: BoxFit.fill,
                                placeHolder: ImageConstant.imgPerson,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),


              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(widget.dataMessage!.adminId !=DIManager.findDep<SharedPrefs>().getUserID())...{
                    ElevatedButton(onPressed: (){
                      logoutGroup(context,widget.dataMessage!.groupId.toString());

                    }, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textNormal(text: 'الخروج من المجموعة',color: Colors.red,fontSize: 10),
                    )),
                  }else ...{

                    ElevatedButton(onPressed: (){
                      deleteGroup(context,widget.dataMessage!.groupId.toString());

                    }, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textNormal(text: 'حذف المجموعة',color: Colors.red,fontSize: 10),
                    )),
                  }


                ],
              ),
            ],
          )
          ,
        ),
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
                            Navigator.pop(context),
                            Navigator.pop(context),
                            Navigator.pop(context),
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
                              Navigator.pop(context),
                              Navigator.pop(context),
                              Navigator.pop(context),
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
