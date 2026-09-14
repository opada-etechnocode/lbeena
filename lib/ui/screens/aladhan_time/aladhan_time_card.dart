import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../core/utils/lbeena_menu.dart';
import '../../../widgets/BoothShimmer.dart';
import '../../theme/lbeena_colors.dart';
import '../../theme/theme_helper.dart';
import 'analog_clock.dart';
import 'cubit/aladhan_time_cubit.dart';
import 'cubit/aladhan_time_state.dart';

class AladhanTimeCardWidget extends StatefulWidget {
  const AladhanTimeCardWidget({super.key});

  @override
  State<AladhanTimeCardWidget> createState() => _AladhanTimeCardWidgetState();
}

class _AladhanTimeCardWidgetState extends State<AladhanTimeCardWidget> {
  Timer? _timer;
  String? _nextPrayer;

  static const _order = [
    ('فجـر', 'صلاة الفجر', 'fajr'),
    ('شروق', 'صلاة الشروق', 'sunrise'),
    ('ظهر', 'صلاة الظهر', 'dhuhr'),
    ('عصر', 'صلاة العصر', 'asr'),
    ('مغرب', 'صلاة المغرب', 'maghrib'),
    ('عشاء', 'صلاة العشاء', 'isha'),
  ];

  @override
  void initState() {
    super.initState();
    if (AladhanTimeCubit.get(context).aladhanTimeModel == null) {
      AladhanTimeCubit.get(context).getPrayerTimes(
        DIManager.findDep<SharedPrefs>().getYourCountry() ??
            AladhanTimeCubit.defaultCity,
      );
    }
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _cleanTime(String? raw) {
    if (raw == null || raw.isEmpty) return '--:--';
    return raw.split(' ').first;
  }

  DateTime _parseTime(String time, DateTime date) {
    final parts = _cleanTime(time).split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String getNextPrayer(Map<String, String?> timings) {
    final now = DateTime.now();
    for (final item in _order) {
      final raw = timings[item.$3];
      if (raw == null) continue;
      if (_parseTime(raw, now).isAfter(now)) return item.$2;
    }
    return 'صلاة الفجر';
  }

  String _remainingLabel(Map<String, String?> timings) {
    final now = DateTime.now();
    DateTime? next;
    for (final item in _order) {
      final raw = timings[item.$3];
      if (raw == null) continue;
      final t = _parseTime(raw, now);
      if (t.isAfter(now)) {
        next = t;
        break;
      }
    }
    next ??=
        _parseTime(timings['fajr'] ?? '00:00', now).add(const Duration(days: 1));
    final diff = next.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    if (h > 0) return 'بعد $h س و $m د';
    return 'بعد $m د';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: BlocBuilder<AladhanTimeCubit, AladhanTimeState>(
        builder: (context, state) {
          if (state is LoadingAladhanTimeState) {
            return const SizedBox(height: 148, child: BoothShimmer());
          }
          if (state is! SuccessAladhanTimeState) {
            return const SizedBox.shrink();
          }

          final model =
              AladhanTimeCubit.get(context).aladhanTimeModel!.data!.timings!;
          final timings = {
            'fajr': model.fajr,
            'sunrise': model.sunrise,
            'dhuhr': model.dhuhr,
            'asr': model.asr,
            'maghrib': model.maghrib,
            'isha': model.isha,
          };
          _nextPrayer = getNextPrayer(timings);
          final city = DIManager.findDep<SharedPrefs>().getYourCountry() ??
              AladhanTimeCubit.defaultCity;

          return Container(
            decoration: LbeenaColors.cardWith(
              color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ImageConstant.mmImage,
                        width: 78,
                        height: 50,
                        fit: BoxFit.contain,
                      ),

                      const AnalogClockWidget(size: 88),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'أوقات الصلاة · سوريا',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark
                                    ? LbeenaColors.white
                                    : LbeenaColors.tealDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _cityPicker(context, city, isDark),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_nextPrayer · ${_remainingLabel(timings)}',
                        style: TextStyle(
                          color: LbeenaColors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _prayerGrid(timings, isDark),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _prayerGrid(Map<String, String?> timings, bool isDark) {
    return Column(
      children: [
        Row(
          children: _order
              .take(3)
              .map((item) => _prayerTile(item, timings, isDark))
              .toList(),
        ),
        const SizedBox(height: 6),
        Row(
          children: _order
              .skip(3)
              .map((item) => _prayerTile(item, timings, isDark))
              .toList(),
        ),
      ],
    );
  }

  Widget _prayerTile(
    (String, String, String) item,
    Map<String, String?> timings,
    bool isDark,
  ) {
    final isNext = _nextPrayer == item.$2;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isNext
              ? LbeenaColors.orange
              : (isDark ? LbeenaColors.surfaceDark : LbeenaColors.iconTile),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.$1,
              style: TextStyle(
                color: isNext ? LbeenaColors.white : LbeenaColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _cleanTime(timings[item.$3]),
              style: TextStyle(
                color: isNext
                    ? LbeenaColors.white
                    : (isDark ? LbeenaColors.white : LbeenaColors.tealDark),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cityPicker(BuildContext context, String city, bool isDark) {
    return PopupMenuButton<String>(
      color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      constraints: LbeenaMenu.constraints,
      padding: EdgeInsets.zero,
      onSelected: (value) {
        AladhanTimeCubit.get(context).getPrayerTimes(value);
      },
      itemBuilder: (context) {
        return AladhanTimeCubit.get(context)
            .prayerCitiesCoordinates
            .keys
            .map((cityName) {
          return PopupMenuItem<String>(
            value: cityName,
            child: Text(
              cityName,
              style: TextStyle(
                color: cityName == city
                    ? LbeenaColors.orange
                    : appTheme.black900,
                fontWeight:
                    cityName == city ? FontWeight.w800 : FontWeight.w600,
              ),
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
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 10,
              color: LbeenaColors.teal,
            ),
            const SizedBox(width: 4),
            Text(
              city,
              style: TextStyle(
                color: LbeenaColors.teal,
                fontWeight: FontWeight.w700,
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
