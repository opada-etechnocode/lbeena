import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../widgets/components.dart';
import '../../../theme/theme_helper.dart';

class TimerReminderWidget extends StatefulWidget {
  final String reminderDate;

  TimerReminderWidget({required this.reminderDate});

  @override
  _TimerReminderWidgetState createState() => _TimerReminderWidgetState();
}

class _TimerReminderWidgetState extends State<TimerReminderWidget> {
  Timer? _timer;
  late int _secondsRemaining;
  late String _formattedTime;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  void _calculateRemainingTime() {
    try {
      DateTime targetDate = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(widget.reminderDate);
      Duration difference = targetDate.difference(DateTime.now());
      _secondsRemaining = difference.inSeconds.clamp(0, double.infinity).toInt(); // التأكد من عدم وجود قيم سالبة
      print(_secondsRemaining);
      _formattedTime = _formatTime(_secondsRemaining);
    } catch (e) {
      // في حالة حدوث خطأ أثناء التحليل
      _secondsRemaining = 0;
      _formattedTime = "Invalid Date";
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining <= 0) {
          timer.cancel();
          _formattedTime = "مؤرشفة";
        } else {
          _secondsRemaining--;
          _formattedTime = _formatTime(_secondsRemaining);
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int days = seconds ~/ 86400; // 1 يوم = 86400 ثانية
    int hours = (seconds % 86400) ~/ 3600; // 1 ساعة = 3600 ثانية
    int minutes = (seconds % 3600) ~/ 60; // 1 دقيقة = 60 ثانية
    int remainingSeconds = seconds % 60;

    // ضمان أن القيم تحتوي دائمًا على رقمين
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(days)}:${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(remainingSeconds)}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // التأكد من أن التايمر غير فارغ قبل الإلغاء
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return textNormal(
      text: _formattedTime,
      color: appTheme.deepPurpleA10001,
      fontSize: AppFontSize.fontSize_15,
    );
  }
}
