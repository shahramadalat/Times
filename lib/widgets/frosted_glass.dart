import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final BorderRadius? borderRadius;
  final double blur;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const FrostedGlass({
    Key? key,
    this.width,
    this.height,
    this.child,
    this.borderRadius,
    this.blur = 6.0,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.08),
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
            border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.05), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
