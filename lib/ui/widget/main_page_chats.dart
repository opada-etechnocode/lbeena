import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/data/models/chats/ads_chats_model.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/states.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/user_image_profile.dart';

class MainPageChat extends StatefulWidget {
  final AdsChatsModel? adsData;
  final String? index;
  final String? type;

  MainPageChat({Key? key, this.adsData, this.index, required this.type})
      : super(key: key);

  @override
  State<MainPageChat> createState() => _MainPageChatState();
}

class _MainPageChatState extends State<MainPageChat> {
  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();

  bool get _hasUnread =>
      widget.adsData!.read !=
      DIManager.findDep<SharedPrefs>().getUserID().toString();

  String get _peerName => userId == widget.adsData!.user_id.toString()
      ? widget.adsData!.nameOwnerAds.toString()
      : widget.adsData!.userNamePersonSender.toString();

  String get _avatar {
    final image = widget.adsData?.imageAds.toString();
    if (isEmptyProfileImage(image) ||
        image == 'https://syriansinuae.com' ||
        image == 'https://www.syriansinuae.com') {
      return ImageConstant.imgPerson;
    }
    return image!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
      child: Container(
        decoration: LbeenaColors.cardWith(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _hasUnread
                            ? LbeenaColors.orange
                            : LbeenaColors.fieldBorder,
                        width: 1.8,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageView(
                        imagePath: _avatar,
                        fit: BoxFit.cover,
                        height: 52,
                        width: 52,
                        placeHolder: ImageConstant.imgPerson,
                      ),
                    ),
                  ),
                  if (_hasUnread)
                    Positioned(
                      left: 2,
                      top: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: LbeenaColors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: LbeenaColors.white, width: 1.2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _peerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: LbeenaColors.tealDark,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.adsData!.nameAds.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: LbeenaColors.muted,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.adsData!.type == 'image')
                      Row(
                        children: [
                          Icon(Icons.image_outlined,
                              size: 14, color: LbeenaColors.orange),
                          const SizedBox(width: 4),
                          const Text(
                            'صورة',
                            style: TextStyle(
                              fontSize: 12,
                              color: LbeenaColors.muted,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      )
                    else if (widget.adsData!.type == 'record')
                      Row(
                        children: [
                          Icon(Icons.mic_none_rounded,
                              size: 14, color: LbeenaColors.orange),
                          const SizedBox(width: 4),
                          const Text(
                            'تسجيل صوتي',
                            style: TextStyle(
                              fontSize: 12,
                              color: LbeenaColors.muted,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        widget.adsData!.massage ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: _hasUnread
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: AppFontSize.fontSize_12,
                          color: LbeenaColors.black,
                          fontFamily: 'Cairo',
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.adsData!.dateTime != null
                        ? getComparedTime(
                            DateTime.parse(widget.adsData!.dateTime.toString()),
                          ).toString()
                        : '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _hasUnread
                          ? LbeenaColors.orange
                          : LbeenaColors.muted,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
                    bloc: chatBlocFirebase,
                    listener: (context, state) {},
                    builder: (context, state) {
                      final isLoading =
                          chatBlocFirebase.isLoading(widget.adsData!.ad_id!);
                      if (isLoading) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: LbeenaColors.orange,
                            ),
                          ),
                        );
                      }
                      return PopupMenuButton<String>(
                        tooltip: 'المزيد',
                        color: LbeenaColors.white,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 140),
                        offset: const Offset(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onSelected: (value) {
                          if (value != 'delete') return;
                          chatBlocFirebase.deleteChat(
                            user_id:
                                DIManager.findDep<SharedPrefs>().getUserID()!,
                            ad_id: widget.adsData!.ad_id!.toString(),
                            user_id_2: widget.adsData!.user_id_2.toString() ==
                                    DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString()
                                ? widget.adsData!.user_id.toString()
                                : widget.adsData!.user_id_2.toString(),
                            type: widget.type!,
                            receiverId: widget.adsData!.user_id_2.toString(),
                          );
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
                                  'حذف المحادثة',
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
                          padding: const EdgeInsets.only(top: 4),
                          child: FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 16,
                            color: LbeenaColors.muted,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
