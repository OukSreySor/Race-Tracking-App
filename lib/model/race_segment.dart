enum SegmentType { swim, cycle, run }
enum SegmentStatus { notStarted, inProgress, completed }

class RaceSegment {
  final SegmentType type;
  SegmentStatus status;
  DateTime? startTime;
  DateTime? endTime;


  RaceSegment({
    required this.type,
    this.status = SegmentStatus.notStarted,

  });
}