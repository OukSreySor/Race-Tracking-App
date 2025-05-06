enum SegmentType { swim, cycle, run }
enum SegmentStatus { notStarted, inProgress, completed }

class RaceSegment {
  final SegmentType type;
  SegmentStatus status;
  Duration? duration;
  DateTime? startTime;
  DateTime? endTime;


  RaceSegment({
    required this.type,
    this.status = SegmentStatus.notStarted,
    this.duration,
  });
}