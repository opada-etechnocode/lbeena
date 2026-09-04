import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../widgets/BoothShimmer.dart';
import '../../theme/lbeena_colors.dart';
import '../../theme/theme_helper.dart';
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
    next ??= _parseTime(timings['fajr'] ?? '00:00', now).add(const Duration(days: 1));
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
            return const SizedBox(height: 168, child: BoothShimmer());
          }
          if (state is! SuccessAladhanTimeState) {
            return const SizedBox.shrink();
          }

          final model = AladhanTimeCubit.get(context).aladhanTimeModel!.data!.timings!;
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: isDark
                    ? const [LbeenaColors.cardDark, Color(0xFF1A2E2C)]
                    : const [LbeenaColors.tealDark, LbeenaColors.teal],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: LbeenaColors.teal.withOpacity(0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: LbeenaColors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.mosque,
                            size: 16,
                            color: LbeenaColors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'أوقات الصلاة · سوريا',
                              style: TextStyle(
                                color: LbeenaColors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '$_nextPrayer · ${_remainingLabel(timings)}',
                              style: TextStyle(
                                color: LbeenaColors.orange.withOpacity(0.95),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        color: isDark ? LbeenaColors.cardDark : LbeenaColors.white,
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
                                  fontWeight: cityName == city
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: LbeenaColors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.locationDot,
                                size: 11,
                                color: LbeenaColors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                city,
                                style: const TextStyle(
                                  color: LbeenaColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: LbeenaColors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.55,
                    children: _order.map((item) {
                      final isNext = _nextPrayer == item.$2;
                      return Container(
                        decoration: BoxDecoration(
                          color: isNext
                              ? LbeenaColors.orange
                              : LbeenaColors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.$1,
                              style: TextStyle(
                                color: isNext
                                    ? LbeenaColors.white
                                    : LbeenaColors.white.withOpacity(0.75),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _cleanTime(timings[item.$3]),
                              style: TextStyle(
                                color: LbeenaColors.white,
                                fontSize: 14,
                                fontWeight:
                                    isNext ? FontWeight.w800 : FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
