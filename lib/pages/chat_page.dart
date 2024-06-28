import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:ride_share/components/chat_bubble.dart';
import 'package:ride_share/components/my_textfield.dart';
import 'package:ride_share/services/auth/auth_service.dart';
import 'package:ride_share/services/chat/chat_service.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(seconds: 1),
          () => scrollDown(),
        );
      }
    });

    // scroll on open
    Future.delayed(
      const Duration(seconds: 1),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.SendMessage(
          widget.receiverId, _messageController.text);
      _messageController.clear();
      Future.delayed(
        const Duration(seconds: 1),
        () => scrollDown(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10,
              bottom: 15,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.receiverEmail,
                  style: TextStyle(
                    fontFamily: 'Kantumruy',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(timestamp);
    } else {
      return DateFormat('d MMMM yyyy').format(timestamp);
    }
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    DateTime? previousTimestamp;

    return StreamBuilder(
      stream: _chatService.getMessages(senderId, widget.receiverId),
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

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final currentTimestamp = (doc['timestamp'] as Timestamp).toDate();
            String? startDateString;

            if (previousTimestamp == null ||
                !isSameDay(previousTimestamp!, currentTimestamp)) {
              startDateString = formatTimestamp(currentTimestamp);
            }

            previousTimestamp = currentTimestamp;

            return _buildMessageItem(doc, startDateString);
          },
        );
      },
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildMessageItem(DocumentSnapshot doc, String? startDateString) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(
        message: data['message'],
        isCurrentUser: isCurrentUser,
        timestamp: timestamp,
        startDateString: startDateString,
      ),
    );
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
              focusNode: myFocusNode,
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
