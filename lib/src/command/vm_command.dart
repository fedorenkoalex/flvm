import 'package:flutter/foundation.dart';
import 'package:flvm/src/model/result.dart';

typedef CommandAction0<T> = Future<CommandResult<T>> Function();
typedef CommandAction1<T, A> = Future<CommandResult<T>> Function(A);
typedef CommandAction2<T, A, B> = Future<CommandResult<T>> Function(A, B);
typedef CommandAction3<T, A, B, C> = Future<CommandResult<T>> Function(A, B, C);

abstract class VmCommand<T> extends ChangeNotifier {
  VmCommand({ValueChanged<Exception>? onError}) : _errorHandler = onError;

  final ValueChanged<Exception>? _errorHandler;

  bool _running = false;

  /// True when the action is running.
  bool get running => _running;

  CommandResult<T>? _result;

  /// true if action completed with error
  bool get isError => _result is Error;

  /// true if action completed successfully
  bool get isOk => _result is Ok;

  /// Get last action result
  CommandResult<T>? get result => _result;

  /// Clear last action result
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  void updateListener(VoidCallback listener) {
    removeListener(listener);
    addListener(listener);
  }

  /// Internal execute implementation
  Future<void> _execute(CommandAction0<T> action) async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners.
    // e.g. button shows loading state
    _running = true;
    _result = null;
    notifyListeners();

    try {
      final result = await action();
      if (_errorHandler != null && result.isError) {
        _errorHandler(result.asFailure.error);
      }
      _result = result;
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// [Command] without arguments.
/// Takes a [CommandAction0] as action.
class Command0<T> extends VmCommand<T> {
  Command0(this._action, {super.onError});

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> execute() async {
    await _execute(() => _action());
  }
}

/// [Command] with one argument.
/// Takes a [CommandAction1] as action.
class Command1<T, A> extends VmCommand<T> {
  Command1(this._action, {super.onError});

  final CommandAction1<T, A> _action;

  /// Executes the action with the argument.
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}

/// [Command] with two arguments.
/// Takes a [CommandAction2] as action.
class Command2<T, A, B> extends VmCommand<T> {
  Command2(this._action, {super.onError});

  final CommandAction2<T, A, B> _action;

  /// Executes the action with the argument.
  Future<void> execute(A argument1, B argument2) async {
    await _execute(() => _action(argument1, argument2));
  }
}
