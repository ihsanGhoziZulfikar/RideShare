import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class MyMainFeatureOption extends StatelessWidget {
  final String svgIcon;
  final double iconSize;
  final String label;
  final Color color;
  final VoidCallback onTap;

  MyMainFeatureOption({
    required this.svgIcon,
    required this.iconSize,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 141,
        height: 126,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              svgIcon,
              size: iconSize,
            ),
            SizedBox(height: 5), // add some space between the icon and the text
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Kantumruy',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
