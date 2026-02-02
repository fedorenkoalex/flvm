import 'package:example/login_example/view_model/login_view_model.dart';
import 'package:example/main_example/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flvm/flvm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends FlVmWidget<LoginScreen, LoginViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  LoginViewModel bindViewModel() => LoginViewModel();

  @override
  void onVmInitialized() {
    super.onVmInitialized();
    viewModel.login.addListener(_onLoginResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    viewModel.login.updateListener(_onLoginResult);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.login.removeListener(_onLoginResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 48),
              Text('WELCOME', style: Theme.of(context).textTheme.titleMedium),
              Spacer(),
              TextFormField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a username',
                ),
                validator: (input) => (input?.isNotEmpty ?? false)
                    ? null
                    : 'Please enter username',
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a password',
                ),
                keyboardType: TextInputType.text,
                validator: (input) => (input?.isNotEmpty ?? false)
                    ? null
                    : 'Please enter password',
              ),
              Spacer(),
              commandBuilder<void>(
                command: viewModel.login,
                builder: (context, command) {
                  return ElevatedButton(
                    onPressed: _onLogin,
                    child: command.running
                        ? const CircularProgressIndicator()
                        : Text('LOGIN'),
                  );
                },
              ),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(Exception error) {
    super.onError(error);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onLogin() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    viewModel.login.execute((
      _usernameController.text,
      _passwordController.text,
    ));
  }

  void _onLoginResult() {
    if (viewModel.login.isOk) {
      viewModel.login.clearResult();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
    }

    ///on error do nothing
  }
}
