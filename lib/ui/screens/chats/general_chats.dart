import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/ui/app_general_bloc/handel_android_app.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/lbeena_chat_ui.dart';

import 'chats_group.dart';
import 'chats_screen.dart';
import 'cubit/cubit.dart';

class GeneralChatsPage extends StatefulWidget {
  const GeneralChatsPage({super.key});

  @override
  State<GeneralChatsPage> createState() => _GeneralChatsPageState();
}

class _GeneralChatsPageState extends State<GeneralChatsPage> {
  String type = 'ads';
  int type2 = 0;
  String? token = DIManager.findDep<SharedPrefs>().getToken();
  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  void _selectTab(int index) {
    setState(() {
      type2 = index;
      if (index == 0) {
        type = 'ads';
        _refreshChats('ads');
      } else if (index == 1) {
        type = 'post';
        _refreshChats('post');
      } else {
        type = 'ads';
      }
    });
  }

  void _refreshChats(String chatType) {
    final userId = DIManager.findDep<SharedPrefs>().getUserID().toString();
    chatBlocFirebase.getAllAdsChats(user_id: userId, type: chatType);
    chatBlocFirebase.getAdsLastInfo(user_id: userId, type: chatType);
  }

  @override
  Widget build(BuildContext context) {
    final isBlocked = DIManager.findDep<SharedPrefs>().getStatusUserIsBlocked() == 0;

    return HandelAndroidApp(
      child: Scaffold(
        backgroundColor: LbeenaColors.lightBg,
        appBar: appBarNormalWithIcon(
          text: AppLocalizations.of(context)!.chat,
          context: context,
        ),
        body: Column(
          children: [
            if (isBlocked)
              Padding(
                padding: EdgeInsets.only(top: 250.h),
                child: textNormal(text: 'الحساب محظور لا يمكنك الدردشة ...'),
              )
            else ...[
              if (token != null)
                LbeenaChatTabs(
                  selectedIndex: type2,
                  onChanged: _selectTab,
                ),
              if (type2 == 0)
                token == null
                    ? buildGoToLogin(context)
                    : ChatsScreen(type: 'ads')
              else if (type2 == 1)
                token == null
                    ? buildGoToLogin(context)
                    : ChatsScreen(type: 'post')
              else
                UserGroupsScreen(),
            ],
          ],
        ),
      ),
    );
  }
}
