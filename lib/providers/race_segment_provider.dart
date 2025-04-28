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
}
