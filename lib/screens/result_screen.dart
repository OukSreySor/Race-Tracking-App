import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/race_log_provider.dart';
import '../providers/participant_provider.dart';
import '../widgets/actions/custom_bottom_navigation_bar.dart';


class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Duration parseTime(String time) {
    try {
      final parts = time.split(':').map(int.parse).toList();
      return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
    } catch (_) {
      return Duration.zero;
    }
  }

  String formatDuration(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = context.watch<RaceLogProvider>();
    final participants = context.watch<ParticipantProvider>().participants;

    final swimLogs = logProvider.getLogs('swim');
    final cycleLogs = logProvider.getLogs('cycle');
    final runLogs = logProvider.getLogs('run');

    List<Map<String, String>> resultData = participants.map((p) {
      final bib = 'BIB ${p.bib}';
      final swimTime = swimLogs.firstWhere((l) => l['bib'] == bib, orElse: () => {})['time'] ?? '00:00:00';
      final cycleTime = cycleLogs.firstWhere((l) => l['bib'] == bib, orElse: () => {})['time'] ?? '00:00:00';
      final runTime = runLogs.firstWhere((l) => l['bib'] == bib, orElse: () => {})['time'] ?? '00:00:00';

      final totalDuration = parseTime(swimTime) +
          parseTime(cycleTime) +
          parseTime(runTime);

      return {
        'bib': p.bib,
        'total': formatDuration(totalDuration),
        'totalSeconds': totalDuration.inSeconds.toString(),
      };
    }).toList();

    // Sort by total duration (ascending)
    resultData.sort((a, b) =>
        int.parse(a['totalSeconds']!).compareTo(int.parse(b['totalSeconds']!)));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Results',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'RANK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'BIB',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'TIME',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            ...List.generate(resultData.length, (index) {
              final result = resultData[index];
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      result['bib']!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      result['total']!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBottomNavigationBar(),
      ),
    );
  }
}
