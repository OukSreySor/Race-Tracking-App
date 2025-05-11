 import 'package:flutter/material.dart';
import 'package:race_tracking_app/theme/theme.dart';

class CustomActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
   final Alignment alignment;

  const CustomActionButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              ),
              child: Text(label, style: TextStyle(color: RaceColors.neutralDark)),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              ),
              icon: Icon(icon, color: RaceColors.neutralDark),
              label: Text(label, style: TextStyle(color: RaceColors.neutralDark)),
            ),
    
    );
  }
}