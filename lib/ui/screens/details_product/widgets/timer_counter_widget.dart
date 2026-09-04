import 'package:flutter/cupertino.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../../../../widgets/components.dart';

class TimerCounterWidget extends StatefulWidget {
   TimerCounterWidget({super.key, required this.createdAt});
String createdAt;
  @override
  State<TimerCounterWidget> createState() => _TimerCounterWidgetState();
}

class _TimerCounterWidgetState extends State<TimerCounterWidget> {


  late int endTime;

  @override
  void initState() {

    DateTime createdAtDateTime = DateTime.parse(widget.createdAt == 'null' ? '2024-04-25 12:13:42' : widget.createdAt);
    endTime = createdAtDateTime.millisecondsSinceEpoch;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CountdownTimer(
        endTime: endTime,
        widgetBuilder: (_, time) {
          if (time == null) {
            return Text('الوقت قد انتهى!');
          }
          return Row(
            children: [
              buildTimerWidget(
                nameDate: '${time.days ?? 0}',
                name: 'يوم',
              ),
              buildTimerWidget(
                nameDate: '${time.hours ?? 0}',
                name: 'ساعة',
              ),

              buildTimerWidget(
                nameDate: '${time.min ?? 0}',
                name: 'دقيقة',
              ),

              buildTimerWidget(
                nameDate: '${time.sec ?? 0}',
                name: 'ثانية',
              ),
            ],
          );
        },
      ),
    );
  }
}
