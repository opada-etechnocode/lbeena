import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/ui/app_general_bloc/app_general_state.dart';
import 'package:syrians_in_uae/ui/screens/favorite/favorite_screen.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/endpoints.dart';
import '../../../core/utils/image_constant.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/loader_for_page.dart';
import '../../../widgets/lbeena_bottom_nav.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/app_general_cubit.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/cubit/them_app_cubit.dart';
import '../../theme/lbeena_colors.dart';
import '../../widget/url_webview.dart';
import '../auth/login/login_screen.dart';
import '../cart/order_page.dart';
import '../home/cubit/cubit.dart';
import 'customer_serves_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (HomeCubit.get(context).dataSectionList.isEmpty) {
      HomeCubit.get(context).getSectionSetting();
    }
    HomeCubit.get(context).getPolicyTermsAppLinks();
    super.initState();
  }

  bool get _isLoggedIn =>
      DIManager.findDep<SharedPrefs>().getToken() != null;

  bool get _isDark =>
      DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        backgroundColor: _isDark ? LbeenaColors.black : LbeenaColors.lightBg,
        appBar: appBarNormalWithIcon(
            text: AppLocalizations.of(context)!.settings, context: context),
        body: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
            if (state is SuccessLogoutState) {
              DIManager.findDep<SharedPrefs>().setSubscribeToNotification(true);
              AppGeneralCubit.get(context).notificationEnable = true;
            }

            if (state is SuccessPolicyTermsAppLinksState) {
              DIManager.findDep<SharedPrefs>().setLinks(
                appLink2: state.appTermsPolicyLinksModel
                        .dataAppTermsPolicyLinks?.app ??
                    "${AppEndpoints.baseUrlWithoutApi}/app.html",
                policyLink2: state.appTermsPolicyLinksModel
                        .dataAppTermsPolicyLinks?.policy ??
                    "${AppEndpoints.baseUrlWithoutApi}/policy.html",
                termsLink2: state.appTermsPolicyLinksModel
                        .dataAppTermsPolicyLinks?.terms ??
                    "${AppEndpoints.baseUrlWithoutApi}/terms.html",
                faqLink2: state.appTermsPolicyLinksModel
                        .dataAppTermsPolicyLinks?.faq ??
                    "${AppEndpoints.baseUrlWithoutApi}/faqCond.html",
                safetyLink2: state.appTermsPolicyLinksModel
                        .dataAppTermsPolicyLinks?.safety ??
                    "${AppEndpoints.baseUrlWithoutApi}/safety.html",
              );
            }
          },
          builder: (context, state) {
            return SmartRefreshWidget(
              onRefresh: () async {
                HomeCubit.get(context).getSectionSetting();
                _refreshController.refreshCompleted();
              },
              controller: _refreshController,
              enablePullUp: false,
              onLoading: () {},
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
                child: Column(
                  children: [
                    _isLoggedIn ? _accountCard() : _guestCard(),
                    const SizedBox(height: 18),
                    if (_isLoggedIn) ...[
                      _sectionTitle('حسابي', FontAwesomeIcons.user),
                      _groupCard(children: [
                        _tile(
                          icon: FontAwesomeIcons.heart,
                          label: 'المفضلة',
                          onTap: () => navigatorToPush(
                              context: context, pageName: FavoriteScreen()),
                        ),
                        _divider(),
                        _tile(
                          icon: FontAwesomeIcons.bagShopping,
                          label: 'طلباتي',
                          onTap: () => navigatorToPush(
                            context: context,
                            pageName: OrderPage(isMyOrderRequests: false),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                    ],
                    _sectionTitle('المساعدة', FontAwesomeIcons.headset),
                    _groupCard(children: [
                      _tile(
                        icon: FontAwesomeIcons.headset,
                        label: AppLocalizations.of(context)!.customer_support,
                        onTap: () => navigatorToPush(
                            context: context, pageName: CustomerServes()),
                      ),
                      if (HomeCubit.get(context).dataSectionList.isNotEmpty)
                        ...HomeCubit.get(context).dataSectionList.expand((item) {
                          return [
                            _divider(),
                            _tile(
                              icon: FontAwesomeIcons.link,
                              label: item.title ?? '',
                              onTap: () => navigatorToPush(
                                context: context,
                                pageName: UrlWebViewPage(
                                  urlPage: item.link ?? '',
                                  titleAppBer: item.title ?? '',
                                ),
                              ),
                            ),
                          ];
                        }),
                    ]),
                    const SizedBox(height: 16),
                    _sectionTitle('التطبيق', FontAwesomeIcons.mobileScreen),
                    _groupCard(children: [
                      _tile(
                        icon: FontAwesomeIcons.circleInfo,
                        label: AppLocalizations.of(context)!.about_app,
                        onTap: () => navigatorToPush(
                          context: context,
                          pageName: UrlWebViewPage(
                            urlPage:
                                DIManager.findDep<SharedPrefs>().getAppLink(),
                            titleAppBer:
                                AppLocalizations.of(context)!.about_app,
                          ),
                        ),
                      ),
                      _divider(),
                      _tile(
                        icon: FontAwesomeIcons.fileLines,
                        label: AppLocalizations.of(context)!.terms,
                        onTap: () => navigatorToPush(
                          context: context,
                          pageName: UrlWebViewPage(
                            urlPage:
                                DIManager.findDep<SharedPrefs>().getTermsLink(),
                            titleAppBer: AppLocalizations.of(context)!.terms,
                          ),
                        ),
                      ),
                      _divider(),
                      _tile(
                        icon: FontAwesomeIcons.shieldHalved,
                        label: AppLocalizations.of(context)!.privacy,
                        onTap: () => navigatorToPush(
                          context: context,
                          pageName: UrlWebViewPage(
                            urlPage: DIManager.findDep<SharedPrefs>()
                                .getPolicyLink(),
                            titleAppBer:
                                AppLocalizations.of(context)!.privacy,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _sectionTitle('التفضيلات', FontAwesomeIcons.sliders),
                    _groupCard(children: [
                      if (_isLoggedIn) ...[
                        _notificationTile(),
                        _divider(),
                      ],
                      _themeTile(),
                    ]),
                    const SizedBox(height: 16),
                    if (_isLoggedIn) ...[
                      _sectionTitle('الحساب', FontAwesomeIcons.rightFromBracket),
                      _groupCard(children: [
                        _tile(
                          icon: FontAwesomeIcons.userXmark,
                          label: AppLocalizations.of(context)!.delete_account,
                          iconColor: const Color(0xFFE11D48),
                          onTap: () => showDeleteAccount(context),
                        ),
                        _divider(),
                        state is LoadingLogoutState
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: loaderNormal(color: LbeenaColors.orange),
                              )
                            : _tile(
                                icon: FontAwesomeIcons.rightFromBracket,
                                label: AppLocalizations.of(context)!.logout,
                                iconColor: LbeenaColors.orange,
                                onTap: () => showLogout(context),
                              ),
                      ]),
                    ] else
                      _groupCard(children: [
                        _tile(
                          icon: FontAwesomeIcons.rightToBracket,
                          label: AppLocalizations.of(context)!.login_in_app,
                          iconColor: LbeenaColors.orange,
                          onTap: () => navigatorToPush(
                            context: context,
                            pageName: LoginScreen(isNeedIconBac: true),
                          ),
                        ),
                      ]),
                    const SizedBox(height: 24),
                    versionAppWidget(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _accountCard() {
    final prefs = DIManager.findDep<SharedPrefs>();
    final isCompany = prefs.getAccountType() == 'company';
    final name = isCompany
        ? (prefs.getUserNameCompany() ?? prefs.getUserName() ?? '')
        : (prefs.getUserName() ?? '');
    final rawImage = prefs.getImageProfile()?.toString() ?? '';
    final image = rawImage.isEmpty || rawImage == 'null'
        ? ImageConstant.imgPerson
        : rawImage.contains('http')
            ? rawImage
            : '${AppEndpoints.baseUrlWithoutApi}$rawImage';
    final membership = prefs.getMembershipNumber()?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [LbeenaColors.tealDark, LbeenaColors.teal],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LbeenaColors.orange, width: 2),
            ),
            child: ClipOval(
              child: CustomImageView(
                imagePath: image,
                fit: BoxFit.cover,
                color: rawImage.isEmpty || rawImage == 'null'
                    ? LbeenaColors.white
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'حساب لبينا' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: LbeenaColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompany ? 'حساب شركة' : 'حساب فردي',
                  style: TextStyle(
                    color: LbeenaColors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                if (membership.isNotEmpty && membership != 'null') ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: LbeenaColors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'عضوية $membership',
                      style: const TextStyle(
                        color: LbeenaColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _guestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LbeenaColors.fieldBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: LbeenaColors.iconTile,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.user, color: LbeenaColors.teal, size: 20),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'سجّل دخولك لمتابعة حسابك',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: _isDark ? LbeenaColors.white : LbeenaColors.black,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                navigatorToPush(
                  context: context,
                  pageName: LoginScreen(isNeedIconBac: true),
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
              child: Text(
                AppLocalizations.of(context)!.login_in_app,
                style: const TextStyle(
                  color: LbeenaColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return LbeenaSectionHeader(
      title: title,
      icon: icon,
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
    );
  }

  Widget _groupCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LbeenaColors.fieldBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 58, color: LbeenaColors.fieldBorder);
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final accent = iconColor ?? LbeenaColors.teal;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(icon, size: 16, color: accent),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _isDark ? LbeenaColors.white : LbeenaColors.black,
                ),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronLeft,
              size: 12,
              color: LbeenaColors.muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationTile() {
    return BlocConsumer<AppGeneralCubit, AppGeneralState>(
      listener: (context, state) {},
      builder: (context, state) {
        final enabled = AppGeneralCubit.get(context).notificationEnable;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.bell, size: 16, color: LbeenaColors.teal),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  enabled ? 'إيقاف الإشعارات' : 'تفعيل الإشعارات',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _isDark ? LbeenaColors.white : LbeenaColors.black,
                  ),
                ),
              ),
              Switch.adaptive(
                value: enabled,
                onChanged: (_) => AppGeneralCubit.get(context).toggleNotifications(),
                activeThumbColor: LbeenaColors.white,
                activeTrackColor: LbeenaColors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _themeTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: FaIcon(
                _isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                size: 16,
                color: LbeenaColors.teal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isDark
                  ? AppLocalizations.of(context)!.dark_mode
                  : AppLocalizations.of(context)!.lite_mode,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _isDark ? LbeenaColors.white : LbeenaColors.black,
              ),
            ),
          ),
          Switch.adaptive(
            value: _isDark,
            onChanged: (_) {
              if (_isDark) {
                BlocProvider.of<ThemAppCubit>(context)
                    .changeTheme(ThemeState.light);
              } else {
                BlocProvider.of<ThemAppCubit>(context)
                    .changeTheme(ThemeState.dark);
              }
              setState(() {});
            },
            activeThumbColor: LbeenaColors.white,
            activeTrackColor: LbeenaColors.orange,
          ),
        ],
      ),
    );
  }
}

void showLogout(BuildContext context) {
  HomeCubit cubit = BlocProvider.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _ConfirmDialog(
        title: 'هل أنت متأكد من تسجيل الخروج ؟',
        confirmLabel: 'تأكيد',
        onConfirm: () {
          cubit.logout();
          Navigator.of(context).pop();
        },
      );
    },
  );
}

void showDeleteAccount(BuildContext context) {
  HomeCubit cubit = BlocProvider.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _ConfirmDialog(
        title: AppLocalizations.of(context)!.delete_sure_account,
        confirmLabel: AppLocalizations.of(context)!.sure,
        destructive: true,
        onConfirm: () {
          cubit.deleteAccount();
          Navigator.of(context).pop();
        },
      );
    },
  );
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.confirmLabel,
    required this.onConfirm,
    this.destructive = false,
  });

  final String title;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';
    return AlertDialog(
      backgroundColor: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: isDark ? LbeenaColors.white : LbeenaColors.black,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: LbeenaColors.teal,
                  side: const BorderSide(color: LbeenaColors.teal),
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(
                    color: LbeenaColors.teal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      destructive ? const Color(0xFFE11D48) : LbeenaColors.orange,
                  foregroundColor: LbeenaColors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  confirmLabel,
                  style: const TextStyle(
                    color: LbeenaColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
