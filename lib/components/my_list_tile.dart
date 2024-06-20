// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  // final Timestamp timestamp;
  final DateTime timestamp;

  String _formatTwoDigitNumber(int number) {
    // Helper function to format a number with two digits
    return number.toString().padLeft(2, '0');
  }

  const MyListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // DateTime dateTime = timestamp.toDate();
    DateTime dateTime = timestamp;
    String formattedTimestamp =
        "${dateTime.year}-${_formatTwoDigitNumber(dateTime.month)}-${_formatTwoDigitNumber(dateTime.day)} ${_formatTwoDigitNumber(dateTime.hour)}:${_formatTwoDigitNumber(dateTime.minute)}:${_formatTwoDigitNumber(dateTime.second)}";

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(formattedTimestamp),
    );
  }
}
