import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
            icon: Iconify(
              '<svg xmlns="http://www.w3.org/2000/svg" width="1rem" height="1rem" viewBox="0 0 24 24"><defs><path id="letsIconsSendDuotone0" fill="#0077B6" d="m7.692 11.897l1.41.47c.932.31 1.397.466 1.731.8c.334.334.49.8.8 1.73l.47 1.41c.784 2.354 1.176 3.53 1.897 3.53c.72 0 1.113-1.176 1.897-3.53l2.838-8.512c.552-1.656.828-2.484.391-2.921c-.437-.437-1.265-.161-2.92.39l-8.515 2.84C5.34 8.887 4.162 9.279 4.162 10c0 .72 1.177 1.113 3.53 1.897"/></defs><use href="#letsIconsSendDuotone0" fill-opacity="0.25"/><use href="#letsIconsSendDuotone0" fill-opacity="0.25"/><path fill="#0077B6" d="m9.526 13.842l-2.062-.687a1 1 0 0 0-.87.116l-1.09.726a.8.8 0 0 0 .25 1.442l1.955.488a.5.5 0 0 1 .364.364l.488 1.955a.8.8 0 0 0 1.442.25l.726-1.09a1 1 0 0 0 .116-.87l-.687-2.062a1 1 0 0 0-.632-.632"/></svg>',
              size: 45,
            ),
          ),
        ],
      ),
    );
  }
}
