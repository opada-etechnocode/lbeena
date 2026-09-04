import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/calender/calender_model.dart';
import '../../../widgets/calender_shimmer/calender_shimmer.dart';
import 'cubit/calender_cubit.dart';
import 'cubit/calender_state.dart';

class FullScrollableCalendar extends StatefulWidget {
  @override
  _FullScrollableCalendarState createState() => _FullScrollableCalendarState();
}

class _FullScrollableCalendarState extends State<FullScrollableCalendar> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Event>> _events = {};
  List<Calender> calenderData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Map<DateTime, List<Event>> _convertCalenderDataToEvents(List<Calender> data) {
    final Map<DateTime, List<Event>> eventsMap = {};

    for (var item in data) {
      if (item.date != null) {
        final date = DateTime(item.date!.year, item.date!.month, item.date!.day);

        if (eventsMap.containsKey(date)) {
          eventsMap[date]!.add(Event(item.name ?? 'مناسبة', isHoliday: true));
        } else {
          eventsMap[date] = [Event(item.name ?? 'مناسبة', isHoliday: true)];
        }
      }
    }

    return eventsMap;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNormalWithIcon(text: 'مناسبات وعطل رسمية', context: context, isShowBack: true),
      body: BlocProvider(
        create: (context) => CalenderCubit()..getCalenderInfo(),
        child: BlocConsumer<CalenderCubit, CalenderState>(
          listener: (context, state) {
            if (state is GetCalenderInfoStateLoading) {
              isLoading = true;
            }
            if (state is GetCalenderInfoStateSuccess) {
              calenderData = state.calenderModel.data;
              _events = _convertCalenderDataToEvents(calenderData);
              isLoading = false;
            }
            if (state is GetCalenderInfoStateError) {
              isLoading = false;
            }
          },
          builder: (context, state) {
            return isLoading
                ? const CalenderShimmer()
                : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TableCalendar(
                    firstDay: DateTime.now().subtract(Duration(days: 365)),
                    lastDay: DateTime.now().add(Duration(days: 365 * 2)),
                    focusedDay: _focusedDay,
                    calendarFormat: calendarFormat,

                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },

                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final date = DateTime(day.year, day.month, day.day);
                        final isHoliday = _events[date]?.any((event) => event.isHoliday) ?? false;

                        if (isHoliday) {
                          return Container(
                            margin: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style:const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                      todayBuilder: (context, day, focusedDay) {
                        final date = DateTime(day.year, day.month, day.day);
                        final isHoliday = _events[date]?.any((event) => event.isHoliday) ?? false;

                        return Container(
                          margin: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: isHoliday
                                ? Colors.red.withOpacity(0.3)
                                : Colors.green.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isHoliday ? Colors.red : Colors.green,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isHoliday ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        final date = DateTime(day.year, day.month, day.day);
                        final isHoliday = _events[date]?.any((event) => event.isHoliday) ?? false;

                        return Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isHoliday
                                ? Colors.red.withOpacity(0.4)
                                : Colors.blue.withOpacity(0.4),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isHoliday ? Colors.red : Colors.blue,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isHoliday ? Colors.red : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return Positioned(
                            bottom: 1,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(color: appTheme.black900),
                      weekendTextStyle: TextStyle(color: appTheme.black900),
                      holidayTextStyle: TextStyle(color: Colors.red),

                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,

                      titleCentered: true,
                      leftChevronIcon: Icon(Icons.chevron_left, color:appTheme.lightBlue100,), // أيقونة الشهر السابق
                      rightChevronIcon: Icon(Icons.chevron_right, color: appTheme.lightBlue100), // أيقونة الشهر التالي
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.green, // لون خلفية زر تغيير الشكل
                        borderRadius: BorderRadius.circular(20),
                      ),
                      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.fSize,color: appTheme.black900),

                    ),

                    eventLoader: (day) {
                      final date = DateTime(day.year, day.month, day.day);
                      return _events[date] ?? [];
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final eventDate = _events.keys.elementAt(index);
                      return EventCard(
                          date: eventDate, events: _events[eventDate]!);
                    },
                    childCount: _events.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final DateTime date;
  final List<Event> events;

  const EventCard({required this.date, required this.events});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appTheme.whiteA700,
      margin: EdgeInsets.all(8.r),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.fSize),
            ),
            ...events
                .map((e) => ListTile(
              leading: Icon(Icons.circle, size: 8.fSize, color: Colors.red),
              textColor: appTheme.black900,
              title: Text(e.title),
            ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final bool isHoliday;

  Event(this.title, {this.isHoliday = false});
}