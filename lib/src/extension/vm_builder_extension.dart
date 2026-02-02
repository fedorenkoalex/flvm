import 'package:flutter/widgets.dart';
import 'package:flvm/src/typedefs/typedefs.dart';
import 'package:flvm/src/view_model/fl_vm.dart';
import 'package:flvm/src/widget/view_model_widget.dart';


extension VmBuilderExtension on FlVmWidget {
  Widget viewModelBuilder<V extends FlVm>({
    required ViewModelBuilder<V> builder,
    ViewModelCondition<V>? buildWhen,
  }) =>
      vmBuilder(
        builder: builder,
        viewModel: viewModel,
        buildWhen: buildWhen,
      );
}