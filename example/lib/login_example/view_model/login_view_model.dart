import 'package:flvm/flvm.dart';

class LoginViewModel extends FlVm {
  late Command1 login;

  LoginViewModel() {
    login = Command1<void, (String username, String password)>(
      _login,
      onError: _onCommandError,
    );
  }

  Future<Result<void>> _login((String, String) credentials) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.ok(null);
  }

  void _onCommandError(Exception error) {
    setError(error);
  }
}
