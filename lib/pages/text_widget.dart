import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final ValueListenable<int>? number;
  final String text;
  final double? size;
  final double? letterspacing;
  final String? font;

  const TextWidget({
    super.key,
    required this.text,
    this.number,
    this.size = 24,
    this.letterspacing = 0,
    this.font = 'rudaw',
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.size,
        fontFamily: widget.font,
        letterSpacing: widget.letterspacing,
        color: Colors.white70,
      ),
    );
  }
}
