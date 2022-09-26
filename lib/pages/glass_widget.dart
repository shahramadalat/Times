import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:provider/provider.dart';
import 'package:times/pages/text_widget.dart';

import '../provider/glass_provider.dart';
import '../provider/key_animator.dart';

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
      child: GlassContainer.clearGlass(
        alignment: Alignment.center,
        width: 260,
        height: 50,
        child: TextWidget(text: 'ئاڵاکان بجوڵێنە', size: 25),
      ),
    );
  }
}
