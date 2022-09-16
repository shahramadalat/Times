import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class AnalogWidget extends StatefulWidget {
  DateTime date;
  double width = 50;
  double heigh = 50;
  AnalogWidget(
      {super.key,
      required this.date,
      required this.width,
      required this.heigh});

  @override
  State<AnalogWidget> createState() => _AnalogWidgetState();
}

class _AnalogWidgetState extends State<AnalogWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      height: widget.heigh,
      width: widget.width,
      child: AnalogClock(
        tickColor: Colors.white70,
        minuteHandColor: Colors.white54,
        hourHandColor: Colors.white70,
        showDigitalClock: false,
        digitalClockColor: Colors.white60,
        showSecondHand: false,
        datetime: widget.date,
        showNumbers: false,
      ),
    );
  }
}
