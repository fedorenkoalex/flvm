`flvm` based on [Flutter Architecture case study](https://docs.flutter.dev/app-architecture/case-study) and [Compass App](https://github.com/flutter/samples/tree/main/compass_app) example.  

Additionally added base classes to aviod boilerplate code and improved error handlings. 


## Basic usage

Create a View Model:

```
class MyViewModel extends FlVm {
```

Don\`t forget to call `notifyListeners()`  when you need to deliver updated:

```
 void increment() {
    _counter++;
    notifyListeners();
  }
```

Inherit your widget state from `FlVmState`:

```
class _MyScreenState extends
FlVmWidget<MainScreen, MyViewModel> {
```

Bind your View Model:

```
 @override
  MyViewModel bindViewModel() => MyViewModel();
```

Use `viewModelBuilder` to listen for View Model updates:

```
viewModelBuilder<MainViewModel>(
              builder: (context, vm) {
                return Text(
                  '${vm.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
```

## Advanced setup

### Error handling

Additionally use can use `onError` function to handle errors you emit in View Model.
Add `onError` function to your widget state class:

```
  void onError(Exception error) {
  		super.onError(error);
  		//show error dialog here
  }
```

Call `setError` in your View Model to emit an error:

```
 setError(Exception('Ooops...'));
```

### Commands

Create a new `Command` in your View Model:

```
late Command1 login;

...

login = Command1<void, (String username, String password)>(
      _login,
      onError: _onCommandError, //optional
    );
```

Create body function for your Command:

```
Future<Result<void>> _login((String, String) credentials) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.ok(null);
  }
```

Also you can set optional `onError` param to handle Command errors and deliver them to UI using `setError`:

```
onError: _onCommandError,
```

```
void _onCommandError(Exception error) {
    setError(error);
  }
```

In your Widget execute command where you need:

```
viewModel.login.execute((
      _usernameController.text,
      _passwordController.text,
    ));
```

Use `commandBuilder` to handle Command state in widget tree:

```
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
```

Use listener to listen to command updates outside the widget tree:

```
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
```

```
void _onLoginResult() {
    if (viewModel.login.isOk) {
      viewModel.login.clearResult();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
    }

    ///on error do nothing
  }
```

