import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class FlVm extends ChangeNotifier {
  @protected
  final StreamController<Exception> _errorController =
      StreamController.broadcast();

  Stream<Exception> get errorStream => _errorController.stream;

  bool _loading = false;

  bool get loading => _loading;

  void cleanInternalState() {
    _loading = false;
  }

  @protected
  void setError(Exception error) {
    if (!_errorController.isClosed) _errorController.add(error);
  }

  @protected
  void setLoading(bool loading, {bool autoNotify = true}) {
    _loading = loading;
    if (autoNotify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (!_errorController.isClosed) {
      _errorController.close();
    }
    return super.dispose();
  }
}
