import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/core/link_app.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/cart/widget/item_cart.dart';
import 'package:syrians_in_uae/ui/screens/cart/widget/shimmer_item_cart.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/sources/cart/cart_data_source.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../auth/login/model_home_page.dart';
import '../auth/widget/lbeena_auth_scaffold.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key, this.isShowBack});

  bool? isShowBack;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoadingDate = false;
  bool isLoadingCreateOrder = false;

  int activeStep = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController(
    text: DIManager.findDep<SharedPrefs>().getAccountType() == 'company'
        ? DIManager.findDep<SharedPrefs>().getUserNameCompany()
        : DIManager.findDep<SharedPrefs>().getUserName(),
  );
  TextEditingController locationController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController numberCardController = TextEditingController();
  TextEditingController expiredCardController = TextEditingController();
  TextEditingController cvvCardController = TextEditingController();

  TextEditingController mobileNumberController = TextEditingController(
    text: DIManager.findDep<SharedPrefs>().getMobileNumber() ?? '',
  );

  @override
  void initState() {
    loadData();
    if (CartCubit.get(context).dataCart == null &&
        DIManager.findDep<SharedPrefs>().getToken() != null) {
      isLoadingDate = true;
      CartCubit.get(context).getMyCart();
    }
    super.initState();
  }

  HomePageLoginModel? homePageData;
  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
      print(
          "homePageData : ${homePageData!.homePageModel!.data!.adsBanner.length}");
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }

  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode expiredCardFocusNode = FocusNode();
  final FocusNode numberFocusNode = FocusNode();
  final FocusNode cvvFocusNode = FocusNode();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String? token = DIManager.findDep<SharedPrefs>().getToken();

  bool get _isDark => DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  Color get _titleColor =>
      _isDark ? LbeenaColors.white : LbeenaColors.tealDark;

  Color get _muted => _isDark ? LbeenaColors.fieldHint : LbeenaColors.muted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            _isDark ? LbeenaColors.surfaceDark : LbeenaColors.lightBg,
        appBar: appBarNormalWithIcon(
            context: context,
            text: 'سلة المشتريات',
            isShowBack: widget.isShowBack ?? false),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is LoadingMyCartState) {
              isLoadingDate = true;
            }
            if (state is SuccessMyCartState) {
              isLoadingDate = false;
            }
            if (state is ErrorMyCartState) {
              isLoadingDate = false;
            }
            if (state is LoadingCreateOrderState) {
              isLoadingCreateOrder = true;
            }
            if (state is SuccessCreateOrderState) {
              isLoadingCreateOrder = false;
              SnackBarHelper.mySnackBarSuccess(state.data.message, context);
              navigatorToPushReplacementUntil(
                  context: context,
                  location: '/homePage',
                  extra: homePageData);
            }
            if (state is ErrorCreateOrderState) {
              isLoadingCreateOrder = false;
              SnackBarHelper.mySnackBarError(state.message, context);
            }
          },
          builder: (context, state) {
            if (token == null) {
              return SingleChildScrollView(
                child: buildGoToLogin(context),
              );
            }

            return SmartRefreshWidget(
              onRefresh: () async {
                await CartCubit.get(context).getMyCart();
                _refreshController.refreshCompleted();
              },
              enablePullUp: false,
              controller: _refreshController,
              onLoading: () {},
              child: SingleChildScrollView(
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (CartCubit.get(context).dataCart == null) ...{
                          _emptyCart(),
                        } else ...{
                          sizeHeightNormal(),
                          if (CartCubit.get(context)
                                  .dataCart
                                  ?.items
                                  .length !=
                              0)
                            _checkoutStepper(),
                          SizedBox(height: 14.h),
                          if (activeStep == 0) ...{
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Column(
                                children: [
                                  if (isLoadingDate) ...{
                                    ShimmerItemCart(),
                                  } else ...{
                                    if (CartCubit.get(context)
                                            .dataCart
                                            ?.items
                                            .length ==
                                        0) ...{
                                      _emptyCart(),
                                    },
                                    if (CartCubit.get(context)
                                            .dataCart
                                            ?.items
                                            .isNotEmpty ==
                                        true)
                                      ...List.generate(
                                        CartCubit.get(context)
                                            .dataCart!
                                            .items
                                            .length,
                                        (index) => ItemCart(index: index),
                                      ),
                                  },
                                  if (!isLoadingDate &&
                                      CartCubit.get(context)
                                          .dataCart!
                                          .items
                                          .isNotEmpty) ...{
                                    _summaryCard(),
                                    SizedBox(height: 12.h),
                                    CustomElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          activeStep += 1;
                                        });
                                      },
                                      text:
                                          'التالي  •  ${CartCubit.get(context).dataCart!.totalPrice} د.إ',
                                    ),
                                    SizedBox(height: 24.h),
                                  },
                                ],
                              ),
                            ),
                          },
                          if (activeStep == 1) ...{
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionCard(
                                      title: 'معلومات التوصيل',
                                      subtitle:
                                          'أكد اسمك وعنوان الاستلام قبل المتابعة',
                                      icon: FontAwesomeIcons.locationDot,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _fieldLabel('الاسم'),
                                          CustomTextFormField(
                                            controller: firstNameController,
                                            focusNode: _secondFocusNode,
                                            fillColor: _isDark
                                                ? LbeenaColors.surfaceDark
                                                : LbeenaColors.fieldFill,
                                            prefix: const LbeenaAuthFieldIcon(
                                                icon: FontAwesomeIcons.user),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return AppLocalizations.of(
                                                        context)!
                                                    .field_is_empty;
                                              }
                                              return null;
                                            },
                                            hintText: 'أضف الاسم هنا ..',
                                          ),
                                          SizedBox(height: 14.h),
                                          _fieldLabel('رقم الجوال'),
                                          CustomTextFormField(
                                            controller: mobileNumberController,
                                            readOnly: true,
                                            fillColor: _isDark
                                                ? LbeenaColors.surfaceDark
                                                : LbeenaColors.fieldFill,
                                            prefix: const LbeenaAuthFieldIcon(
                                                icon: FontAwesomeIcons.phone),
                                          ),
                                          SizedBox(height: 14.h),
                                          _fieldLabel('تفاصيل العنوان'),
                                          CustomTextFormField(
                                            controller: locationController,
                                            focusNode: _firstFocusNode,
                                            fillColor: _isDark
                                                ? LbeenaColors.surfaceDark
                                                : LbeenaColors.fieldFill,
                                            prefix: const LbeenaAuthFieldIcon(
                                                icon: FontAwesomeIcons
                                                    .locationDot),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return AppLocalizations.of(
                                                        context)!
                                                    .field_is_empty;
                                              }
                                              return null;
                                            },
                                            hintText: 'تفاصيل العنوان ..',
                                            maxLines: 3,
                                          ),
                                          SizedBox(height: 14.h),
                                          _fieldLabel('ملاحظة (اختياري)'),
                                          CustomTextFormField(
                                            focusNode: _noteFocusNode,
                                            controller: noteController,
                                            fillColor: _isDark
                                                ? LbeenaColors.surfaceDark
                                                : LbeenaColors.fieldFill,
                                            hintText: 'ملاحظة ..',
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    CustomElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            activeStep += 1;
                                          });
                                        }
                                      },
                                      text: 'تأكيد ومتابعة للدفع',
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            )
                          },
                          if (activeStep == 2) ...{
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionCard(
                                      title: 'طريقة الدفع',
                                      subtitle: 'اختر كيف تريد إتمام الطلب',
                                      icon: FontAwesomeIcons.creditCard,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: LbeenaColors.orange
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: LbeenaColors.orange
                                                .withValues(alpha: 0.35),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                color: LbeenaColors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 11,
                                                  color: LbeenaColors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'الدفع عند الاستلام',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 14,
                                                      color: _titleColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'ادفع نقداً عند استلام طلبك',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 11,
                                                      color: _muted,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.moneyBillWave,
                                              size: 18,
                                              color: LbeenaColors.orange,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    _sectionCard(
                                      title: 'ملخص الحجز',
                                      subtitle: 'راجع بياناتك قبل تأكيد الطلب',
                                      icon: FontAwesomeIcons.clipboardList,
                                      child: Column(
                                        children: [
                                          _reviewRow('الاسم',
                                              firstNameController.text),
                                          _reviewRow('الجوال',
                                              mobileNumberController.text),
                                          _reviewRow('العنوان',
                                              locationController.text),
                                          if (noteController.text.isNotEmpty)
                                            _reviewRow('ملاحظة',
                                                noteController.text),
                                          const Divider(height: 20),
                                          _reviewRow(
                                            'الإجمالي',
                                            '${CartCubit.get(context).dataCart!.totalPrice} د.إ',
                                            emphasize: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    CustomElevatedButton(
                                      isDisabled: isLoadingCreateOrder
                                          ? true
                                          : false,
                                      child: isLoadingCreateOrder
                                          ? loadingButton()
                                          : null,
                                      onPressed: () {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          CartCubit.get(context).createOrder(
                                              order: OrderParameterModel(
                                                  cart_id:
                                                      CartCubit.get(context)
                                                          .dataCart!
                                                          .cartId!,
                                                  name: firstNameController
                                                      .text,
                                                  phone:
                                                      mobileNumberController
                                                          .text,
                                                  location:
                                                      locationController.text,
                                                  note:
                                                      noteController.text));
                                        }
                                      },
                                      text:
                                          'تأكيد الطلب  •  ${CartCubit.get(context).dataCart!.totalPrice} د.إ',
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            )
                          },
                        },
                      ],
                    ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _checkoutStepper() {
    const labels = ['السلة', 'التوصيل', 'الدفع'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: List.generate(3, (index) {
          final isDone = index < activeStep;
          final isCurrent = index == activeStep;
          return Expanded(
            child: InkWell(
              onTap: () {
                if (index < activeStep) {
                  setState(() {
                    activeStep = index;
                  });
                } else if (index == 0 || index == 1) {
                  setState(() {
                    activeStep = index;
                  });
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == 0
                              ? Colors.transparent
                              : (isDone || isCurrent
                                  ? LbeenaColors.orange
                                  : LbeenaColors.fieldBorder),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isDone || isCurrent
                              ? LbeenaColors.orange
                              : (_isDark
                                  ? LbeenaColors.cardDark
                                  : LbeenaColors.white),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDone || isCurrent
                                ? LbeenaColors.orange
                                : LbeenaColors.fieldBorder,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isDone
                              ? const FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 11,
                                  color: LbeenaColors.white,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? LbeenaColors.white
                                        : _muted,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == 2
                              ? Colors.transparent
                              : (isDone
                                  ? LbeenaColors.orange
                                  : LbeenaColors.fieldBorder),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: isCurrent || isDone
                          ? LbeenaColors.orange
                          : _muted,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: LbeenaColors.cardWith(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إجمالي السلة',
                  style: TextStyle(
                    color: _muted,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${CartCubit.get(context).dataCart!.items.length} منتج',
                  style: TextStyle(
                    color: _titleColor,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${CartCubit.get(context).dataCart!.totalPrice} د.إ',
            style: TextStyle(
              color: LbeenaColors.orange,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required FaIconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: LbeenaColors.cardWith(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: LbeenaColors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    size: 14,
                    color: LbeenaColors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _titleColor,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _muted,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: _titleColor,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _reviewRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _muted,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: emphasize ? LbeenaColors.orange : _titleColor,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                fontSize: emphasize ? 15 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCart() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 24.w),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: LbeenaColors.orange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.bagShopping,
                  size: 28,
                  color: LbeenaColors.orange,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'سلتك فارغة',
              style: TextStyle(
                color: _titleColor,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'لا يوجد منتجات في سلة المشتريات بعد',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _muted,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
