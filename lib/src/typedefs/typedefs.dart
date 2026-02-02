

import 'package:flvm/src/view_model/fl_vm.dart';

typedef ViewModelCondition<V extends FlVm> =
    bool Function(V oldVm, V newVm);
