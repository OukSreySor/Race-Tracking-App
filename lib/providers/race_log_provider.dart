import 'package:flutter/material.dart';

class RaceLogProvider with ChangeNotifier {
  final Map<String, List<Map<String, String>>> _logs = {};

  List<Map<String, String>> getLogs(String segment) => _logs[segment] ?? [];

  void log(String segment, String bib, String time) {
    _logs.putIfAbsent(segment, () => []);
    if (_logs[segment]!.any((e) => e['bib'] == bib)) return;
    _logs[segment]!.add({'bib': bib, 'time': time});
    notifyListeners();
  }

  void undo(String segment, String bib) {
    _logs[segment]?.removeWhere((e) => e['bib'] == bib);
    notifyListeners();
  }

  void reset() {
    _logs.clear(); 
    notifyListeners();
  }
}
