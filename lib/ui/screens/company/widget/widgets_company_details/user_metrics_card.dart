import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/utils/lbeena_menu.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';

import '../../../../../core/di/di_manager.dart';
import '../../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../../core/utils/endpoints.dart';
import '../../../../../data/models/profile_company/profile_company_model.dart';
import '../../../../../widgets/user_image_profile.dart';
import '../../../profile/cubit/cubit.dart';

class UserMetricsCard extends StatefulWidget {
  UserMetricsCard({
    super.key,
    required this.companyInformation,
    required this.imageCompany,
    required this.isOwnerAccount,
    required this.followersCount,
    required this.followingCount,
    required this.adsCount,
    required this.postCount,
    required this.idCompany,
    required this.links,
    required this.ugcList,
  });

  List<DataCompany> companyInformation;
  List<Ugc> ugcList = [];
  List links;
  String? imageCompany;
  bool isOwnerAccount;
  int followersCount;
  int followingCount;
  int postCount;
  int adsCount;
  int idCompany;

  @override
  State<UserMetricsCard> createState() => _UserMetricsCardState();
}

class _UserMetricsCardState extends State<UserMetricsCard> {
  bool isLoadingShareAds = false;

  bool get _isDark => DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  bool get _hideCompletionRing {
    if (widget.isOwnerAccount) {
      return widget.ugcList.isEmpty &&
          DIManager.findDep<SharedPrefs>().getAccountType() == 'individual';
    }
    return widget.ugcList.isEmpty &&
        widget.companyInformation[0].account_type == 'individual';
  }

  double _calculateProfileCompletion() {
    double completion = 0;

    if (widget.imageCompany.toString() != "null") {
      completion += 40;
    }

    if (widget.isOwnerAccount) {
      if (DIManager.findDep<SharedPrefs>().getAccountType() == 'individual') {
        int linkCount =
            widget.ugcList.isEmpty ? 0 : widget.ugcList[0].links?.length ?? 0;
        completion += ((linkCount / 4) * 60).clamp(0, 60);
      } else {
        completion += ((widget.links.length / 5) * 60).clamp(0, 60);
      }
    } else {
      if (widget.companyInformation[0].account_type == 'individual') {
        int linkCount =
            widget.ugcList.isEmpty ? 0 : widget.ugcList[0].links?.length ?? 0;
        completion += ((linkCount / 4) * 60).clamp(0, 60);
      } else {
        completion += ((widget.links.length / 5) * 60).clamp(0, 60);
      }
    }

    return completion.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final completion = _calculateProfileCompletion();
    final name = widget.companyInformation.isEmpty
        ? ''
        : widget.companyInformation[0].companyName.toString();
    final rating =
        double.tryParse(widget.companyInformation[0].rating ?? '0') ?? 0;
    final titleColor = _isDark ? LbeenaColors.white : LbeenaColors.tealDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatar(completion),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                widget.isOwnerAccount
                    ? _stars(rating)
                    : Row(
                        children: [
                          BlocConsumer<ProfileCubit, ProfileStates>(
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  showRatingAds(
                                    context,
                                    widget.idCompany,
                                    rating,
                                  );
                                },
                                child: state is LoadingEvaluateCompanyState
                                    ? loaderNormal(
                                        size: 14,
                                        color: LbeenaColors.orange,
                                      )
                                    : Text(
                                        'قيّم الآن',
                                        style: TextStyle(
                                          color: LbeenaColors.orange,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                        ),
                                      ),
                              );
                            },
                            listener: (context, state) {
                              if (state is SuccessEvaluateCompanyState) {
                                SnackBarHelper.mySnackBarSuccess(
                                  'تم تقييم الشركة بنجاح',
                                  context,
                                );
                              } else if (state is ErrorEvaluateCompanyState) {
                                SnackBarHelper.mySnackBarError(
                                  state.error,
                                  context,
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          _stars(rating),
                        ],
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
              if (value == 'share') {
                shareCompany(
                  idCompany: widget.idCompany.toString(),
                  accountType:
                      widget.companyInformation[0].account_type.toString(),
                  imageUrl: widget.imageCompany.toString() != 'null'
                      ? (widget.imageCompany.toString().contains('http')
                          ? widget.imageCompany.toString()
                          : AppEndpoints.baseUrlWithoutApi +
                              widget.imageCompany.toString())
                      : 'null',
                  nameCompany: name,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.shareNodes,
                      size: 15,
                      color: LbeenaColors.orange,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'مشاركة',
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
              padding: const EdgeInsets.all(6),
              child: isLoadingShareAds
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: LbeenaColors.orange,
                      ),
                    )
                  : FaIcon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 16,
                      color: LbeenaColors.muted,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(left: 2),
          child: FaIcon(
            index < rating.round()
                ? FontAwesomeIcons.solidStar
                : FontAwesomeIcons.star,
            size: 12,
            color: LbeenaColors.star,
          ),
        );
      }),
    );
  }

  Widget _avatar(double completion) {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_hideCompletionRing)
            SizedBox(
              width: 78,
              height: 78,
              child: CircularProgressIndicator(
                value: completion / 100,
                strokeWidth: 3,
                backgroundColor:
                    _isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
                valueColor: AlwaysStoppedAnimation<Color>(
                  completion >= 90 ? LbeenaColors.teal : LbeenaColors.orange,
                ),
              ),
            ),
          UserImageProfile(
            imageUrl: widget.imageCompany.toString(),
            height: 64,
            width: 64,
          ),
          if (!_hideCompletionRing)
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
          if (widget.isOwnerAccount)
            Positioned(
              right: 0,
              top: 0,
              child: Material(
                color: LbeenaColors.orange,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => ProfileCubit.get(context).loadImages(),
                  child: const SizedBox(
                    width: 26,
                    height: 26,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.camera,
                        size: 11,
                        color: LbeenaColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showRatingAds(BuildContext context, companyId, double? ratingOld) {
    ProfileCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = ratingOld ?? 0.0;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: LbeenaColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'قيّم الشركة',
                style: TextStyle(
                  color: LbeenaColors.tealDark,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              content: RatingBar(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                onRatingUpdate: (value) {
                  rating = value;
                },
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star, color: LbeenaColors.star, size: 28),
                  half: Icon(Icons.star_half, color: LbeenaColors.star, size: 28),
                  empty: Icon(
                    Icons.star_border,
                    color: LbeenaColors.star,
                    size: 28,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(
                      color: LbeenaColors.muted,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    cubit.evaluateCompany(
                      companyId: int.parse(companyId.toString()),
                      value: rating,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LbeenaColors.orange,
                    foregroundColor: LbeenaColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
      print(imageUrl);
      if (imageUrl != 'null') {
        String filename = basename(url);
        Dio dio = Dio();
        Response response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/$filename.jpg');
        file.createSync();
        file.writeAsBytesSync(response.data);
        print(file.existsSync());
        if (file.existsSync() == true) {
          await Share.shareXFiles(
            [XFile(file.path)],
            text: nameAdsUrl + urlShare,
          );
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
