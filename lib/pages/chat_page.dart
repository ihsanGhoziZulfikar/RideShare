import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/components/chat_bubble.dart';
import 'package:ride_share/components/my_textfield.dart';
import 'package:ride_share/services/auth/auth_service.dart';
import 'package:ride_share/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.SendMessage(receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderId, receiverId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages"));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    // align
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // return ChatBubble(message: data['message'], isCurrentUser: isCurrentUser);
    return Container(
        alignment: alignment,
        child:
            ChatBubble(message: data['message'], isCurrentUser: isCurrentUser));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "message",
              obscureText: false,
              controller: _messageController,
              prefixIcon: Icons.face_5_outlined,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.arrow_circle_right_rounded),
          ),
        ],
      ),
    );
  }
}
