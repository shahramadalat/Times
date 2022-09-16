import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final ValueListenable<int>? number;
  String text;
  double? size = 24;
  double? letterspacing = 0;

  TextWidget(
      {super.key,
      required this.text,
      this.size,
      this.letterspacing,
      this.number});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          fontSize: size,
          fontFamily: 'rudaw',
          letterSpacing: letterspacing,
          color: Colors.white,
        ));
  }
}
