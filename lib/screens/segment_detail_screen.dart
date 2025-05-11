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
  Set<String> markedBibs = {};

  @override
  void initState() {
    super.initState();
    selectedRace = widget.segment.type.name;

    context.read<RaceSegmentProvider>().startSegment(
          context.read<RaceSegmentProvider>().segments.indexOf(widget.segment),
        );
  }

  void logBib(String bibNumber) {
    final logProvider = context.read<RaceLogProvider>();
    final segmentProvider = context.read<RaceSegmentProvider>();

    final globalStart = segmentProvider.raceStartTime;
    if (globalStart == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(globalStart);
    final formatted = formatDuration(elapsed);

    logProvider.log(context, selectedRace, bibNumber, formatted);
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

  String? getPreviousSegment(SegmentType current) {
    switch (current) {
      case SegmentType.cycle:
        return SegmentType.swim.name;
      case SegmentType.run:
        return SegmentType.cycle.name;
      default:
        return null;
    }
  }

  List<Participant> getOrderedParticipants(
    List<Participant> all,
    List<Map<String, String>> previousLogs,
  ) {
    final previousBibs = previousLogs.map((e) => e['bib']).toSet();

    // Include only those from previous segment, even if not logged in current
    final filtered = all
        .where((p) => previousBibs.contains(p.bib))
        .where((p) => !markedBibs.contains(p.bib))
        .toList();

    filtered.sort((a, b) {
      final aIndex = previousLogs.indexWhere((e) => e['bib'] == a.bib);
      final bIndex = previousLogs.indexWhere((e) => e['bib'] == b.bib);
      return aIndex.compareTo(bIndex);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = context.watch<RaceLogProvider>();
    final rawParticipants = context.watch<ParticipantProvider>().participants;
    final currentLogs = logProvider.getLogs(selectedRace);

    final prevSegmentKey = getPreviousSegment(widget.segment.type);
    final List<Map<String, String>> prevLogs =
        prevSegmentKey != null ? logProvider.getLogs(prevSegmentKey) : [];

    final participants = prevSegmentKey != null
        ? getOrderedParticipants(rawParticipants, prevLogs)
        : rawParticipants.where((p) => !markedBibs.contains(p.bib)).toList();

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
                raceIcon(Icons.pool, 'Swim'),
                raceIcon(Icons.directions_bike, 'Cycle'),
                raceIcon(Icons.directions_run, 'Run'),
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final participant = participants[index];
                final isSelected =
                    currentLogs.any((log) => log['bib'] == participant.bib);
                return GestureDetector(
                  onTap: () => logBib(participant.bib),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueGrey[200] : Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        participant.bib,
                        style: TextStyle(
                          fontSize: 18,
                          color: markedBibs.contains(participant.bib)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
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
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Center(child: Text('BIB'))),
                      DataColumn(label: Center(child: Text('Time'))),
                      DataColumn(label: Center(child: Text('Action'))),
                    ],
                    rows: currentLogs.map((log) {
                      return DataRow(cells: [
                        DataCell(SizedBox(
                          width: 80,
                          child: Center(child: Text(log['bib']!)),
                        )),
                        DataCell(SizedBox(
                          width: 120,
                          child: Center(child: Text(log['time']!)),
                        )),
                        DataCell(Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      markedBibs.contains(log['bib']!)
                                          ? Colors.green[300]
                                          : Colors.red[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(60, 30),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (markedBibs.contains(log['bib']!)) {
                                      markedBibs.remove(log['bib']!);
                                    } else {
                                      markedBibs.add(log['bib']!);
                                    }
                                  });
                                },
                                child: Text(
                                  markedBibs.contains(log['bib']!)
                                      ? 'Unmark'
                                      : 'Mark',
                                ),
                              ),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomActionButton(
                    label: 'Done',
                    onPressed: () {
                      final segmentProvider =
                          context.read<RaceSegmentProvider>();
                      final currentIndex =
                          segmentProvider.segments.indexOf(widget.segment);

                      // Check if previous segment exists and is completed
                      if (currentIndex > 0) {
                        final prevSegment =
                            segmentProvider.segments[currentIndex - 1];
                        if (prevSegment.status != SegmentStatus.completed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${prevSegment.type.name} is not completed yet.')),
                          );
                          return;
                        }
                      }

                      // Check if all visible participants are logged
                      final allLogged = participants.every(
                          (p) => currentLogs.any((log) => log['bib'] == p.bib));

                      if (allLogged) {
                        segmentProvider.updateSegmentStatus(
                            currentIndex, SegmentStatus.completed);
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

  Widget raceIcon(IconData icon, String label) {
    final isSelected = selectedRace.toLowerCase() == label.toLowerCase();
    return Column(
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
    );
  }
}
