import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final DateTime timestamp;
  final String? startDateString;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
    this.startDateString,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('HH:mm').format(timestamp);

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (startDateString != null)
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                startDateString!,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrentUser) ...[
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 5),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser ? Color(0xff90E0EF) : Color(0xff00B4D8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              if (!isCurrentUser) ...[
                SizedBox(width: 5),
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
