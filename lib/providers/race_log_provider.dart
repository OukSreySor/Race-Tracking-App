import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'race_segment_provider.dart';
import '../model/race_segment.dart';

class RaceLogProvider with ChangeNotifier {
  final Map<String, List<Map<String, String>>> _logs = {};

  List<Map<String, String>> getLogs(String segment) => _logs[segment] ?? [];

  void log(BuildContext context, String segment, String bib, String time) {
    _logs.putIfAbsent(segment, () => []);

    if (_logs[segment]!.any((e) => e['bib'] == bib)) return;

    _logs[segment]!.add({'bib': bib, 'time': time});
    notifyListeners();

    _startNextSegment(context, segment);
  }

  void _startNextSegment(BuildContext context, String currentSegmentName) {
    final segmentProvider = Provider.of<RaceSegmentProvider>(context, listen: false);
    final segments = segmentProvider.segments;

    final currentIndex = segments.indexWhere(
      (s) => s.type.name.toLowerCase() == currentSegmentName.toLowerCase(),
    );

    if (currentIndex != -1 && currentIndex + 1 < segments.length) {
      final nextSegment = segments[currentIndex + 1];

      if (nextSegment.status == SegmentStatus.notStarted) {
        segmentProvider.startSegment(currentIndex + 1);
      }
    }
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
