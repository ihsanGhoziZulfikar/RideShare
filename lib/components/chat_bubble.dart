import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: isCurrentUser ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
