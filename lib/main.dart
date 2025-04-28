import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/race_segment_provider.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/participant_provider.dart';
import 'repositories/mock_participant_repository.dart';
import 'screens/home_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider(MockParticipantRepository())),      
        ChangeNotifierProvider(create: (_) => BottomNavProvider()), 
        ChangeNotifierProvider(create: (_) => RaceSegmentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: ParticipantListScreen(),
    );
  }
}
