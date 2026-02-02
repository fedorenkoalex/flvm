import 'package:flutter/widgets.dart';
import 'package:flvm/src/view_model/fl_vm.dart';
import 'package:flvm/src/widget/view_model_widget.dart';


mixin WidgetViewModelMixin on Widget {
  Widget vmBuilder<V extends FlVm>({
    required ViewModelBuilder<V> builder,
    required FlVm viewModel,
  }) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (BuildContext context, Widget? child) {
        return builder(context, viewModel as V);
      },
    );
  }

  Widget vmConsumer<V extends FlVm>({
    required ViewModelConsumer<V> consumer,
    required FlVm viewModel,
    Widget? child,
  }) {
    return ListenableBuilder(
      listenable: viewModel,
      child: child,
      builder: (BuildContext context, Widget? child) {
        consumer(context, viewModel as V);
        return child ?? const SizedBox.shrink();
      },
    );
  }
}