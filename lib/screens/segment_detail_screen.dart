import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/model/participant.dart';
import 'package:race_tracking_app/model/race_segment.dart';
import '../providers/participant_provider.dart';

class SegmentDetailsScreen extends StatefulWidget {
  final RaceSegment segment;

  const SegmentDetailsScreen({super.key, required this.segment});

  @override
  State<SegmentDetailsScreen> createState() => _SegmentDetailsScreenState();
}

class _SegmentDetailsScreenState extends State<SegmentDetailsScreen> {
  String selectedRace = 'Swim';

  Map<String, List<Map<String, String>>> loggedTimes = {
    'Swim': [],
    'Cycle': [],
    'Run': [],
  };

  void logBib(int bibNumber) {
    String currentTime = getCurrentFormattedTime();

    setState(() {
      bool alreadyLogged = loggedTimes[selectedRace]!
          .any((log) => log['bib'] == 'BIB $bibNumber');

      if (!alreadyLogged) {
        loggedTimes[selectedRace]!.add({
          'bib': 'BIB $bibNumber',
          'time': currentTime,
        });
      }
    });
  }

  void undoLog(String bib) {
    setState(() {
      loggedTimes[selectedRace]!.removeWhere((log) => log['bib'] == bib);
    });
  }

  String getCurrentFormattedTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final participants = context.watch<ParticipantProvider>().participants;
    final currentLogs = loggedTimes[selectedRace]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.segment.type.name.toUpperCase()),
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
            // Race Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                raceButton(Icons.pool, 'Swim'),
                raceButton(Icons.directions_bike, 'Cycle'),
                raceButton(Icons.directions_run, 'Run'),
              ],
            ),
            const SizedBox(height: 20),

            // Dynamic BIB Grid from participants
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10
              ),
              itemBuilder: (context, index) {
                final participant = participants[index];
                bool isSelected = currentLogs.any((log) => log['bib'] == 'BIB ${participant.bib}');
                return GestureDetector(
                  onTap: () => logBib(int.parse(participant.bib)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueGrey[200] : Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${participant.bib}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Logged Time Table
            const Text('Logged time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                actionButton('Pause', onPressed: () {
                  // TODO: implement pause logic
                }),
                actionButton('Done', onPressed: () {
                  // TODO: implement done logic
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
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRace = label;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? Colors.blueGrey[100] : Colors.transparent,
            radius: 30,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget actionButton(String label, {required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: const Size(120, 50),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}
