import 'package:flutter/material.dart';

import '../../widgets/start_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleStart() {
    debugPrint('Race started!');
  }

  void _handleStop() {
    debugPrint('Race stopped!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Race Tracking')),
      body: Center(
        child: StartButton(
          onStart: _handleStart,
          onStop: _handleStop,
        ),
      ),
    );
  }
}
