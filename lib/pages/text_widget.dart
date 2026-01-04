import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final ValueListenable<int>? number;
  String text;
  double? size = 24;
  double? letterspacing = 0;
  String? font = 'rudaw';

  TextWidget({
    super.key,
    required this.text,
    this.size,
    this.letterspacing,
    this.number,
    this.font,
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
