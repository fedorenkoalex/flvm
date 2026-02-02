import 'package:flutter/widgets.dart';
import 'package:flvm/src/view_model/fl_vm.dart';
import 'package:flvm/src/widget/view_model_widget.dart';

extension VmConsumerExtension on FlVmWidget {
  Widget viewModelConsumer<V extends FlVm>({
    required ViewModelConsumer<V> consumer,
    Widget? child,
  }) => vmConsumer(consumer: consumer, viewModel: viewModel, child: child);
}
