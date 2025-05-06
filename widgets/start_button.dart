import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onStop;

  const StartButton({super.key, required this.onStart, required this.onStop});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool _isStarted = false;

  void _handlePressed() {
    setState(() {
      _isStarted = !_isStarted;
    });

    if (_isStarted) {
      widget.onStart();
    } else {
      widget.onStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(60),
        backgroundColor: _isStarted ? Colors.redAccent : Colors.blueGrey,
      ),
      onPressed: _handlePressed,
      child: Text(
        _isStarted ? 'Stop' : 'Start',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
