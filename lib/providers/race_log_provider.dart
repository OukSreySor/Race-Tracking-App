import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'race_segment_provider.dart';
import '../model/race_segment.dart';

class RaceLogProvider with ChangeNotifier {
  final Map<String, List<Map<String, dynamic>>> _logs = {}; // Includes bib, time, datetime
  final Map<String, DateTime> _segmentStartTimes = {}; // Start time of each segment

  Map<String, DateTime> get segmentStartTimes => _segmentStartTimes;

  List<Map<String, dynamic>> getLogs(String segment) => _logs[segment] ?? [];

  void log(BuildContext context, String segment, String bib, String formattedTime) {
    _logs.putIfAbsent(segment, () => []);

    if (_logs[segment]!.any((e) => e['bib'] == bib)) return;

    final now = DateTime.now();

    _logs[segment]!.add({
      'bib': bib,
      'time': formattedTime,
      'loggedAt': now, // Save actual DateTime for calculations
    });

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

        final nextSegmentKey = nextSegment.type.name.toLowerCase();
        _segmentStartTimes.putIfAbsent(nextSegmentKey, () => DateTime.now());
      }
    }
  }

  void setRaceStartTime(String segment) {
    if (!_segmentStartTimes.containsKey(segment.toLowerCase())) {
      _segmentStartTimes[segment.toLowerCase()] = DateTime.now();
      notifyListeners();
    }
  }

  DateTime? getSegmentStartTime(String segment) => _segmentStartTimes[segment.toLowerCase()];

  List<String> getAvailableBibsForSegment(BuildContext context, String segment) {
    final segmentOrder = ['swim', 'cycle', 'run'];
    final currentIndex = segmentOrder.indexOf(segment.toLowerCase());

    if (segment.toLowerCase() == 'swim') {
      final participantProvider = Provider.of<ParticipantProvider>(context, listen: false);
      return participantProvider.participants.map((p) => p.bib.toString()).toList();
    }

    if (currentIndex > 0) {
      final prevSegment = segmentOrder[currentIndex - 1];
      final completedBibs = _logs[prevSegment]?.map((e) => e['bib'] as String).toSet().toList() ?? [];
      return completedBibs;
    }

    return [];
  }

  void undo(String segment, String bib) {
    _logs[segment]?.removeWhere((e) => e['bib'] == bib);
    notifyListeners();
  }

  void reset() {
    _logs.clear();
    _segmentStartTimes.clear();
    notifyListeners();
  }
}
