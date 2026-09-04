import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

  class WallClock extends StatefulWidget {
  @override
  _WallClockState createState() => _WallClockState();
}

class _WallClockState extends State<WallClock> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: CustomPaint(
          painter: ClockPainter(_dateTime),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;
  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()..color = Colors.white;
    final paintCenterDot = Paint()..color = Colors.red;
    final paintTicks = Paint()..color = Colors.black..strokeWidth = 2;

    // رسم الإطار
    canvas.drawCircle(center, radius, paintCircle);

    // رسم مركز الساعة
    canvas.drawCircle(center, 5, paintCenterDot);

    // رسم علامات الساعات (Ticks)
    for (int i = 0; i < 12; i++) {
      double angle = i * 30 * pi / 180;
      Offset start = Offset(
        center.dx + (radius - 10) * cos(angle),
        center.dy + (radius - 10) * sin(angle),
      );
      Offset end = Offset(
        center.dx + (radius - 20) * cos(angle),
        center.dy + (radius - 20) * sin(angle),
      );
      canvas.drawLine(start, end, paintTicks);
    }

    // رسم أرقام الساعة
    for (int i = 1; i <= 12; i++) {
      double angle = (i * 30 - 90) * pi / 180;
      Offset textPos = Offset(
        center.dx + (radius - 30) * cos(angle) - 10,
        center.dy + (radius - 30) * sin(angle) + 5,
      );

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, textPos);
    }

    // حساب زوايا العقارب
    final hourAngle = (dateTime.hour % 12 + dateTime.minute / 60) * 30 * pi / 180;
    final minuteAngle = (dateTime.minute + dateTime.second / 60) * 6 * pi / 180;
    final secondAngle = dateTime.second * 6 * pi / 180;

    // رسم العقارب
    _drawHand(canvas, center, hourAngle, radius * 0.5, 6, Colors.black);
    _drawHand(canvas, center, minuteAngle, radius * 0.7, 4, Colors.blue);
    _drawHand(canvas, center, secondAngle, radius * 0.9, 2, Colors.red);
  }

  void _drawHand(Canvas canvas, Offset center, double angle, double length, double width, Color color) {
    final handPaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    final endPoint = Offset(
      center.dx + length * cos(angle - pi / 2),
      center.dy + length * sin(angle - pi / 2),
    );

    canvas.drawLine(center, endPoint, handPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
