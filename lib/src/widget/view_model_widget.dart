import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flvm/src/command/vm_command.dart';
import 'package:flvm/src/mixin/state_command_mixin.dart';
import 'package:flvm/src/mixin/state_view_model_mixin.dart';
import 'package:flvm/src/view_model/fl_vm.dart';

typedef ViewModelBuilder<V extends FlVm> =
    Widget Function(BuildContext context, V vm);

typedef ViewModelConsumer<V extends FlVm> =
    void Function(BuildContext context, V vm);

typedef CommandBuilder<T> =
    Widget Function(BuildContext context, VmCommand<T> command);

abstract class FlVmWidget<T extends StatefulWidget, V extends FlVm>
    extends State<T>
    with StateViewModelMixin, StateCommandMixin {
  late V viewModel;

  late StreamSubscription<Exception> _errorSubscription;

  FlVmWidget() {
    viewModel = bindViewModel();
  }

  V bindViewModel();

  ///Override [onError] to handle errors from ViewModel
  void onError(Exception error) {
    //empty;
  }

  ///[onVmInitialized] called when View model initialized. Listeners are
  ///set and streams initialized.
  void onVmInitialized() {}

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onViewModelChange);
    _errorSubscription = viewModel.errorStream.listen(onError);
    onVmInitialized();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    viewModel.removeListener(_onViewModelChange);
    viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    viewModel.removeListener(_onViewModelChange);
    viewModel.dispose();
    super.dispose();
  }

  void resetVm() {
    setState(() {
      viewModel = bindViewModel();
    });
  }

  void onChanged(V vm) {}

  void _onViewModelChange() {
    onChanged(viewModel);
  }
}
