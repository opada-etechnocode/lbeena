import 'dart:async';

import 'package:syrians_in_uae/ui/screens/chats/chat_messages_ad.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/chats/ads_chats_model.dart';
import '../../../data/models/chats/message_model.dart';
import '../../../widgets/components.dart';
import '../../widget/main_page_chats.dart';
import 'chat_messages_post.dart';
import 'cubit/apis_chat_firebase.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({super.key, required this.type});

  String type;

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with WidgetsBindingObserver, LifecycleMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    onAppLifecycleChange(AppLifecycleState.resumed);
    chatBlocFirebase.getAllAdsChats(
        user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
        type: widget.type);
    chatBlocFirebase.getAdsLastInfo(
        user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
        type: widget.type);
    isLoading = true;
  }

  String statusUser = 'resumed';

  @override
  void onAppLifecycleChange(AppLifecycleState state) {
    setState(() {
      if (DIManager.findDep<SharedPrefs>().getUserID() != null) {
        if (state == AppLifecycleState.resumed) {
          APIs.updateStatusUser(
            userStatus: state.name.toString(),
          );
        } else {
          APIs.updateStatusUser(
            userStatus: DateTime.now().toString(),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<AdsChatsModel> adsChatsModel = [];
  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
      bloc: chatBlocFirebase,
      listener: (context, state) {
        if (state is GetAllAdsChatsLoadingState) {
          isLoading = true;
        } else {
          isLoading = false;
        }

        if (state is DeleteMessagesLoadingState) {
          isLoading = true;
        } else {
          isLoading = false;
        }

        if (state is GetAllAdsChatsSuccessState) {
          adsChatsModel = state.adsChatsModel;
        } else {
          isLoading = false;
        }
      },
      builder: (context, state) {
        return Expanded(
          flex: 3,
          child: isLoading
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [loaderNormal(), Spacer(), Container()],
                  ),
                )
              : chatBlocFirebase.adsLastInfo.length == 0
                  ? Center(
                      child: Container(
                        child: Text('لايوجد محادثات بعد'),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        //  print(chatBlocFirebase.adsChatsModel[index].massage);
                        // List<DataMassageModel> m =chatBlocFirebase.messages;
                        //  print(m[index].text);
// print(object)
                        if (index == chatBlocFirebase.adsLastInfo.length - 1) {
                          return Column(children: [
                            _buildBodyChats(
                                chatBlocFirebase.adsLastInfo[index]),
                            SizedBox(height: 100.h)
                          ]);
                        }
                        return _buildBodyChats(
                            chatBlocFirebase.adsLastInfo[index]);
                      },
                      // separatorBuilder: (context, index) {
                      //   if(index==chatBlocFirebase.adsLastInfo.length-1){
                      //     return Container(
                      //       height: 50.h,
                      //     );
                      //   }
                      //   return Container();
                      // },
                      itemCount: chatBlocFirebase.adsLastInfo.length,
                    ),
        );
      },
    );
  }

  _buildBodyChats(
    AdsChatsModel data,
  ) {
    return InkWell(
        onTap: () {
          if (widget.type == 'ads') {
            navigatorToPush(
                context: context,
                pageName: ChatMessagesPage(
                  dataMessage: ArgumentMessage(
                    nameOwnerAds: data.nameOwnerAds,
                    nameAds: data.nameAds,

                    imageAds: data.imageAds,
                    imageCompany: data.imageCompany,
                    idAdOnwerCompany: data.idAdOnwerCompany,
                    imageUser: data.imageUser,
                    ad_id: int.parse(data.ad_id.toString()),
                    user_id: data.user_id.toString(),
                    read: data.massage,
                    idBannerOrProduct: data.idBannerOrProduct,
                    isBannerInOut: data.isBannerInOut,
                    isBanner: data.isBanner,
                    categoryId: data.categoryId,
                    // user_id_firebase: DIManager.findDep<SharedPrefs>().getUserID().toString(),
                    user_id_2: int.parse(data.user_id_2.toString()),
                    user_name_person_sender: data.userNamePersonSender,
                  ),
                ));
          } else {
            navigatorToPush(
                context: context,
                pageName: ChatMessagesPost(
                  dataMessage: ArgumentMessage(
                    nameOwnerAds: data.nameOwnerAds,
                    nameAds: data.nameAds,

                    imageAds: data.imageAds,
                    imageCompany: data.imageCompany,
                    idAdOnwerCompany: data.idAdOnwerCompany,
                    imageUser: data.imageUser,
                    ad_id: int.parse(data.ad_id.toString()),
                    user_id: data.user_id.toString(),
                    read: data.massage,
                    idBannerOrProduct: data.idBannerOrProduct,
                    isBannerInOut: data.isBannerInOut,
                    isBanner: data.isBanner,
                    categoryId: data.categoryId,
                    // user_id_firebase: DIManager.findDep<SharedPrefs>().getUserID().toString(),
                    user_id_2: int.parse(data.user_id_2.toString()),
                    user_name_person_sender: data.userNamePersonSender,
                  ),
                ));
          }
        },
        child: MainPageChat(
          adsData: data,
          type: widget.type,
        ));
  }
}
