import 'package:flvm/flvm.dart';

class MainViewModel extends FlVm {
  final int counterMax = 10;
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    if ((counter + 1) > counterMax) {
      setError(Exception('Counter reached max value (10)'));
      return;
    }
    _counter++;
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    notifyListeners();
  }
}
