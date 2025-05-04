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
      body: Padding(
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
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<ParticipantProvider>(
                builder: (context, provider, child) {
                  if (provider.participants.isEmpty) {
                    return const Center(child: Text('No participants yet'));
                  }
                  return ListView.builder(
                    itemCount: provider.participants.length,
                    itemBuilder: (context, index) {
                      final participant = provider.participants[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                participant.bib,
                                style: const TextStyle(
                                  color: Color(0xFF1FDAE1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(participant.name, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 24),
                              Text(participant.gender),
                              const SizedBox(width: 24),
                              Expanded(child: Text(participant.age.toString())),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddParticipantScreen(
                                        participant: participant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Participant'),
                                      content: const Text('Are you sure you want to delete this participant?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Provider.of<ParticipantProvider>(context, listen: false)
                                                .removeParticipant(participant.id);
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  );
                }
                
              )
            )
          ]   
        )
      ),
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBottomNavigationBar(),
      ),
    );
  }
}
