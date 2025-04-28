import 'package:flutter/material.dart';
import 'package:race_tracking_app/model/race_segment.dart';
import 'package:race_tracking_app/theme/theme.dart';

class RaceSegmentCard extends StatelessWidget {
  final RaceSegment segment;
  final VoidCallback? onTap;

  const RaceSegmentCard({super.key, required this.segment, this.onTap});

  IconData getSegmentIcon() {
    switch (segment.type) {
      case SegmentType.swim:
        return Icons.pool;
      case SegmentType.cycle:
        return Icons.directions_bike;
      case SegmentType.run:
        return Icons.directions_run;
    }
  }

  Color getBackgroundColor() {
    switch (segment.status) {
      case SegmentStatus.completed:
        return Colors.greenAccent;
      case SegmentStatus.inProgress:
        return Colors.deepOrange;
      case SegmentStatus.notStarted:
      default:
        return Colors.grey[300]!;
    }
  }

  String getStatusText() {
    switch (segment.status) {
      case SegmentStatus.completed:
        return 'Complete';
      case SegmentStatus.inProgress:
        return 'In Progress';
      case SegmentStatus.notStarted:
      default:
        return 'Not Started';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          onTap: onTap,
          leading: Icon(getSegmentIcon(), size: 40, color: Colors.black),
          title: Text(
            segment.type.name.toUpperCase(),
            style: RaceTextStyles.body,
          ),
          subtitle: Text(
            getStatusText(),
            style: TextStyle(
              fontSize: 14,
              color: getBackgroundColor(),
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black),
        ),
      ),
    );
  }
}
