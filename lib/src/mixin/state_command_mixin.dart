import 'package:flutter/widgets.dart';
import 'package:flvm/src/command/vm_command.dart';
import 'package:flvm/src/widget/view_model_widget.dart';

mixin StateCommandMixin<W extends StatefulWidget> on State<W> {

  Widget commandBuilder<T>({
    required VmCommand<T> command,
    required CommandBuilder<T> builder,
  }) {
    return ListenableBuilder(
      listenable: command,
      builder: (BuildContext context, Widget? child) {
        return builder(context, command);
      },
    );
  }

}