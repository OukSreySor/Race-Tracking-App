import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';

import 'package:race_tracking_app/screens/add_participant_screen.dart';
import 'package:race_tracking_app/widgets/actions/custom_action_button.dart';
import 'package:race_tracking_app/widgets/actions/custom_bottom_navigation_bar.dart';

import '../theme/theme.dart';

class ParticipantListScreen extends StatefulWidget {
  const ParticipantListScreen({super.key});

  @override
  State<ParticipantListScreen> createState() => _ParticipantListScreenState();
}

class _ParticipantListScreenState extends State<ParticipantListScreen> {
  @override
  Widget build(BuildContext context) {
    final participantProvider = Provider.of<ParticipantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 16), 
            Text('Participant List',
                style: TextStyle(
                    color: RaceColors.black,
                    fontSize: RaceTextStyles.heading.fontSize,
                    fontWeight: RaceTextStyles.heading.fontWeight)),
          ],
        ),
        backgroundColor: RaceColors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomActionButton(
                label: 'Add new participant',
                icon: Icons.add,
                backgroundColor: Color(0xFFECEFCA),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddParticipantScreen()));
                },
              ),
              const SizedBox(height: 16),
              participantProvider.participants.isEmpty
                  ? Center(child: Text('No participants yet'))
                  : Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(2),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFECEFCA)),
                          children: [
                            tableCell('BIB', isHeader: true),
                            tableCell('Name', isHeader: true),
                            tableCell('Gender', isHeader: true),
                          ],
                        ),
                        for (var participant
                            in participantProvider.participants)
                          TableRow(
                            children: [
                              tableCell(participant.bib),
                              tableCell(participant.name),
                              tableCell(participant.gender),
                            ],
                          ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: isHeader ? TextStyle(fontWeight: FontWeight.bold) : null,
      ),
    );
  }
}
