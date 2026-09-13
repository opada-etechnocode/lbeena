import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

import '../../theme/lbeena_colors.dart';

class AnalogClockWidget extends StatelessWidget {
  const AnalogClockWidget({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnalogClock(
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: LbeenaColors.teal),
          color: LbeenaColors.white,
          shape: BoxShape.circle,
        ),
        width: size,
        isLive: true,
        hourHandColor: LbeenaColors.tealDark,
        minuteHandColor: LbeenaColors.teal,
        secondHandColor: LbeenaColors.orange,
        digitalClockColor: LbeenaColors.tealDark,
        numberColor: LbeenaColors.tealDark,
        showNumbers: true,
        showTicks: true,
        showAllNumbers: true,
        textScaleFactor: 1.3,
      ),
    );
  }
}
