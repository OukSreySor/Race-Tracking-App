import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/bottom_nav_provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/repositories/mock_participant_repository.dart';
import 'package:race_tracking_app/screens/home_screen.dart';
import 'package:race_tracking_app/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider(MockParticipantRepository())),      
        ChangeNotifierProvider(create: (_) => BottomNavProvider()), 
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
