import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onStop;
  final bool hasParticipants;
  final bool isStarted;

  const StartButton({
    super.key,
    required this.onStart,
    required this.onStop,
    required this.hasParticipants, 
    required this.isStarted,
  });

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool _isStarted = false;

  void _handlePressed() {
    if (!widget.hasParticipants) return; // Do nothing if no participants!

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
        backgroundColor: widget.hasParticipants
            ? (_isStarted ? Colors.redAccent : Colors.blueGrey)
            : Colors.grey, // Grey if no participants
      ),
      onPressed: widget.hasParticipants ? _handlePressed : null, // Disable if no participants
      child: Text(
        _isStarted ? 'Stop' : 'Start',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
