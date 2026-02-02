import 'package:flutter/foundation.dart';
import 'package:flvm/src/view_model/fl_vm.dart';

abstract class FlVmStateful<T> extends FlVm {
  FlVmStateful(T defaultModel) {
    _data = defaultModel;
  }

  late T _data;

  T get data => _data;

  @protected
  void setData(T data) {
    _data = data;
  }
}
