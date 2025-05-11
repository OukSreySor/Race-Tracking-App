import 'package:flutter/material.dart';
import 'package:race_tracking_app/model/race_segment.dart';

class RaceSegmentProvider with ChangeNotifier {
  final List<RaceSegment> _segments = [
    RaceSegment(type: SegmentType.swim),
    RaceSegment(type: SegmentType.cycle),
    RaceSegment(type: SegmentType.run),
  ];

  DateTime? _raceStartTime;
  bool _raceStarted = false; 

  List<RaceSegment> get segments => _segments;
  DateTime? get raceStartTime => _raceStartTime;
  bool get raceStarted => _raceStarted;


  /// (Starts the race) Method to initialize the global timer and the first segment
  void startRace() {
    _raceStartTime = DateTime.now();
    _raceStarted = true; 
    startSegment(0);
    notifyListeners();
  }

  void startSegment(int index) {
    if (_segments[index].status == SegmentStatus.notStarted) {
      _segments[index].status = SegmentStatus.inProgress;
      _segments[index].startTime = DateTime.now();
      notifyListeners();
    }
  }

  void updateSegmentStatus(int index, SegmentStatus newStatus) {
    _segments[index].status = newStatus;
    notifyListeners();
  }

  void completeSegment(int index) {
    _segments[index].status = SegmentStatus.completed;
    _segments[index].endTime = DateTime.now();
    notifyListeners();
  }

  void reset() {
    _raceStartTime = null;
    _raceStarted = false; 
    for (var segment in _segments) {
      segment.status = SegmentStatus.notStarted;
      segment.startTime = null;
      segment.endTime = null;
    }
    notifyListeners();
  }

  DateTime? getSegmentStartTime(SegmentType type) {
    return _segments.firstWhere((seg) => seg.type == type).startTime;
  }

  Duration? get elapsedTime {
    if (_raceStartTime == null) return null;
    return DateTime.now().difference(_raceStartTime!);
  }
}
