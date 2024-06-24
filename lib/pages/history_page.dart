import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is history page",
        style: TextStyle(
          fontSize: 45,
          color: Colors.black,
        ),
      ),
    );
  }
}
