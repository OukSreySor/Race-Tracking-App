import 'package:flutter/material.dart';
import 'package:race_tracking_app/model/race_segment.dart';

class RaceSegmentProvider with ChangeNotifier {
  final List<RaceSegment> _segments = [
    RaceSegment(type: SegmentType.swim),
    RaceSegment(type: SegmentType.cycle),
    RaceSegment(type: SegmentType.run),
  ];

  List<RaceSegment> get segments => _segments;

  void updateSegmentStatus(int index, SegmentStatus newStatus) {
    _segments[index].status = newStatus;
    notifyListeners();
  }

  void startSegment(int index) {
    segments[index].status = SegmentStatus.inProgress;
    segments[index].startTime = DateTime.now();
    notifyListeners();
  }

  void completeSegment(int index) {
    segments[index].status = SegmentStatus.completed;
    segments[index].endTime = DateTime.now();
    notifyListeners();
  }

  void reset() {
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
}
