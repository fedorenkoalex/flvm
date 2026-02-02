import 'package:flutter/widgets.dart';
import 'package:flvm/src/typedefs/typedefs.dart';
import 'package:flvm/src/view_model/fl_vm.dart';
import 'package:flvm/src/widget/view_model_widget.dart';

mixin StateViewModelMixin<W extends StatefulWidget> on State<W> {
  Widget? _previousBuilderState;
  FlVm? _previousViewModelState;

  Widget vmBuilder<V extends FlVm>({
    required ViewModelBuilder<V> builder,
    required FlVm viewModel,
    ViewModelCondition<V>? buildWhen,
  }) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (BuildContext context, Widget? child) {
        if (buildWhen == null) {
          return builder(context, viewModel as V);
        } else {
          //init previous state if it's null
          _previousBuilderState ??= builder(context, viewModel as V);
          //check is need to call build
          final shouldRebuild = buildWhen(
            (_previousViewModelState ?? viewModel) as V,
            viewModel as V,
          );
          if (shouldRebuild) {
            _previousViewModelState = viewModel;
            _previousBuilderState = builder(context, viewModel);
            return _previousBuilderState ?? const SizedBox.shrink();
          } else {
            return _previousBuilderState ?? const SizedBox.shrink();
          }
        }
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

  @override
  void dispose() {
    _previousBuilderState = null;
    _previousViewModelState = null;
    super.dispose();
  }
}
