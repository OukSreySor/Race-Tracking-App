import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/firebase_options.dart';
import 'package:race_tracking_app/providers/race_segment_provider.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/participant_provider.dart';
import 'screens/home_screen.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );   
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider()),      
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
