import 'package:flutter/material.dart';

class TopCurvedCircularPainter extends CustomPainter {
  final Color bgColor;

  TopCurvedCircularPainter({required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4880000, size.height * 0.9512195);
    path_0.cubicTo(
        size.width * 0.1457752,
        size.height * 0.9512195,
        size.width * 0.01485608,
        size.height * 0.6132073,
        0,
        size.height * 0.6650549);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height * 0.6650549);
    path_0.cubicTo(
        size.width * 0.9665733,
        size.height * 0.7054695,
        size.width * 0.8266667,
        size.height * 0.9512195,
        size.width * 0.4880000,
        size.height * 0.9512195);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = bgColor.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    canvas.drawShadow(path_0, Colors.black.withAlpha(100), 10.0, false);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
