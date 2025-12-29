import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:times/widgets/frosted_glass.dart';
import 'package:times/pages/text_widget.dart';
import '../provider/glass_provider.dart';

class GlassWidget extends StatefulWidget {
  const GlassWidget({super.key});

  @override
  State<GlassWidget> createState() => _GlassWidgetState();
}

class _GlassWidgetState extends State<GlassWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<GlassProvider>().getVisibility,
      child: FrostedGlass(
        width: 260,
        height: 50,
        borderRadius: BorderRadius.circular(12),
        blur: 6.0,
        child: TextWidget(text: 'ئاڵاکان بجوڵێنە', size: 25),
      ),
    );
  }
}
