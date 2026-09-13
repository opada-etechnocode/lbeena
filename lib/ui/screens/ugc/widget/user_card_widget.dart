import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/ugc/ugc_users_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../company/widget/following_users_page.dart';

class UserCardWidget extends StatefulWidget {
  UserCardWidget({super.key, required this.data});

  UgcUsersData data;

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  bool isLoadingShareAds = false;

  bool get _isDark => DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  bool get _isFemale =>
      widget.data.gender.toString().toLowerCase() == 'female';

  String get _photo {
    final pic = widget.data.profilePic?.toString();
    if (pic == null || pic == 'null' || pic.isEmpty) {
      return ImageConstant.imgPerson;
    }
    if (pic.contains('http')) return pic;
    return AppEndpoints.baseUrlWithoutApi + pic;
  }

  @override
  Widget build(BuildContext context) {
    final completion = _calculateProfileCompletion();
    final titleColor = _isDark ? LbeenaColors.white : LbeenaColors.tealDark;
    final muted = _isDark ? LbeenaColors.fieldHint : LbeenaColors.muted;

    return Container(
      decoration: LbeenaColors.cardWith(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar(completion),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.userName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ),
                    ),
                    if (widget.data.categoryName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.data.categoryName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final rating =
                              double.tryParse(widget.data.rating ?? '0') ?? 0;
                          return Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: FaIcon(
                              index < rating.round()
                                  ? FontAwesomeIcons.solidStar
                                  : FontAwesomeIcons.star,
                              size: 11,
                              color: LbeenaColors.star,
                            ),
                          );
                        }),
                        const SizedBox(width: 6),
                        Text(
                          widget.data.rating ?? '0',
                          style: TextStyle(
                            color: muted,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  shareCompany(
                    idCompany: widget.data.userId.toString(),
                    imageUrl: widget.data.profilePic != null
                        ? (widget.data.profilePic.toString().contains('http')
                            ? widget.data.profilePic.toString()
                            : AppEndpoints.baseUrlWithoutApi +
                                widget.data.profilePic.toString())
                        : 'null',
                    nameCompany: widget.data.userName ?? '',
                    accountType: widget.data.accountType.toString(),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isDark
                        ? LbeenaColors.surfaceDark
                        : LbeenaColors.iconTile,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isLoadingShareAds
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: LbeenaColors.orange,
                            ),
                          )
                        : FaIcon(
                            FontAwesomeIcons.shareNodes,
                            size: 14,
                            color: LbeenaColors.teal,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _chip(
                icon: _isFemale
                    ? FontAwesomeIcons.venus
                    : FontAwesomeIcons.mars,
                label: _isFemale ? 'أنثى' : 'ذكر',
                color: LbeenaColors.orange,
              ),
              if ((widget.data.cityName ?? '').isNotEmpty)
                _chip(
                  icon: FontAwesomeIcons.locationDot,
                  label: widget.data.cityName!,
                  color: LbeenaColors.teal,
                ),
              if (widget.data.hasMoreThan3000.toString() == '1')
                _chip(
                  icon: FontAwesomeIcons.fire,
                  label: '3K+',
                  color: LbeenaColors.orange,
                  filled: true,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                _stat(
                  widget.data.followersCount ?? '0',
                  'متابع',
                  onTap: () {
                    navigatorToPush(
                      context: context,
                      pageName: FollowingUsersPage(
                        titleAppBar: 'متابع',
                        isFollowers: true,
                        userId: widget.data.userId!,
                      ),
                    );
                  },
                ),
                _stat(
                  widget.data.followingCount ?? '0',
                  'يتابع',
                  onTap: () {
                    navigatorToPush(
                      context: context,
                      pageName: FollowingUsersPage(
                        titleAppBar: 'يتابع',
                        isFollowers: false,
                        userId: widget.data.userId!,
                      ),
                    );
                  },
                ),
                _stat(widget.data.adsCount ?? '0', 'إعلانات', onTap: () {}),
                _stat(widget.data.postsCount ?? '0', 'منشورات', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (widget.data.membershipNumber != null)
            Text(
              'رقم العضوية: ${widget.data.membershipNumber}',
              style: TextStyle(
                color: LbeenaColors.teal,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          if (widget.data.createdAt != null) ...[
            const SizedBox(height: 2),
            Text(
              'تاريخ العضوية: ${formatDateWithArabicMonth(widget.data.createdAt!)}',
              style: TextStyle(
                color: muted,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
          if ((widget.data.note ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              widget.data.note!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
          if (widget.data.links.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.data.links.map(_linkButton).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatar(double completion) {
    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 62,
            height: 62,
            child: CircularProgressIndicator(
              value: completion / 100,
              strokeWidth: 3,
              backgroundColor: _isDark
                  ? LbeenaColors.surfaceDark
                  : LbeenaColors.iconTile,
              valueColor: AlwaysStoppedAnimation<Color>(
                completion >= 90 ? LbeenaColors.teal : LbeenaColors.orange,
              ),
            ),
          ),
          CustomImageView(
            imagePath: _photo,
            width: 50,
            height: 50,
            alignment: Alignment.center,
            radius: BorderRadius.circular(25),
            fit: BoxFit.cover,
            placeHolder: ImageConstant.imgPerson,
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: LbeenaColors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${completion.round()}%',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: LbeenaColors.white,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required FaIconData icon,
    required String label,
    required Color color,
    bool filled = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: filled
            ? color
            : color.withValues(alpha: _isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 11, color: filled ? LbeenaColors.white : color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: filled ? LbeenaColors.white : color,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, {required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: _isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: _isDark ? LbeenaColors.fieldHint : LbeenaColors.muted,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkButton(String link) {
    return InkWell(
      onTap: () {
        if (link.contains('http')) {
          launchURL(link);
        } else {
          launchURL('https://$link');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: FaIcon(
            getIcon(link),
            size: 15,
            color: LbeenaColors.teal,
          ),
        ),
      ),
    );
  }

  double _calculateProfileCompletion() {
    double completion = 0;

    if (widget.data.profilePic != null && widget.data.profilePic!.isNotEmpty) {
      completion += 40;
    }

    int linkCount = widget.data.links.length;
    double linksPercentage = (linkCount / 4) * 60;
    completion += linksPercentage.clamp(0, 60);

    return completion.clamp(0, 100);
  }

  Future<void> shareCompany({
    required String nameCompany,
    required String idCompany,
    required String imageUrl,
    required String accountType,
  }) async {
    try {
      setState(() {
        isLoadingShareAds = true;
      });
      String nameAdsUrl = accountType == 'individual'
          ? 'اسم المستخدم: $nameCompany\n'
          : 'اسم الشركة: $nameCompany\n';
      String urlShare = accountType == 'individual'
          ? '${AppEndpoints.deepLinksUrl}/user/$idCompany'
          : '${AppEndpoints.deepLinksUrl}/company/$idCompany';
      String url = imageUrl;
      if (imageUrl != 'null') {
        String filename = basename(url);
        Dio dio = Dio();
        Response response = await dio.get(url,
            options: Options(responseType: ResponseType.bytes));
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/$filename.jpg');
        file.createSync();
        file.writeAsBytesSync(response.data);
        print(file.existsSync());
        if (file.existsSync() == true) {
          await Share.shareXFiles([XFile(file.path)],
              text: nameAdsUrl + urlShare);
        }
      } else {
        await Share.share(nameAdsUrl + urlShare);
      }

      setState(() {
        isLoadingShareAds = false;
      });
    } catch (e) {
      setState(() {
        isLoadingShareAds = false;
      });
      print("Error in Share Ads : $e");
    }
  }
}
