import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class KeyAnimator with ChangeNotifier, DiagnosticableTreeMixin {
  String _text = "t";
  String get text => _text;

  void setter(String setText) {
    _text = setText;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}
