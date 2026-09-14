import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../auth/login/login_screen.dart';
import '../../cart/cart_page.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../../company/company_details_page.dart';

class CardAdsStoreWidget extends StatefulWidget {
  CardAdsStoreWidget({
    Key? key,
    this.dataProductItem,
    this.isFromEvaluation = false,
    this.width,
  }) : super(key: key);

  dynamic dataProductItem;
  bool isFromEvaluation = false;
  double? width;

  @override
  State<CardAdsStoreWidget> createState() => _CardAdsStoreWidgetState();
}

class _CardAdsStoreWidgetState extends State<CardAdsStoreWidget> {
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();
  bool _isAddingToCart = false;

  bool get _isDark => DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  bool get _hasCompany =>
      widget.dataProductItem?.company != null &&
      widget.dataProductItem.company.isNotEmpty;

  bool get _hasPrice {
    final price = widget.dataProductItem.price.toString();
    return price != '0.0' &&
        price != '0' &&
        price != '0.00' &&
        price != 'null';
  }

  bool get _hasDiscount {
    final finalPrice =
        double.tryParse(widget.dataProductItem.finalPrice?.toString() ?? '');
    final price =
        double.tryParse(widget.dataProductItem.price?.toString() ?? '');
    if (finalPrice == null || price == null) return false;
    return finalPrice != price;
  }

  String get _imagePath {
    final images = widget.dataProductItem?.imageNames;
    if (images == null ||
        images.isEmpty ||
        images[0] == null ||
        images[0].toString().isEmpty) {
      return ImageConstant.imgPerson;
    }
    final raw = images[0].toString();
    if (raw.contains('http')) return raw;
    return AppEndpoints.baseUrlWithoutApi + raw;
  }

  String get _companyPhoto {
    if (!_hasCompany) return ImageConstant.imgPerson;
    final raw = widget.dataProductItem.company[0].profilePic.toString();
    if (raw.contains('http')) return raw;
    return AppEndpoints.baseUrlWithoutApi + raw;
  }

  String get _title {
    final name = widget.dataProductItem?.name?.toString() ?? '';
    if (name.isNotEmpty && name != 'null') return name;
    return widget.dataProductItem?.description?.toString() ?? '';
  }

  String get _companyName {
    if (!_hasCompany) return '';
    return widget.dataProductItem.company[0].companyName?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = _isDark ? LbeenaColors.white : LbeenaColors.tealDark;
    final muted = _isDark ? LbeenaColors.fieldHint : LbeenaColors.muted;

    return Container(
      width: widget.width,
      decoration: LbeenaColors.cardWith(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _productImage()),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
                if (_companyName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _companyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: muted,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ],
                const SizedBox(height: 3),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      size: 9,
                      color: muted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.dataProductItem!.acceptDate != null
                            ? formatDateTime(
                                widget.dataProductItem!.acceptDate ??
                                    DateTime.now(),
                              )
                            : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 7),
            child: BlocConsumer<CartCubit, CartState>(
              listener: (context, state) {
                if (state is SuccessAddToCartState &&
                    state.productId ==
                        widget.dataProductItem.adsId.toString()) {
                  setState(() {
                    _isAddingToCart = false;
                  });
                }
              },
              builder: (context, state) {
                if (_isAddingToCart) {
                  return _cartShell(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: LbeenaColors.white,
                      size: 16,
                    ),
                  );
                }

                final productId =
                    int.parse(widget.dataProductItem.adsId!.toString());
                final isProductInCart =
                    CartCubit.get(context).dataCart != null &&
                        CartCubit.get(context).dataCart!.items.any(
                              (item) => item.productId == productId,
                            );

                return itemButtonContainer(
                  onTap: () {
                    if (isProductInCart) {
                      navigatorToPush(
                        context: context,
                        pageName: CartPage(isShowBack: true),
                      );
                      return;
                    }
                    if (DIManager.findDep<SharedPrefs>().getToken() == null) {
                      navigatorToPush(
                        context: context,
                        pageName: LoginScreen(),
                      );
                    } else {
                      setState(() {
                        _isAddingToCart = true;
                      });
                      CartCubit.get(context).addToCart(
                        context,
                        productId: widget.dataProductItem.adsId!.toString(),
                        price: widget.dataProductItem.finalPrice ??
                            widget.dataProductItem.price.toString(),
                        isNeedGetMyCart: true,
                      );
                    }
                  },
                  adStatus: widget.dataProductItem.status,
                  text: isProductInCart ? 'الذهاب إلى السلة' : 'أضف إلى السلة',
                  changeBackGround: !isProductInCart,
                  width: double.infinity,
                  height: 30,
                  fontSize: 10,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _productImage() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: CustomImageView(
              imagePath: _imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
              placeHolder: ImageConstant.imgPerson,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  LbeenaColors.tealDark.withValues(alpha: 0),
                  LbeenaColors.tealDark.withValues(alpha: 0),
                  LbeenaColors.tealDark.withValues(alpha: 0.32),
                ],
                stops: const [0, 0.55, 1],
              ),
            ),
          ),
          if (widget.dataProductItem.isHave.toString() == '1')
            PositionedDirectional(
              top: 8,
              end: 8,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: LbeenaColors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidStar,
                    size: 11,
                    color: LbeenaColors.white,
                  ),
                ),
              ),
            ),
          if (_hasPrice)
            PositionedDirectional(
              top: 8,
              start: 8,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 124),
                child: _priceChip(),
              ),
            ),
          if (_hasCompany)
            PositionedDirectional(
              bottom: 8,
              end: 8,
              child: InkWell(
                onTap: () {
                  userId ==
                          widget.dataProductItem!.company[0].id.toString()
                      ? null
                      : navigatorToPush(
                          context: context,
                          pageName: CompanyDetailsPage(
                            idCompany:
                                widget.dataProductItem!.company[0].id,
                          ),
                        );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LbeenaColors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: LbeenaColors.teal.withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomImageView(
                      imagePath: _companyPhoto,
                      fit: BoxFit.cover,
                      placeHolder: ImageConstant.imgPerson,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _priceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: LbeenaColors.orange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LbeenaColors.orange.withValues(alpha: 0.28),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_hasDiscount)
              Text(
                '${_prettyPrice(widget.dataProductItem.price)} درهم',
                style: const TextStyle(
                  color: LbeenaColors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              )
            else ...[
              Text(
                _prettyPrice(widget.dataProductItem.price),
                style: TextStyle(
                  color: LbeenaColors.white.withValues(alpha: 0.85),
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: LbeenaColors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${_prettyPrice(widget.dataProductItem.finalPrice)} درهم',
                style: const TextStyle(
                  color: LbeenaColors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _prettyPrice(dynamic value) {
    final parsed = double.tryParse(value?.toString() ?? '');
    if (parsed == null) return value?.toString() ?? '';
    if (parsed == parsed.roundToDouble()) {
      return parsed.toInt().toString();
    }
    return parsed.toStringAsFixed(2);
  }

  Widget _cartShell({required Widget child}) {
    return Container(
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: LbeenaColors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  String getComparedTime(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    final List prefix = [
      'الآن',
      'ثواني',
      'دقائق',
      'ساعات',
      'أيام',
      'أشهر',
      'سنوات',
    ];
    if (difference.inDays == 0) {
      if (difference.inMinutes == 0) {
        if (difference.inSeconds < 20) {
          return (prefix[0]);
        } else {
          return ("${difference.inSeconds} ${prefix[1]}");
        }
      } else {
        if (difference.inMinutes > 59) {
          return ("${(difference.inMinutes / 60).floor()} ${prefix[3]}");
        } else {
          return ("${difference.inMinutes} ${prefix[2]}");
        }
      }
    } else {
      if (difference.inDays > 30) {
        if (((difference.inDays) / 30).floor() > 12) {
          return ("${((difference.inDays / 30) / 12).floor()} ${prefix[6]}");
        } else {
          return ("${(difference.inDays / 30).floor()} ${prefix[5]}");
        }
      } else {
        return ("${difference.inDays} ${prefix[4]}");
      }
    }
  }
}

String formatDateTime(DateTime dateTimeString) {
  String formattedDate =
      DateFormat('MMM dd, yyyy hh:mm a').format(dateTimeString);
  return formattedDate;
}
