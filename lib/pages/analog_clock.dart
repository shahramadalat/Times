import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class AnalogWidget extends StatefulWidget {
  DateTime date;
  AnalogWidget({
    super.key,
    required this.date,
  });

  @override
  State<AnalogWidget> createState() => _AnalogWidgetState();
}

class _AnalogWidgetState extends State<AnalogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
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
