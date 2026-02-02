import 'package:example/main_example/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flvm/flvm.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends FlVmWidget<MainScreen, MainViewModel> {
  @override
  MainViewModel bindViewModel() => MainViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Basic FlVm Example', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            const Text('You have pushed the button this many times:'),
            viewModelBuilder<MainViewModel>(
              builder: (context, vm) {
                return Text(
                  '${vm.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void onError(Exception error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error.toString()),
          content: Text(''),
          actions: [
            OutlinedButton(
              onPressed: () {
                viewModel.reset();
                Navigator.of(context).pop();
              },
              child: Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    super.onError(error);
  }
}
