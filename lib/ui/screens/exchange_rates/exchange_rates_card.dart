import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'  as intl;
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/lbeena_menu.dart';
import '../../../data/models/sp_today/sp_today_snapshot_model.dart';
import '../../../widgets/BoothShimmer.dart';
import '../../theme/lbeena_colors.dart';
import 'cubit/exchange_rates_cubit.dart';
import 'cubit/exchange_rates_state.dart';

class ExchangeRatesCardWidget extends StatelessWidget {
  const ExchangeRatesCardWidget({super.key});

  static final _number = intl.NumberFormat('#,###', 'en');

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
        builder: (context, state) {
          if (state is LoadingExchangeRatesState &&
              ExchangeRatesCubit.get(context).snapshot == null) {
            return const SizedBox(height: 168, child: BoothShimmer());
          }
          if (state is! SuccessExchangeRatesState) {
            return const SizedBox.shrink();
          }

          final cubit = ExchangeRatesCubit.get(context);
          final snapshot = state.snapshot;
          final market = cubit.market;
          final extra = cubit.extraCurrency;

          return Container(
            decoration: LbeenaColors.cardWith(
              color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
            ),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'أسعار السوق · سوريا',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? LbeenaColors.white
                              : LbeenaColors.tealDark,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _chipPicker<String>(
                      context: context,
                      isDark: isDark,
                      icon: FontAwesomeIcons.locationDot,
                      label: ExchangeRatesCubit.markets[market] ?? 'دمشق',
                      items: ExchangeRatesCubit.markets.entries
                          .map(
                            (e) => (value: e.key, label: e.value),
                          )
                          .toList(),
                      selected: market,
                      onSelected: cubit.setMarket,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'مقابل الليرة السورية · شراء / بيع',
                  style: TextStyle(
                    color: LbeenaColors.orange,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                _rateRow(
                  isDark: isDark,
                  code: 'USD',
                  title: 'دولار',
                  quote: snapshot.currency('USD', market),
                ),
                const SizedBox(height: 6),
                _rateRow(
                  isDark: isDark,
                  code: 'EUR',
                  title: 'يورو',
                  quote: snapshot.currency('EUR', market),
                ),
                const SizedBox(height: 6),
                _rateRow(
                  isDark: isDark,
                  code: extra,
                  title: ExchangeRatesCubit.currencyNames[extra] ?? extra,
                  quote: snapshot.currency(extra, market),
                  leading: _chipPicker<String>(
                    context: context,
                    isDark: isDark,
                    icon: FontAwesomeIcons.coins,
                    label: extra,
                    flagCode: extra,
                    items: cubit.pickerCurrencies
                        .map(
                          (code) => (
                            value: code,
                            label:
                                '${ExchangeRatesCubit.currencyNames[code]} · $code',
                          ),
                        )
                        .toList(),
                    selected: extra,
                    onSelected: cubit.setExtraCurrency,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'الذهب',
                  style: TextStyle(
                    color: isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Cairo',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _goldTile(isDark, '24', snapshot.goldKarat('24k', market)),
                    const SizedBox(width: 6),
                    _goldTile(isDark, '21', snapshot.goldKarat('21k', market)),
                    const SizedBox(width: 6),
                    _goldTile(isDark, '18', snapshot.goldKarat('18k', market)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _rateRow({
    required bool isDark,
    required String code,
    required String title,
    required SpTodayQuote? quote,
    Widget? leading,
  }) {
    final buy = quote == null ? '--' : _number.format(quote.buy);
    final sell = quote == null ? '--' : _number.format(quote.sell);
    final change = quote?.change ?? 0;
    final up = change > 0;
    final down = change < 0;
    final changeColor = up
        ? const Color(0xFF16A34A)
        : down
            ? const Color(0xFFDC2626)
            : LbeenaColors.muted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (leading == null) ...[
            _flag(code),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                fontWeight: FontWeight.w800,
                fontFamily: 'Cairo',
                fontSize: 12,
              ),
            ),
          ] else
            leading,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$buy / $sell',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                fontWeight: FontWeight.w800,
                fontFamily: 'Cairo',
                fontSize: 12,
              ),
            ),
          ),
          Text(
            '${up ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: changeColor,
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _flag(String code) {
    final iso = ExchangeRatesCubit.currencyFlags[code];
    if (iso == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Image.asset(
        'flags/$iso.png',
        package: 'country_code_picker',
        width: 22,
        height: 15,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox(width: 22, height: 15),
      ),
    );
  }

  Widget _goldTile(bool isDark, String karat, SpTodayQuote? quote) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'عيار $karat',
              style: TextStyle(
                color: LbeenaColors.orange,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              quote == null ? '--' : _number.format(quote.buy),
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipPicker<T>({
    required BuildContext context,
    required bool isDark,
    required FaIconData icon,
    required String label,
    String? flagCode,
    required List<({T value, String label})> items,
    required T selected,
    required ValueChanged<T> onSelected,
  }) {
    return PopupMenuButton<T>(
      color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      constraints: LbeenaMenu.constraints,
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          final isSelected = item.value == selected;
          return PopupMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.value is String &&
                    ExchangeRatesCubit.currencyFlags
                        .containsKey(item.value as String)) ...[
                  _flag(item.value as String),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected
                          ? LbeenaColors.orange
                          : LbeenaColors.tealDark,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: LbeenaColors.teal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (flagCode != null) ...[
              _flag(flagCode),
              const SizedBox(width: 4),
            ] else
              FaIcon(icon, size: 10, color: LbeenaColors.teal),
            if (flagCode == null) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: LbeenaColors.teal,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                fontSize: 11,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: LbeenaColors.teal,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
