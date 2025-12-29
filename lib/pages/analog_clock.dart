import 'dart:math';
import 'package:flutter/material.dart';

class AnalogWidget extends StatelessWidget {
  final DateTime date;
  const AnalogWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final now = date.toLocal();
    final radius = 100.0;
    final double hour =
        (now.hour % 12) + now.minute / 60.0; // fractional hour for smooth hand
    final double minute = now.minute + now.second / 60.0;

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        painter: _ClockPainter(hour: hour, minute: minute),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double hour;
  final double minute;
  _ClockPainter({required this.hour, required this.minute});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // face
    canvas.drawCircle(center, radius, paint);

    // hour markers (numbers)
    for (int i = 1; i <= 12; i++) {
      final angle = (pi / 6) * i - pi / 2;
      final numberRadius = radius * 0.78;
      final offset = Offset(
        center.dx + cos(angle) * numberRadius,
        center.dy + sin(angle) * numberRadius,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      final labelOffset =
          offset - Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, labelOffset);
    }

    // hour hand
    final hourAngle = (pi / 6) * hour - pi / 2;
    final hourLength = radius * 0.5;
    final hourOffset = Offset(
      cos(hourAngle) * hourLength,
      sin(hourAngle) * hourLength,
    );
    canvas.drawLine(
      center,
      center + hourOffset,
      paint
        ..strokeWidth = 4
        ..color = Colors.white70,
    );

    // minute hand
    final minuteAngle = (pi / 30) * minute - pi / 2;
    final minuteLength = radius * 0.75;
    final minuteOffset = Offset(
      cos(minuteAngle) * minuteLength,
      sin(minuteAngle) * minuteLength,
    );
    canvas.drawLine(
      center,
      center + minuteOffset,
      paint
        ..strokeWidth = 3
        ..color = Colors.white60,
    );

    // center dot
    canvas.drawCircle(center, 3, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.hour != hour || oldDelegate.minute != minute;
  }
}
