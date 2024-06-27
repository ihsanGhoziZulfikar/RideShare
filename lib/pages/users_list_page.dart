import 'package:flutter/material.dart';
import 'package:ride_share/pages/chat_page.dart';
import 'package:ride_share/services/auth/auth_service.dart';
import 'package:ride_share/services/chat/chat_service.dart';

class UsersListPage extends StatelessWidget {
  UsersListPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      backgroundColor: Colors.white,
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersWithMessagesToCurrentUser(),
      // stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading ...');
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current
    if (userData['email'] != _authService.getCurrentUser()!.email)
      return ListTile(
        leading: Icon(Icons.person),
        title: Text(userData['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                receiverId: userData['uid'],
              ),
            ),
          );
        },
      );
    else {
      return Container();
    }
  }
}
