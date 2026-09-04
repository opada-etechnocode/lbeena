import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/widgets/components.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/theme_helper.dart';
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

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text: AppLocalizations.of(
            context)!
            .chat, context: context),
        body: Column(
          children: [

            if (DIManager.findDep<
                SharedPrefs>()
                .getStatusUserIsBlocked() ==
                0) ...{
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 250.h),
                  child: Container(
                    child: textNormal(
                        text:
                        'الحساب محظور لا يمكنك الدردشة ...'),
                  ),
                ),
              )
            } else ...{
              token == null
                  ? Container()
                  : Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child:
                        ElevatedButton(
                          child: textNormal(
                              text:
                              'مجموعات',color: type2 ==
                              2
                              ? Colors.white:null),
                          style:
                          ButtonStyle(
                            backgroundColor: type2 ==
                                2
                                ? MaterialStateProperty.all<
                                Color>(
                                appTheme
                                    .greenColor)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              type =
                              'ads';
                              type2 = 2;
                            });
                          },
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child:
                        ElevatedButton(
                          child: textNormal(
                              text:
                              'اعلانات',
                          color: type2 ==
                              0
                              ? Colors.white:null),
                          style:
                          ButtonStyle(
                            backgroundColor: type2 ==
                                0
                                ? MaterialStateProperty.all<
                                Color>(
                                appTheme
                                    .greenColor)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              type =
                              'ads';
                              type2 = 0;
                              chatBlocFirebase.getAllAdsChats(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),
                                  type:
                                  'ads');
                              chatBlocFirebase.getAdsLastInfo(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),
                                  type:
                                  'ads');
                            });
                          },
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child:
                        ElevatedButton(
                          child: textNormal(
                              text:
                              'منشورات',color: type2 ==
                              1
                              ? Colors.white:null),
                          style:
                          ButtonStyle(
                            backgroundColor: type2 ==
                                1
                                ? MaterialStateProperty.all<
                                Color>(
                                appTheme
                                    .greenColor)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              type =
                              'post';
                              type2 = 1;
                              chatBlocFirebase.getAllAdsChats(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),
                                  type:
                                  'post');
                              chatBlocFirebase.getAdsLastInfo(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),
                                  type:
                                  'post');
                            });
                          },
                        ),
                      )),
                ],
              ),
              if (type2 == 0) ...{
                token == null
                    ? buildGoToLogin(
                    context)
                    : ChatsScreen(
                  type: 'ads',
                )
              } else if (type2 == 1) ...{
                token == null
                    ? buildGoToLogin(
                    context)
                    : ChatsScreen(
                  type: 'post',
                )
              } else ...{
                UserGroupsScreen(),
              }
            },
          ],
        ),
      ),
    );
  }
}
