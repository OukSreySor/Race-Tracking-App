import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/model/race_segment.dart';
import 'package:race_tracking_app/providers/race_segment_provider.dart';
import 'package:race_tracking_app/screens/segment_detail_screen.dart';
import 'package:race_tracking_app/widgets/actions/segment_card.dart';
import 'package:race_tracking_app/widgets/actions/start_stop_button.dart';
import '../providers/participant_provider.dart';
import '../providers/race_log_provider.dart';
import '../theme/theme.dart';
import '../widgets/actions/custom_bottom_navigation_bar.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    final segmentProvider = context.watch<RaceSegmentProvider>();
    final _hasParticipants =
        context.watch<ParticipantProvider>().hasParticipants;

    void _onStart() {
      context.read<RaceSegmentProvider>().startRace();
    }

    void _onStop() {
      context.read<RaceSegmentProvider>().reset();
      context.read<RaceLogProvider>().reset();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All race data has been reset.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 20),
            Text(
              'Racing',
              style: TextStyle(
                color: RaceColors.black,
                fontSize: RaceTextStyles.heading.fontSize,
                fontWeight: RaceTextStyles.heading.fontWeight,
              ),
            ),
          ],
        ),
        backgroundColor: RaceColors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                StartButton(
                  onStart: _onStart,
                  onStop: _onStop,
                  hasParticipants: _hasParticipants,
                ),
                const SizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: segmentProvider.segments.length,
                  itemBuilder: (context, index) {
                    final segment = segmentProvider.segments[index];
                    return RaceSegmentCard(
                      segment: segment,
                      onTap: segment.status == SegmentStatus.inProgress
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SegmentDetailsScreen(segment: segment),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBottomNavigationBar(),
      ),
    );
  }
}
