import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class AnalogClockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnalogClock(
        decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: Colors.black),
          shape: BoxShape.circle,
        ),
        width: 130.0,
        isLive: true,
        hourHandColor: Colors.black,
        minuteHandColor: Colors.black,
        secondHandColor: Colors.red,digitalClockColor: Colors.black,
        numberColor: Colors.black,
        showNumbers: true,
        showTicks: true,
        showAllNumbers: true,
        textScaleFactor: 1.4,
      ),
    );
  }
}
