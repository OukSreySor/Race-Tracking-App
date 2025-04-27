
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/bottom_nav_provider.dart';
import 'package:race_tracking_app/screens/add_participant_screen.dart';
import 'package:race_tracking_app/screens/home_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({super.key});

  final List<IconData> _icons = [
    Icons.group,
    Icons.play_circle_outline,
    Icons.golf_course_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, bottomNavProvider, child) {
        return Container(
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Color(0xFF547792),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final isSelected = bottomNavProvider.selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  bottomNavProvider.setSelectedIndex(index);
                  if (index == 0) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ParticipantListScreen()));
                  } else if (index == 1) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipantScreen())); //example
                  } else if (index == 2) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipantScreen())); //example
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 68.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                  child: Icon(
                    _icons[index],
                    color: isSelected ? Color(0xFF547792) : Colors.white,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
