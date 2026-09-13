import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syrians_in_uae/core/utils/lbeena_menu.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/states.dart';
import 'package:syrians_in_uae/ui/screens/community/post_screen.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/chats/data_massage_model.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/lbeena_colors.dart';
import '../chats/cubit/cubit.dart';
import '../company/company_details_page.dart';
import '../details_product/details_product.dart';
import '../reminders/reminder_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  @override
  void initState() {
    chatBlocFirebase.getNotificationsHomePage(
      user_id: DIManager.findDep<SharedPrefs>().getUserID(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

    return HandelAndroidApp(
      child: Scaffold(
        backgroundColor: isDark ? LbeenaColors.surfaceDark : LbeenaColors.lightBg,
        appBar: appBarNormalWithIcon(
          text: 'الإشعارات',
          context: context,
          isShowBack: true,
        ),
        body: RefreshIndicator(
          color: LbeenaColors.orange,
          backgroundColor: LbeenaColors.white,
          onRefresh: () async {
            chatBlocFirebase.getNotificationsHomePage(
              user_id: DIManager.findDep<SharedPrefs>().getUserID(),
            );
          },
          child: BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
            bloc: chatBlocFirebase,
            listener: (context, state) {},
            builder: (context, state) {
              if (chatBlocFirebase.notificationHomePage.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 120.h),
                    Center(
                      child: CustomImageView(
                        imagePath: ImageConstant.photoNotification2,
                        width: 220.w,
                        height: 180.h,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'لا توجد إشعارات بعد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          color: LbeenaColors.muted,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Text(
                          '${chatBlocFirebase.notificationHomePage.length} إشعار',
                          style: TextStyle(
                            color: isDark
                                ? LbeenaColors.white
                                : LbeenaColors.tealDark,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Cairo',
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            chatBlocFirebase.deleteAllNotifications(
                              user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                            );
                          },
                          child: Text(
                            'حذف الكل',
                            style: TextStyle(
                              color: LbeenaColors.orange,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: chatBlocFirebase.notificationHomePage.length,
                      itemBuilder: (context, index) {
                        final item = chatBlocFirebase.notificationHomePage[index];
                        return _NotificationCard(
                          item: item,
                          isDark: isDark,
                          onOpen: () {
                            if (item.is_read == '0') {
                              chatBlocFirebase.readNotification(
                                user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                                notificationId: item.id!,
                              );
                            }
                            showNotificationsDetails(context, item);
                          },
                          onDelete: () {
                            chatBlocFirebase.deleteOneNotification(
                              user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                              notificationId: item.id!,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void showNotificationsDetails(
    BuildContext context,
    DataNotificationsHomePageModel data,
  ) {
    final canOpenDetails = data.type_notification == 'company' ||
        data.type_notification == 'post' ||
        data.type_notification == 'ads' ||
        data.type_notification == 'reminder' ||
        data.type_notification == 'follow';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: LbeenaColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            data.title.toString(),
            style: TextStyle(
              color: LbeenaColors.tealDark,
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
              fontSize: 16,
            ),
          ),
          content: Text(
            data.body.toString(),
            style: const TextStyle(
              color: LbeenaColors.muted,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: LbeenaColors.teal,
                      side: BorderSide(color: LbeenaColors.fieldBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'تم',
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                if (canOpenDetails) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (data.type_notification == 'company') {
                          navigatorToPush(
                            context: context,
                            pageName: CompanyDetailsPage(
                              idCompany: int.parse(data.user_id.toString()),
                            ),
                          );
                        } else if (data.type_notification == 'post') {
                          navigatorToPush(
                            context: context,
                            pageName: PostScreen(
                              idPost: int.parse(data.post_id.toString()),
                            ),
                          );
                        } else if (data.type_notification == 'ads') {
                          navigatorToPush(
                            context: context,
                            pageName: DetailsProduct(
                              categoryId: data.category_id.toString(),
                              isBannerInOut: data.in_out == '1' ? true : false,
                              idAds: data.ad_id.toString(),
                              isBanner: data.isBanner == '1' ? true : false,
                              idBannerOrProduct: data.isBanner == '1'
                                  ? int.parse(data.banner_id.toString())
                                  : int.parse(data.ad_id.toString()),
                              idAdOnwerCompany: int.parse(data.user_id!.toString()),
                            ),
                          );
                        } else if (data.type_notification == 'reminder') {
                          navigatorToPush(
                            context: context,
                            pageName: RemindersItem(
                              idReminder: int.parse(data.reminder_id!),
                              reminderOthers: int.parse(data.reminder_others!),
                            ),
                          );
                        } else if (data.type_notification == 'follow') {
                          navigatorToPush(
                            context: context,
                            pageName: CompanyDetailsPage(
                              idCompany: int.parse(data.following_id.toString()),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LbeenaColors.orange,
                        foregroundColor: LbeenaColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'انتقل للتفاصيل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onOpen,
    required this.onDelete,
    required this.isDark,
  });

  final DataNotificationsHomePageModel item;
  final VoidCallback onOpen;
  final VoidCallback onDelete;
  final bool isDark;

  bool get _unread => item.is_read.toString() == '0';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: LbeenaColors.cardWith(
              color: isDark
                  ? (_unread
                      ? LbeenaColors.teal.withValues(alpha: 0.22)
                      : LbeenaColors.cardDark)
                  : (_unread
                      ? LbeenaColors.teal.withValues(alpha: 0.06)
                      : LbeenaColors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        _iconForType(item.type_notification),
                        size: 16,
                        color: LbeenaColors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? LbeenaColors.white
                                      : LbeenaColors.tealDark,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (_unread)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: LbeenaColors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? LbeenaColors.fieldHint
                                : LbeenaColors.muted,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.created_at == null
                              ? ''
                              : convertDateFromFirebase(item.created_at!),
                          style: TextStyle(
                            color: LbeenaColors.orange,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'المزيد',
                    color: LbeenaColors.white,
                    padding: EdgeInsets.zero,
                    constraints: LbeenaMenu.constraints,
                    offset: const Offset(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.trashCan,
                              size: 15,
                              color: LbeenaColors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'حذف',
                              style: TextStyle(
                                color: LbeenaColors.tealDark,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: FaIcon(
                        FontAwesomeIcons.ellipsisVertical,
                        size: 16,
                        color: LbeenaColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FaIconData _iconForType(String? type) {
    switch (type) {
      case 'ads':
        return FontAwesomeIcons.bullhorn;
      case 'post':
        return FontAwesomeIcons.comments;
      case 'company':
        return FontAwesomeIcons.building;
      case 'follow':
        return FontAwesomeIcons.userPlus;
      case 'reminder':
        return FontAwesomeIcons.calendar;
      default:
        return FontAwesomeIcons.bell;
    }
  }
}

String convertDate({required String date}) {
  DateTime createdAtDateTime =
      DateTime.parse(date == 'null' ? '2024-04-25 12:13:42' : date);
  return DateFormat('yyyy-MM-dd').format(createdAtDateTime).toString();
}

String convertDateFromFirebase(Timestamp timestamp) {
  try {
    DateTime createdAtDateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(createdAtDateTime);
  } catch (e) {
    print("convertDate error: $e");
    return "";
  }
}
