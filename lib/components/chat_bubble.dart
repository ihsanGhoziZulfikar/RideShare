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
          color: isCurrentUser ? Color(0xff90E0EF) : Color(0xff00B4D8),
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        message,
        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
