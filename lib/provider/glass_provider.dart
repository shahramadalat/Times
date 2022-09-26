import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class GlassProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isVisible = true;
  bool get getVisibility => _isVisible;

  void setter(bool setVisibility) {
    _isVisible = setVisibility;
    notifyListeners();
  }
}
