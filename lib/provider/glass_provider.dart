import 'package:flutter/foundation.dart';

class GlassProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isVisible = true;
  bool get getVisibility => _isVisible;

  void setter(bool setVisibility) {
    _isVisible = setVisibility;
    notifyListeners();
  }
}
