import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/model/race_segment.dart';
import '../model/participant.dart';
import '../providers/participant_provider.dart';
import '../providers/race_segment_provider.dart';
import '../providers/race_log_provider.dart';
import '../widgets/actions/custom_action_button.dart';

class SegmentDetailsScreen extends StatefulWidget {
  final RaceSegment segment;

  const SegmentDetailsScreen({super.key, required this.segment});

  @override
  State<SegmentDetailsScreen> createState() => _SegmentDetailsScreenState();
}

class _SegmentDetailsScreenState extends State<SegmentDetailsScreen> {
  late String selectedRace;

  @override
  void initState() {
    super.initState();
    selectedRace = widget.segment.type.name;

    context.read<RaceSegmentProvider>().startSegment(
          context.read<RaceSegmentProvider>().segments.indexOf(widget.segment),
        );
  }

  void logBib(int bibNumber) {
    final logProvider = context.read<RaceLogProvider>();
    final segmentProvider = context.read<RaceSegmentProvider>();

    final segmentStart =
        segmentProvider.getSegmentStartTime(widget.segment.type);
    if (segmentStart == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(segmentStart);
    final formatted = formatDuration(elapsed);

    logProvider.log(selectedRace, 'BIB $bibNumber', formatted);
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void undoLog(String bib) {
    final logProvider = context.read<RaceLogProvider>();
    logProvider.undo(selectedRace, bib);
  }

  String getCurrentFormattedTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  List<Participant> getOrderedParticipants(
    List<Participant> all,
    List<Map<String, String>> previousLogs,
  ) {
    final order = previousLogs.map((e) => e['bib']).toList();
    all.sort((a, b) {
      final aIndex = order.indexOf('BIB ${a.bib}');
      final bIndex = order.indexOf('BIB ${b.bib}');
      if (aIndex == -1 && bIndex == -1) return 0;
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });
    return all;
  }

  String? getPreviousSegment(SegmentType current) {
    switch (current) {
      case SegmentType.cycle:
        return SegmentType.swim.name; // returns 'swim'
      case SegmentType.run:
        return SegmentType.cycle.name; // returns 'cycle'
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = context.watch<RaceLogProvider>();
    final rawParticipants = context.watch<ParticipantProvider>().participants;
    final currentLogs = logProvider.getLogs(selectedRace);
    final prevLogs =
        logProvider.getLogs(getPreviousSegment(widget.segment.type) ?? '');
    final participants = getOrderedParticipants(rawParticipants, prevLogs);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedRace.toUpperCase()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                raceButton(Icons.pool, 'Swim'),
                raceButton(Icons.directions_bike, 'Cycle'),
                raceButton(Icons.directions_run, 'Run'),
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                final participant = participants[index];
                final isSelected = currentLogs
                    .any((log) => log['bib'] == 'BIB ${participant.bib}');
                return GestureDetector(
                  onTap: () => logBib(int.parse(participant.bib)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueGrey[200] : Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(participant.bib,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text('Logged time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (currentLogs.isEmpty)
              const Center(child: Text('No BIBs logged yet'))
            else
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('BIB')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: currentLogs.map((log) {
                    return DataRow(cells: [
                      DataCell(Text(log['bib']!)),
                      DataCell(Text(log['time']!)),
                      DataCell(
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(60, 30),
                          ),
                          onPressed: () => undoLog(log['bib']!),
                          child: const Text('Undo'),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomActionButton(label: 'Pause', onPressed: () {}),
                CustomActionButton(
                    label: 'Done',
                    onPressed: () {
                      final segmentProvider =
                          context.read<RaceSegmentProvider>();

                      final allLogged = participants.every((p) => currentLogs
                          .any((log) => log['bib'] == 'BIB ${p.bib}'));

                      if (allLogged) {
                        final index =
                            segmentProvider.segments.indexOf(widget.segment);
                        segmentProvider.updateSegmentStatus(
                            index, SegmentStatus.completed);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Segment marked as completed!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Some participants are still missing.')),
                        );
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget raceButton(IconData icon, String label) {
    final isSelected = selectedRace == label;
    return InkWell(
      onTap: () {
        setState(() {
          selectedRace = label;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                isSelected ? Colors.blueGrey[100] : Colors.transparent,
            radius: 30,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
