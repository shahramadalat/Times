import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:times/provider/key_animator.dart';

class TextWidget extends StatefulWidget {
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
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      totalRepeatCount: 1,
      key: Key('${context.watch<KeyAnimator>().text}'),
      animatedTexts: [
        TyperAnimatedText('${widget.text}',
            speed: Duration(milliseconds: 50),
            textStyle: TextStyle(
              fontSize: widget.size,
              fontFamily: 'rudaw',
              letterSpacing: widget.letterspacing,
              // color: Colors.white,
              color: Colors.white70,
            ))
      ],
    );
  }
}
